import 'dart:async';
import 'package:boots/blocs/GoogleMapServices.dart';
import 'package:boots/blocs/place_bloc.dart';
import 'package:boots/helper/theme.dart';
import 'package:boots/model/PlaceDetailModel.dart';
import 'package:boots/model/map_type_model.dart';
import 'package:boots/model/requests_model.dart';
import 'package:boots/page/map_test/directions.dart';
import 'package:boots/widgets/customWidgets.dart';
import 'package:boots/widgets/newWidget/customLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:boots/model/directions_model.dart';
import 'package:boots/model/google_map_helper.dart';
import 'package:boots/model/place_item.dart';
import 'package:boots/theme/style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final String screenName = "Rides";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  var googleMapServices;
  CircleId selectedCircle;
  GoogleMapController _mapController;
  PlaceDetail _toPlaceDetail;
  RequestsModel requestsModel;
  var _destination;
  var sessionToken = TimeOfDay.now().toString();
  TextEditingController destinationController = TextEditingController();
  String currentLocationName;
  String newLocationName;
  String _placemark = '';
  GoogleMapController mapController;
  PlaceItemRes fromAddress;
  PlaceItemRes toAddress;
  bool checkPlatform = Platform.isIOS;
  double distance = 0;
  bool nightMode = false;
  VoidCallback showPersBottomSheetCallBack;
  List<MapTypeModel> sampleData = new List<MapTypeModel>();
  PersistentBottomSheetController _controller;
  bool _enableSearchButton = false;
  List<Routes> routesData;
  final GMapViewHelper _gMapViewHelper = GMapViewHelper();
  Map<PolylineId, Polyline> _polyLines = <PolylineId, Polyline>{};
  PolylineId selectedPolyline;
  bool isShowDefault = false;
  bool noConnection = false;
  Position currentLocation;
  Position _lastKnownPosition;
  SharedPreferences sharedPreferences;
  List listRequest = [];
  int requestsCount;
  CustomLoader customLoader = new CustomLoader();

  final Geolocator _locationService = Geolocator();
  PermissionStatus permission;

  refresh() {

  }

  checkConnection() {

  }

  @override
  void initState() {
    super.initState();
    fetchLocation();
    //setupTimedFetch();
    showPersBottomSheetCallBack = _showBottomSheet;
  }

  /*setupTimedFetch() {
    Timer.periodic(Duration(milliseconds: 30000), (timer) {
      print('-----Periodic Print------');
      periodic_get_new_requests();
    });
  }*/

  @override
  void dispose() {
    super.dispose();
  }

  void fetchLocation(){
    _initCurrentLocation();
  }

  /// Get current location
  Future<void> _initCurrentLocation() async {
    try{
      currentLocation = await _locationService.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      List<Placemark> placemarks = await _locationService.placemarkFromCoordinates(currentLocation?.latitude, currentLocation?.longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        final Placemark pos = placemarks[0];
        setState(() {
          _placemark = pos.name + ', ' + pos.thoroughfare;
          print(_placemark);
          currentLocationName = _placemark;
        });
      }
      if(currentLocation != null){
        moveCameraToMyLocation();
      }
    } catch(e) {

    }
  }

  void moveCameraToMyLocation(){
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation?.latitude,currentLocation?.longitude),
          zoom: 17.0,
        ),
      ),
    );
  }

  void moveCameraToSelectedLocation(latitude, longitude){
    _mapController?.animateCamera(
      CameraUpdate?.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 17.0,
        ),
      ),
    );
    setState(()  => _enableSearchButton = true );
  }


  void _onMapCreated(GoogleMapController controller) async {
    this._mapController = controller;
  }

  Future<String> _getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  void _setMapStyle(String mapStyle) {
    setState(() {
      nightMode = true;
      _mapController.setMapStyle(mapStyle);
    });
  }

  void changeMapType(int id, String fileName){
    print(fileName);
    if (fileName == null) {
      setState(() {
        nightMode = false;
        _mapController.setMapStyle(null);
      });
    } else {
      _getFileData(fileName).then(_setMapStyle);
    }
  }

  void _showBottomSheet() async {
    setState(() {
      showPersBottomSheetCallBack = null;
    });
    _controller = await _scaffoldKey.currentState
        .showBottomSheet((context) {
      return new Container(
          height: 300.0,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text("Map type",style: heading18Black,),
                    ),
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.close,color: blackColor,),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
      );
    });
  }

  void _closeModalBottomSheet() {
    if (_controller != null) {
      _controller.close();
      _controller = null;
    }
  }

  addMarker(LatLng locationForm, LatLng locationTo){
    _markers.clear();
    final MarkerId _markerFrom = MarkerId("fromLocation");
    final MarkerId _markerTo = MarkerId("toLocation");
    _markers[_markerFrom] = GMapViewHelper.createMaker(
      markerIdVal: "fromLocation",
      icon: checkPlatform ? "assets/image/gps_point_24.png" : "assets/image/gps_point.png",
      lat: locationForm.latitude,
      lng: locationForm.longitude,
    );

    _markers[_markerTo] = GMapViewHelper.createMaker(
      markerIdVal: "toLocation",
      icon: checkPlatform ? "assets/image/ic_marker_32.png" : "assets/image/ic_marker_128.png",
      lat: locationTo.latitude,
      lng: locationTo.longitude,
    );
    _gMapViewHelper?.cameraMove(fromLocation: locationForm,toLocation: locationTo,mapController: _mapController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          backgroundColor: green2,
          title: customTitleText(
            'Navigation',
          )
      ),
      body: Container(
        color: whiteColor,
        child: Stack(
          children: <Widget>[
            _buildMapLayer(),
            Positioned(
                bottom: isShowDefault == false ? 330 : 250,
                right: 16,
                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100.0),),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.my_location,size: 20.0,color: blackColor,),
                    onPressed: (){
                      _initCurrentLocation();
                    },
                  ),
                )
            ),

            Positioned(
                bottom: 20,
                right: 30,
                left: 30,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                  ),
                  onPressed: () {
                    _processNavigation();
                  },
                  child: Text('Navigate', style: TextStyle(color: whiteColor, fontSize: 17, fontWeight: FontWeight.bold),),
                  color: AppColor.primary,
                )
            ),

            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50),
                  ), color: whiteColor ),
                  height: 50,
                  child: _searchForm(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _processNavigation() {
    if(destinationController.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Enter destination address', backgroundColor: redColor);
      return;
    }

    if(_toPlaceDetail  == null) {
      customSnackBar(_scaffoldKey, 'Unable to process destination. Make sure you are connected to internet.', backgroundColor: redColor);
      return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Directions(
      fromLocation: LatLng(currentLocation.latitude, currentLocation.longitude),
      toLocation: LatLng(_toPlaceDetail.lat, _toPlaceDetail.lng),
    )));
  }

  Widget _searchForm() {
    return TypeAheadField(
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: Colors.white
      ),
      hideOnEmpty:true,
      hideOnLoading: true,
      transitionBuilder: (context, suggestionsBox, animationController) =>
          FadeTransition(
            child: suggestionsBox,
            opacity: CurvedAnimation(
                parent: animationController,
                curve: Curves.fastOutSlowIn
            ),
          ),
      direction: AxisDirection.down,
      debounceDuration: Duration(milliseconds: 100),
      textFieldConfiguration: TextFieldConfiguration(
        controller: destinationController,
        autofocus: false,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Where are you headed?',
          border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
        ),
      ),
      suggestionsCallback: (pattern) async {
        googleMapServices = GoogleMapServices(sessionToken: sessionToken);
        return await googleMapServices.getSuggestions(pattern);
      },

      itemBuilder: (context, suggestion) {
        return ListTile(
          contentPadding: EdgeInsets.all(10.0),
          title: Text(
            suggestion.description,
            style: TextStyle(fontSize: 11),
          ),
        );
      },

      onSuggestionSelected: (suggestion) async {
        destinationController.text = suggestion.description;
        _toPlaceDetail = await googleMapServices.getPlaceDetail(suggestion.placeId, sessionToken);
        sessionToken = null;
        final PlaceBloc placeBloc = Provider.of<PlaceBloc>(context, listen: false);
        //placeBloc.locationSelect =
        //_destination = selectLocation(name: _toPlaceDetail.name, latitude: _toPlaceDetail.lat, longitude: _toPlaceDetail.lng);
        moveCameraToSelectedLocation(_toPlaceDetail.lat, _toPlaceDetail.lng);
      },
    );
  }

  Widget _buildMapLayer(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: _gMapViewHelper.buildMapView(
          context: context,
          onMapCreated: _onMapCreated,
          currentLocation: LatLng(
              currentLocation != null ? currentLocation?.latitude : _lastKnownPosition?.latitude ?? 0.0,
              currentLocation != null ? currentLocation?.longitude : _lastKnownPosition?.longitude ?? 0.0),
          markers: _markers,
          polyLines: _polyLines,
          onTap: (_){
          }
      ),
    );
  }
}
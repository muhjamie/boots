import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:boots/components/loading.dart';
import 'package:boots/model/directions_model.dart';
import 'package:boots/model/get_routes_request_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:boots/model/google_map_helper.dart';
import 'package:boots/model/networking/Apis.dart';
import 'package:boots/model/sliding_up_panel.dart';
import 'package:boots/theme/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'stepsPartView.dart';
import 'imageSteps.dart';

class Directions extends StatefulWidget {
  final LatLng fromLocation;
  final LatLng toLocation;

  const Directions({Key key, this.fromLocation, this.toLocation}) : super(key: key);

  @override
  _DirectionsState createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {
  var apis = Apis();
  GoogleMapController _mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  SharedPreferences sharedPreferences;
  Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;
  bool checkPlatform = Platform.isIOS;
  bool _isBusy = false;
  LatLng currentLocation = LatLng(39.155232, -95.473636);

  String distance, duration;
  List<Routes> routesData;

  final GMapViewHelper _gMapViewHelper = GMapViewHelper();

  void _onMapCreated(GoogleMapController controller) {
    this._mapController = controller;
    addMarker();
    getRouter();
  }


  addMarker(){
    final MarkerId _markerFrom = MarkerId("fromLocation");
    final MarkerId _markerTo = MarkerId("toLocation");
    markers[_markerFrom] = GMapViewHelper.createMaker(
      markerIdVal: "fromLocation",
      icon: checkPlatform ? "assets/image/gps_point_24.png" : "assets/image/gps_point.png",
      lat: widget?.fromLocation?.latitude,
      lng: widget?.fromLocation?.longitude,
    );

    markers[_markerTo] = GMapViewHelper.createMaker(
      markerIdVal: "toLocation",
      icon: checkPlatform ? "assets/image/ic_marker_32.png" : "assets/image/ic_marker_128.png",
      lat: widget?.toLocation?.latitude,
      lng: widget?.toLocation?.longitude,
    );
  }

  void getRouter() async {
    setState(() {
      _isBusy = true;
    });
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    final PolylineId polylineId = PolylineId(polylineIdVal);
    polyLines.clear();
    var router;

    await apis.getRoutes(
      getRoutesRequest: GetRoutesRequestModel(
          fromLocation: widget?.fromLocation,
          toLocation: widget?.toLocation,
          mode: "driving"
      ),
    ).then((data) {
      if (data != null) {
        router = data.result.routes[0].overviewPolyline.points;
        routesData = data.result.routes;
      }
    }).catchError((error) {
      print("DiscoveryActionHandler::GetRoutesRequest > $error");
    });

    distance = routesData[0].legs[0].distance.text;
    duration = routesData[0].legs[0].duration.text;

    polyLines[polylineId] = GMapViewHelper.createPolyline(
      polylineIdVal: polylineIdVal,
      router: router,
      formLocation: widget?.fromLocation,
      toLocation: widget?.toLocation,
    );
    _gMapViewHelper.cameraMove(fromLocation: widget?.fromLocation,toLocation: widget?.toLocation,mapController: _mapController);
    setState(() { _isBusy = false; });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildInfoLayer(),
        ],
      ),
    );
  }

  Widget _buildInfoLayer(){
    final screenSize = MediaQuery.of(context).size;
    final maxHeight = 0.70*screenSize.height;
    final minHeight = 130.0;

    final panel =
    Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            _isBusy == true ? LoadingBuilder() : Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(duration ?? '',style: headingBlack,),
                          ],
                        ),
                        Text(distance ?? '',style: textStyle,),
                      ],
                    ),
                  ),
                  Container(
                    width: 70.0,
                    child: ButtonTheme(
                      minWidth: 50,
                      height: 35.0,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        elevation: 0.0,
                        color: redColor,
                        child: Text('Exit'.toUpperCase(),style: heading18,
                        ),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
//          Container(
//            padding: EdgeInsets.only(top: 10.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                GestureDetector(
//                  onTap: (){
//                    print("Reset");
//                  },
//                  child: Container(
//                    height: 40,
//                    width: 40,
//                    margin: EdgeInsets.only(left: 10.0,right: 10.0),
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(50.0),
//                      color: primaryColor,
//                    ),
//                    child: Icon(Icons.arrow_back_ios,color: whiteColor,),
//                  ),
//                ),
//                GestureDetector(
//                  onTap: (){
//                    print("Reset");
//                  },
//                  child: Container(
//                    height: 40,
//                    width: 40,
//                    margin: EdgeInsets.only(left: 10.0,right: 10.0),
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(50.0),
//                      color: primaryColor,
//                    ),
//                    child: Icon(Icons.arrow_forward_ios,color: whiteColor,),
//                  ),
//                ),
//              ],
//            ),
//          ),

            Divider(),
            Expanded(
              child:
              routesData != null ?
              ListView.builder(
                shrinkWrap: true,
                itemCount: routesData[0].legs[0].steps.length,
                itemBuilder: (BuildContext context, index){
                  return StepsPartView(
                    instructions: routesData[0].legs[0].steps[index].htmlInstructions,
                    duration: routesData[0].legs[0].steps[index].duration.text,
                    imageManeuver: getImageSteps(routesData[0].legs[0].steps[index].maneuver),
                  );
                },
              ): Container(
                child: LoadingBuilder(),
              ),
            )
          ],
        )
    );

    return SlidingUpPanel(
      maxHeight: maxHeight,
      minHeight: minHeight,
      parallaxEnabled: true,
      parallaxOffset: .5,
      panel: panel,
      body: _buildMapLayer(),
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      onPanelSlide: (double pos) => setState(() {
      }),
    );
  }

  Widget _buildMapLayer(){
    return currentLocation == null ?
    Center(child: CupertinoActivityIndicator())
        : SizedBox(
      height: MediaQuery.of(context).size.height,
      child: _gMapViewHelper.buildMapView(
          context: context,
          onMapCreated: _onMapCreated,
          currentLocation: currentLocation,
          markers: markers,
          polyLines: polyLines,
          onTap: (_){

          }
      ),
    );
  }
}

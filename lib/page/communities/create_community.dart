import 'dart:io';
import 'package:boots/helper/helper_functions.dart';
import 'package:boots/helper/theme.dart';
import 'package:boots/helper/utility.dart';
import 'package:boots/state/authState.dart';
import 'package:boots/state/communitiesState.dart';
import 'package:boots/theme/style.dart';
import 'package:boots/widgets/customAppBar.dart';
import 'package:boots/widgets/customWidgets.dart';
import 'package:boots/widgets/newWidget/customLoader.dart';
import 'package:boots/widgets/newWidget/title_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class CreateCommunity extends StatefulWidget {

  @override
  _CreateCommunityState createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _communityNameController;
  TextEditingController _communityDescriptionController;
  CustomLoader loader = new CustomLoader();
  FirebaseUser _user;
  File _image;
  String _iconURL;
  String _communityName;
  bool _isBusy = false;

  void initState() {
    _communityNameController = TextEditingController();
    _communityDescriptionController = TextEditingController();
    super.initState();
  }

  void imagePicker() {
    openImagePicker(context, (file) {
      setState(() {
        _image = file;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Create Community',
        ),
      ),
      body: _isBusy ? loader.showLoader(context) : _body(context),
    );
  }

  _processCreateCommunity() async {
    if(_image == null) {
      customSnackBar(_scaffoldKey, 'Select community icon or image', backgroundColor: redColor);
      return;
    }

    if(_communityNameController.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Enter community name', backgroundColor: redColor);
      return;
    }

    if(_communityDescriptionController.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Enter community description', backgroundColor: redColor);
      return;
    }

    loader.showLoader(context);
    StorageReference storageReference = FirebaseStorage.instance.ref().child('communities/icons/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete.then((value) {
      storageReference.getDownloadURL().then((fileURL) async {
        _createCommunity(fileURL);
      });
    });
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 100),
            _communityImage(),
            SizedBox(height: 20),
            _entryField('Community name', controller: _communityNameController, isPassword: false),
            _entryField('Community description', controller: _communityDescriptionController, isPassword: false),
            _submitButton(context),
            Divider(
              height: 30,
            ),
            SizedBox(
              height: 30,
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      width: fullWidth(context),
      margin: EdgeInsets.symmetric(vertical: 35),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: BootsColor.green,
        onPressed: () => _processCreateCommunity(),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: TitleText('Submit', color: Colors.white),
      ),
    );
  }

  _createCommunity(String iconURL) async {
    print(_communityNameController.text);
    await HelperFunctions.getUserNameSharedPreference().then((val) async {
      _user = await _firebaseAuth.currentUser();
      if (_user != null) {
        final communityState = Provider.of<CommunitiesState>(context, listen: false);
        communityState.createCommunity(_communityNameController.text, _user.uid, _communityDescriptionController.text, iconURL);
      }
    });
    Navigator.of(context).pop();
    loader.hideLoader();
  }

  Widget _entryField(String hint, {TextEditingController controller, bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.green)),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }
  Widget _communityImage() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5),
          shape: BoxShape.circle,
          image: DecorationImage(
              image: customAdvanceNetworkImage('https://www.pngitem.com/pimgs/m/153-1538773_community-service-png-community-service-logo-png-transparent.png'),
              fit: BoxFit.cover),
        ),
        child: CircleAvatar(
          radius: 40,
          backgroundImage: _image != null ? FileImage(_image) : customAdvanceNetworkImage('https://www.pngitem.com/pimgs/m/153-1538773_community-service-png-community-service-logo-png-transparent.png'),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
            ),
            child: Center(
              child: IconButton(
                onPressed: () => imagePicker(),
                icon: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

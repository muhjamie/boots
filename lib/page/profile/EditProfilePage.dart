import 'dart:io';
import 'package:flutter/material.dart';
import 'package:boots/helper/utility.dart';
import 'package:boots/state/authState.dart';
import 'package:boots/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key key}) : super(key: key);
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File _image;
  TextEditingController _userName;
  TextEditingController _name;
  TextEditingController _bio;
  TextEditingController _location;
  TextEditingController _stateOfDeployment;
  TextEditingController _localGovt;
  TextEditingController _ppa;
  TextEditingController _dob;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String dob;
  @override
  void initState() {
    _userName = TextEditingController();
    _name = TextEditingController();
    _bio = TextEditingController();
    _location = TextEditingController();
    _dob = TextEditingController();
    _stateOfDeployment = TextEditingController();
    _localGovt = TextEditingController();
    _ppa = TextEditingController();
    var state = Provider.of<AuthState>(context, listen: false);
    _userName.text = state?.userModel?.userName;
    _name.text = state?.userModel?.displayName;
    _bio.text = state?.userModel?.bio;
    _location.text = state?.userModel?.location;
    _dob.text = getdob(state?.userModel?.dob);
    _stateOfDeployment.text = state?.userModel?.stateOfDeployment;
    _localGovt.text = state?.userModel?.localGovt;
    _ppa.text = state?.userModel?.ppa;
    super.initState();
  }
  void dispose() { 
    _name.dispose();
    _bio.dispose();
    _location.dispose();
    _dob.dispose();
    _localGovt.dispose();
    _ppa.dispose();
    _stateOfDeployment.dispose();
    super.dispose();
  }
  Widget _body() {
    var authstate = Provider.of<AuthState>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
            height: 100,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: _userImage(authstate),
                ),
              ],
            )),
        _entry('Username', controller: _userName, isReadOnly: true),
        _entry('Name', controller: _name),
        _entry('Bio', controller: _bio, maxLine: null),
        InkWell(
          onTap: showCalender,
          child: _entry('Date of birth', isenable: false, controller: _dob),
        ),
        _entry('State of Deployment', controller: _stateOfDeployment),
        _entry('Local Government', controller: _localGovt),
        _entry('Place of Primary Assignment', controller: _ppa),
      ],
    );
  }

  Widget _userImage(AuthState authstate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: customAdvanceNetworkImage(authstate.userModel.profilePic),
            fit: BoxFit.cover),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: _image != null
            ? FileImage(_image)
            : customAdvanceNetworkImage(authstate.userModel.profilePic),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Center(
            child: IconButton(
              onPressed: uploadImage,
              icon: Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _entry(String title,
      {TextEditingController controller,
      int maxLine = 1,
      bool isenable = true, bool isReadOnly = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: TextStyle(color: Colors.black54)),
          TextField(
            readOnly: isReadOnly,
            enabled: isenable,
            controller: controller,
            maxLines: maxLine,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          )
        ],
      ),
    );
  }

  void showCalender() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2019, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(1950, DateTime.now().month, DateTime.now().day + 3),
      lastDate: DateTime.now().add(Duration(days: 7)),
    );
    setState(() {
      if (picked != null) {
        dob = picked.toString();
        _dob.text = getdob(dob);
      }
    });
  }

  void _submitButton() {
    if (_name.text.length > 27) {
      customSnackBar(_scaffoldKey, 'Name length cannot exceed 27 character');
      return;
    }
    var state = Provider.of<AuthState>(context, listen: false);
    var model = state.userModel.copyWith(
      key: state.userModel.userId,
      ppa: state.userModel.ppa,
      localGovt: state.userModel.localGovt,
      stateOfDeployment: state.userModel.stateOfDeployment,
      userName: state.userModel.userName,
      displayName: state.userModel.displayName,
      bio: state.userModel.bio,
      contact: state.userModel.contact,
      dob: state.userModel.dob,
      email: state.userModel.email,
      location: state.userModel.location,
      profilePic: state.userModel.profilePic,
      userId: state.userModel.userId,
    );
    if (_userName.text != null && _userName.text.isNotEmpty) {
      model.userName = _userName.text;
    }
    if (_name.text != null && _name.text.isNotEmpty) {
      model.displayName = _name.text;
    }
    if (_bio.text != null && _bio.text.isNotEmpty) {
      model.bio = _bio.text;
    }
    if (_location.text != null && _location.text.isNotEmpty) {
      model.location = _location.text;
    }
    if (_ppa.text != null && _ppa.text.isNotEmpty) {
      model.ppa = _ppa.text;
    }

    if (_localGovt.text != null && _localGovt.text.isNotEmpty) {
      model.localGovt = _localGovt.text;
    }

    if (_stateOfDeployment.text != null && _stateOfDeployment.text.isNotEmpty) {
      model.stateOfDeployment = _stateOfDeployment.text;
    }

    if (dob != null) {
      model.dob = dob;
    }
    state.updateUserProfile(model, image: _image);
    Navigator.of(context).pop();
  }

  void uploadImage() {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
        title: customTitleText('Profile Edit'),
        actions: <Widget>[
          InkWell(
            onTap: _submitButton,
            child: Center(
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }
}
 import 'package:boots/helper/constant.dart';
import 'package:boots/helper/helper_functions.dart';
 import 'package:boots/helper/theme.dart';
import 'package:boots/services/groups/auth_service.dart';
import 'package:boots/services/groups/database_service.dart';
 import 'package:boots/state/communitiesState.dart';
 import 'package:boots/widgets/customWidgets.dart';
 import 'package:boots/widgets/group_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
 import 'package:flutter/material.dart';
 import 'package:provider/provider.dart';

 class CommunitiesPage extends StatefulWidget {
   final GlobalKey<ScaffoldState> scaffoldKey;

  const CommunitiesPage({Key key, this.scaffoldKey}) : super(key: key);

   @override
   _CommunitiesPageState createState() => _CommunitiesPageState();
 }

 class _CommunitiesPageState extends State<CommunitiesPage> with
     TickerProviderStateMixin {
   bool _isComEmpty = false;
   // data
   final AuthService _auth = AuthService();
   String _userid;
   FirebaseUser _user;
   String _groupName;
   String _userName = '';
   String _email = '';
   Stream _communities;
   CommunitiesState _communitiesState;
   List<Tab> tabList = List();
   TabController _tabController;


   // initState
   @override
   void initState() {
     _getAllCommunities();
     tabList.add(new Tab(text:'My Groups',));
     tabList.add(new Tab(text:'All Groups',));
     _tabController = new TabController(length:
     tabList.length, vsync: this);
     super.initState();
   }

   @override
   void dispose() {
     _tabController.dispose();
     super.dispose();
   }

   // widgets
   Widget noGroupWidget() {
     return Container(
         padding: EdgeInsets.symmetric(horizontal: 25.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
             GestureDetector(
                 onTap: () {
                   Navigator.of(context).pushNamed('/CreateCommunity');
                 },
                 child: Icon(Icons.add_circle, color: Colors.grey[300], size: 40.0)
             ),
             SizedBox(height: 20.0),
             _emptyListWidget(),
           ],
         )
     );
   }

   String _destructureId(String res) {
     // print(res.substring(0, res.indexOf('_')));
     return res.substring(0, res.indexOf('_'));
   }

   String _destructureName(String res) {
     // print(res.substring(res.indexOf('_') + 1));
     return res.substring(res.indexOf('_') + 1);
   }

   Widget _floatingActionButton(BuildContext context) {
     return FloatingActionButton(
       onPressed: () {
         //_popupDialog(context);
         Navigator.of(context).pushNamed('/CreateCommunity');
       },
       backgroundColor: AppColor.white,
       child: customIcon(
         context,
         icon: AppIcon.edit,
         istwitterIcon: true,
         iconColor: BootsColor.green,
         size: 25,
       ),
     );
   }


   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         leading: GestureDetector(
           child: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white,),
           onTap: () => Navigator.pop(context),
         ),
         elevation: 0.0,
         backgroundColor: Colors.green,
         title: Text('Communities', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white)),
         actions: <Widget>[
           GestureDetector(
             child: Icon(Icons.search, size: 21, color: Colors.white,),
             onTap: () => Navigator.of(context).pushNamed('/CommunitiesSearchPage'),
           ),
           SizedBox(width: 30,)
         ],
       ),
       key: widget.scaffoldKey,
       body: Column(
         children: <Widget>[
           new Container(
             decoration: new BoxDecoration(color: AppColor.white),
             child: new TabBar(
                 controller: _tabController,
                 indicatorColor: Colors.green,
                 indicatorSize: TabBarIndicatorSize.tab,
                 tabs: tabList
             ),
           ),
           new Container(
             height: MediaQuery.of(context).size.height - 200,
             child: new TabBarView(
               controller: _tabController,
               children: <Widget>[
                 _myCommunitiesList(),
                 _body(),
               ],
             ),
           )
         ],
       ),
       floatingActionButton: _floatingActionButton(context),
     );
   }

   _emptyListWidget() {
     return Container(
       child: Center(
         child: Padding(
           padding: EdgeInsets.all(30.0),
           child: Center(
             child: Text('You have not joined any community yet. Create or search for communities',
               style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
             ),
           ),
         ),
       ),
     );
   }

   Widget _getPage(Tab tab) {
     switch(tab.text) {
       case 'My Groups': return _emptyListWidget();
       case 'All Groups': return _isComEmpty ? _emptyListWidget() : _body();
     }
   }

   _body() {
     return communitiesList();
   }

   _getAllCommunities() async {
     _user = await FirebaseAuth.instance.currentUser();
     _userName = _user.displayName;
    _communitiesState = Provider.of<CommunitiesState>(context, listen: false);
    _communities = Firestore.instance.collection("communities").snapshots();
   }

   // functions
   _getUserAuthAndJoinedGroups() async {
     _user = await FirebaseAuth.instance.currentUser();
     print(_user.uid);
     DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
       setState(() {
         _communities = snapshots;
       });
     });
     await HelperFunctions.getUserEmailSharedPreference().then((value) {
       setState(() {
         _email = value;
       });
     });
   }

   Widget communitiesList() {
     return StreamBuilder(
       stream: Firestore.instance.collection("communities").snapshots(),
       builder: (context, snapshot) {
         if(snapshot.hasData) {
           if(snapshot.data.documents.length > 0) {
             return ListView.builder(
                 itemCount: snapshot.data.documents.length,
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   DocumentSnapshot communities = snapshot.data.documents[index];
                   return GroupTile(communityId: communities['communityId'], userName: _userName, communityName: _destructureName(communities['communityName']), communityIcon: communities['communityIcon']);
                 }
             );
           }
           else {
             return noGroupWidget();
           }
         }
         else {
           return Center(
               child: loader()
           );
         }
       },
     );
   }

   Widget _myCommunitiesList() {
     return StreamBuilder(
       stream: Firestore.instance.collection("communities").where("adminId", isEqualTo: "JwVKp4vQKXaBzFfD3UjiEUBhLib2").snapshots(),
       builder: (context, snapshot) {
         if(snapshot.hasData) {
           if(snapshot.data.documents.length > 0) {
             return ListView.builder(
                 itemCount: snapshot.data.documents.length,
                 shrinkWrap: true,
                 itemBuilder: (context, index) {
                   DocumentSnapshot communities = snapshot.data.documents[index];
                   return GroupTile(communityId: communities['communityId'], communityName: _destructureName(communities['communityName']), communityIcon: communities['communityIcon']);
                 }
             );
           }
           else {
             return noGroupWidget();
           }
         }
         else {
           return Center(
               child: loader()
           );
         }
       },
     );
   }
 }

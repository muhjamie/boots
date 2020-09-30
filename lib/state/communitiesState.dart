import 'package:boots/helper/utility.dart';
import 'package:boots/model/communitiesModel.dart';
import 'package:boots/state/appState.dart';
import 'package:boots/state/authState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class CommunitiesState extends AppState {

  List<CommunitiesModel> _communitiesList;
  Uuid uuid = Uuid();

  // Collection reference
  final CollectionReference userCollection = Firestore.instance.collection(
      'users');
  final CollectionReference communitiesCollection = Firestore.instance
      .collection('communities');
  dabase.Query query;

  void _onCommunitiesAdded(Event event) {
    if (event.snapshot.value != null) {
      var model = CommunitiesModel.fromJson({
      }
      );
      if (_communitiesList == null) {
        _communitiesList = List<CommunitiesModel>();
      }
      _communitiesList.add(model);
      // added notification to list
      print("Notification added");
      notifyListeners();
    }
  }

  getAllCommunities() async {
    return Firestore.instance.collection("communities").snapshots();
  }

  Future<bool> databaseInit(String userId) {
    try {
      if (query == null) {
        query = kDatabase.child("communities").child(userId);
        query.onChildAdded.listen(_onCommunitiesAdded);
      }

      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      return Future.value(false);
    }
  }

  // create group
  Future createCommunity(String communityName, String userId, String communityDescription, String iconURL) async {
    DocumentReference communitiesDocRef = await communitiesCollection.add({
      'communityId': uuid.v5(Uuid.NAMESPACE_OID, userId),
      'adminId': userId,
      'communityName': communityName,
      'communityDescription': communityDescription,
      'communityIcon': iconURL,
      'recentMessage': '',
      'recentMessageSender': '',
      'isActive': 1,
      'isApproved': 1
    });

    await communitiesDocRef.updateData({
      'members': FieldValue.arrayUnion([userId]),
      'communityId': communitiesDocRef.documentID
    });

    DocumentReference userDocRef = userCollection.document(userId);
    return await userDocRef.updateData({
      'communities': FieldValue.arrayUnion([communitiesDocRef.documentID + '_' + communityName])
    });
  }


    // toggling the user group join
    Future togglingGroupJoin(String groupId, String groupName,
        String userName) async {

      /*DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = communitiesCollection.document(groupId);

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    if(groups.contains(groupId + '_' + groupName)) {
      //print('hey');
      await userDocRef.updateData({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayRemove([uid + '_' + userName])
      });
    }
    else {
      //print('nay');
      await userDocRef.updateData({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }*/
    }


    // has user joined the group
    Future<bool> isUserJoined(String groupId, String groupName,
        String userName) async {

      /*DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data['groups'];


    if(groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    }
    else {
      //print('ne');
      return false;
    }*/
    }


    // get user data
    Future getUserData(String email) async {
      QuerySnapshot snapshot = await userCollection.where(
          'email', isEqualTo: email).getDocuments();
      print(snapshot.documents[0].data);
      return snapshot;
    }


    // get user groups
    getUserGroups() async {
      // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
      return Firestore.instance.collection("users")
          .document(AuthState().userId)
          .snapshots();
    }


    // send message
    sendMessage(String communityId, chatMessageData) {
      Firestore.instance.collection('communities').document(communityId).collection(
          'messages').add(chatMessageData);
      Firestore.instance.collection('communities').document(communityId).updateData({
        'recentMessage': chatMessageData['message'],
        'recentMessageSender': chatMessageData['sender'],
        'recentMessageTime': chatMessageData['time'].toString(),
      });
    }


    // get chats of a particular group
    getChats(String groupId) async {
      return Firestore.instance.collection('communities').document(groupId)
          .collection('messages').orderBy('time')
          .snapshots();
    }


    // search groups
    searchByName(String groupName) {
      return Firestore.instance.collection("communities").where(
          'communityName', isEqualTo: groupName).getDocuments();
    }
  }
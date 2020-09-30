import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {

  final String uid;
  Uuid uuid = Uuid();
  DatabaseService({
    this.uid
  });

  // Collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference communitiesCollection = Firestore.instance.collection('communities');

  // update userdata
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.document(uid).setData({
      'fullName': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': ''
    });
  }


  // create group
  Future createCommunity(String userName, String communityName, adminId) async {
    DocumentReference communitiesDocRef = await communitiesCollection.add({
      'adminId': adminId,
      'communityName': communityName,
      'communityIcon': '',
      'admin': userName,
      'members': [],
      'communityId': uuid.v5(Uuid.NAMESPACE_OID, adminId),
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await communitiesDocRef.updateData({
      'members': FieldValue.arrayUnion([uid + '_' + userName]),
      'communityId': communitiesDocRef.documentID
    });

    DocumentReference userDocRef = userCollection.document(uid);
    return await userDocRef.updateData({
      'communities': FieldValue.arrayUnion([communitiesDocRef.documentID + '_' + communityName])
    });
  }


  // toggling the user group join
  Future togglingGroupJoin(String groupId, String groupName, String userName) async {

    DocumentReference userDocRef = userCollection.document(uid);
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
    }
  }


  // has user joined the group
  Future<bool> isUserJoined(String groupId, String groupName, String userName) async {

    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data['groups'];


    if(groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    }
    else {
      //print('ne');
      return false;
    }
  }


  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).getDocuments();
    print(snapshot.documents[0].data);
    return snapshot;
  }




  // get user groups
  getUserGroups() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return Firestore.instance.collection("users").document(uid).snapshots();
  }


  // send message
  sendMessage(String communityId, chatMessageData) {
    Firestore.instance.collection('communities').document(communityId).collection('messages').add(chatMessageData);
    Firestore.instance.collection('communities').document(communityId).updateData({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }


  // get chats of a particular group
  getChats(String communityId) async {
    return Firestore.instance.collection('communities').document(communityId).collection('messages').orderBy('time').snapshots();
  }


  // search groups
  searchByName(String communityName) {
    return Firestore.instance.collection("communities").where('communityName', isEqualTo: communityName).getDocuments();
  }
}
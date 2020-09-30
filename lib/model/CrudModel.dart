import 'package:boots/helper/api.dart';
import 'package:boots/helper/locator.dart';
import 'package:boots/model/communitiesModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CRUDModel extends ChangeNotifier {
  Api _api = locator<Api>();

  List<CommunitiesModel> communities;


  Future<List<CommunitiesModel>> fetchCommunities() async {
    var result = await _api.getDataCollection();
    communities = result.documents
        .map((doc) => CommunitiesModel.fromJson(doc.data))
        .toList();
    return communities;
  }

  Stream<QuerySnapshot> fetchCommunitiesAsStream() {
    return _api.streamDataCollection();
  }

  Future<CommunitiesModel> getCommunitiesById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  CommunitiesModel.fromJson(doc.data) ;
  }


  Future removeCommunities(String id) async{
    await _api.removeDocument(id) ;
    return ;
  }
  Future updateCommunities(CommunitiesModel data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addCommunities(CommunitiesModel data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return ;

  }


}
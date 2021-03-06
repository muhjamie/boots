import 'package:boots/config.dart';
import 'package:boots/model/get_routes_request_model.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'json_message.dart';
import 'web_api_client.dart';

class Apis {
  static const domain = 'https://maps.googleapis.com/maps/api/directions/json';
  static final GMapClient _gmapClient = GMapClient();

  Apis();

  getHttp(String query) async {
    try {
      Response response = await Dio().get('$domain?$query');
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<JsonMessage> getRoutes({@required GetRoutesRequestModel getRoutesRequest}) async {
    return await _gmapClient.fetch(
      url: domain,
      key: Config.apiKey,
      queryParameters: getRoutesRequest.toJson(),
    );
  }
}
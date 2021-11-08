import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nearlikes/models/get_media.dart';
import 'package:http/http.dart' as http;

Future<GetMedia> getAvailableMedia({@required String id}) async {
  print('inside get media two2');
  GetMedia _getMedia;

  const String apiUrl = "https://nearlikes.com/v1/api/client/get/media";
  // const String apiUrl = "https://api.nearlikes.com/v1/api/client/get/media";
  var body = {
    "id": id,
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  final String responseString = response.body;
  _getMedia = getMediaFromJson(responseString);
  print('getAvailableMedia --> $responseString');

  return _getMedia;
}

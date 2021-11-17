import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nearlikes/constants/constants.dart';
import 'package:nearlikes/models/get_media.dart';
import 'package:http/http.dart' as http;

Future<GetMedia> getAvailableMedia({@required String id}) async {
  print('inside get media two2');
  GetMedia _getMedia;

  var body = {
    "id": id,
  };

  final response = await http.post(
    Uri.parse(kGetMedia),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  final String responseString = response.body;
  _getMedia = getMediaFromJson(responseString);
  print('getAvailableMedia --> $responseString');

  return _getMedia;
}

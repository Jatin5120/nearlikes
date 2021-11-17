import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nearlikes/constants/api.dart';
import 'package:nearlikes/models/get_campaigns.dart';

Future<GetCampaigns> getAvailableCampaigns(
    {int followers, String location, int age}) async {
  GetCampaigns _getCampaigns;

  final Map<String, dynamic> body = {
    "followers": followers,
    "location": "kolkata",
    "age": age
  };
  final http.Response response = await http.post(
    Uri.parse(kGetCampaigns),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print("statusCode --> ${response.statusCode}");
  final String responseString = response.body;

  print("Response --> $responseString");
  _getCampaigns = getCampaignsFromJson(responseString);
  return _getCampaigns;
}

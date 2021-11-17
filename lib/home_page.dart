import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nearlikes/coupons.dart';
import 'package:nearlikes/brand_details.dart';
import 'package:nearlikes/constants/colors.dart';
import 'package:nearlikes/link_upi.dart';
import 'package:nearlikes/login.dart';
import 'package:nearlikes/models/get_metrics_data.dart';
import 'package:nearlikes/notifications.dart';
import 'package:nearlikes/scratch_cards.dart';
import 'package:nearlikes/select_brand.dart';
import 'package:nearlikes/setup_instructions.dart';
import 'constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'models/get_campaigns.dart';
import 'dart:convert';
import 'dart:async';
import 'package:nearlikes/models/get_customer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'globals.dart' as globals;
import 'package:badges/badges.dart';

bool check1;
String cashid;

bool isMetricsDataPresent = false;
int length;
MetricsData _getMetricsData;
GetCampaigns _getCampaigns;
Customer _getCustomer;

String name = '';
String customerId;
String phonenumber;
String CID;
String cashbackId;
bool upi = true;

//StreamController _campaignController,_postsController,
StreamController _metricsDataController, _selectBrand;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

Future<Cashback> checkCashback(String phone, String id) async {
  var body = {"phone": "+91$phone", "id": id};
  final response = await http.post(
    Uri.parse(kCheckCashback),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(body),
  );
  if (response.statusCode == 200) {
    print("hehehehehsksl");
    return Cashback.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed .');
  }
}

class Cashback {
  final bool check;

  Cashback({@required this.check});

  factory Cashback.fromJson(Map<String, dynamic> json) {
    return Cashback(
      check: json['status'],
    );
  }
}

// Future<GetCampaigns> getAvailableCampaigns(
//     {int followers, String location, int age}) async {
//   print("data..");
//   final String apiUrl = "https://nearlikes.com/v1/api/campaign/get/campaigns";
//   var body = {"followers": followers, "location": "kolkata", "age": age};
//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {"Content-Type": "application/json"},
//     body: json.encode(body),
//   );
//
//   print("data");
//   print(response.statusCode);
//   final String responseString = response.body.toString();
//
//   print(responseString);
//   _getCampaigns = getCampaignsFromJson(responseString);
//   return _getCampaigns;
// }

// loadcampaign() async {
//   getAvailableCampaigns(followers: 500, location: "kolkata", age: 40)
//       .then((res) async {
//     _campaignController.add(res);
//     return res;
//   });
// }
//
// loadPosts() async {
//   getAvailableCampaigns(followers: 500, location: "kolkata", age: 40)
//       .then((res) async {
//     _postsController.add(res);
//     return res;
//   });
// }

Future<MetricsData> getMetricsData(String phoneNumber) async {
  print("metrics data start");
  //var body = {"phone": "+916309572528"};
  phoneNumber = "+91" + phoneNumber.trim();
  var body = {"phone": phoneNumber};
  final response = await http.post(
    Uri.parse(kGetMetrics),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  if (response.statusCode >= 200 && response.statusCode <= 299) {
    isMetricsDataPresent = true;
  }
  print("Status code of metrics data : " + response.statusCode.toString());
  final String responseString = response.body.toString();
  print("Response string of metrics data : " + responseString);

  _getMetricsData = metricsDataFromJson(responseString);
  length = _getMetricsData.data.length;
  print("metrics data length : " + _getMetricsData.data.length.toString());
  print("metrics data end");
  return _getMetricsData;
}

loadMetricsData(phonenumber) async {
  print('loadmetric phonenumber $phonenumber');
  getMetricsData("$phonenumber").then((res) async {
    //isMetricsDataPresent = true;
    _metricsDataController.add(res);
    length = res.data.length;
    return res;
  });
}

class _HomePageState extends State<HomePage> {
  int sum = 0;

  Future<Customer> getCustomer(String customerId) async {
    print(".....injuinju");
    setState(() {
      sum = 0;
    });

    print(customerId);
    var body = {"id": customerId};
    final response = await http.post(
      Uri.parse(kGetCustomer),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    print("..111...");
    print(response.body);
    final String responseString = response.body.toString();

    print('----111-------');
    _getCustomer = customerFromJson(responseString);
    print('----222-----');
    print(_getCustomer.customer.cashback);

    for (int i = 0; i < _getCustomer.customer.cashback.length; i++) {
      if (_getCustomer.customer.cashback[i].used == true) {
        var a = int.parse(_getCustomer.customer.cashback[i].amount);
        assert(a is int);

        sum = sum + a;
      } else {
        setState(() {
          cashid = _getCustomer.customer.cashback[i].id;
        });
      }
    }

    print(sum);
    print(";;;");
    print(_getCustomer.customer.name);
    setState(() {
      name = _getCustomer.customer.name;
      CID = _getCustomer.customer.id;
    });

    if (_getCustomer.customer.upi != null) {
      setState(() {
        upi = true;
      });
    } else {
      setState(() {
        upi = false;
      });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('token', _getCustomer.customer.token);
    return _getCustomer;
  }

  getCustomerId(String phonenumber) async {
    var body = {"phone": "+91$phonenumber"};

    final response = await http.post(
      Uri.parse(kGetId),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    var test = jsonDecode(response.body);
    print('the response is $test');
    customerId = test;
    getCustomer(customerId);
    addPlayer(customerId);
  }

  String userAccId;

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getString('customer_id');
    phonenumber = prefs.getString('phonenumber');
    print('the phone number is $phonenumber');
    print('user acc id is $customerId');

    if (customerId == null) {
      print('test');
      getCustomerId(phonenumber);
    } else {
      getCustomer(customerId);
      addPlayer(customerId);
    }

    getStatus(phonenumber);
    loadMetricsData(phonenumber);
  }

  Future<GetCampaigns> getAvailableCampaigns(
      {int followers, String location, int age}) async {
    print("data..");
    var body = {"followers": followers, "location": "kolkata", "age": age};
    final response = await http.post(
      Uri.parse(kGetCampaigns),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    print("data");
    print(response.statusCode);
    final String responseString = response.body.toString();

    print(responseString);
    _getCampaigns = getCampaignsFromJson(responseString);
    print('helllloooooo ${_getCampaigns.campaigns.length.toString()}');
    return _getCampaigns;
  }

  loadBrands() async {
    getAvailableCampaigns(followers: 500, location: "kolkata", age: 40)
        .then((res) async {
      _selectBrand.add(res);
      return res;
    });
  }

  Future<void> initPlatformState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkUser = prefs.getBool('checkuser');
    OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
      var data = openedResult.notification.additionalData;
      var id = openedResult.notification.notificationId;

      print('the additional data ${data.toString()}');
      print('the notification id ${id.toString()}');

      var postId = await data['post_id'];
      print('the post id is $postId');
      if (checkUser == true) {
        if (postId == 'coupon') {
          globals.appNaviagtor.currentState.push(MaterialPageRoute(
              builder: (context) => Coupons(
                    cID: CID,
                  )));
        } else if (postId == 'campaign') {
          globals.appNaviagtor.currentState.push(MaterialPageRoute(
              builder: (context) => const SelectBrand(
                    value: true,
                  )));
        } else if (postId == 'cashback') {
          globals.appNaviagtor.currentState.push(MaterialPageRoute(
              builder: (context) => ScratchCards(
                    cID: CID,
                  )));
        }
        //else  globals.appNaviagtor.currentState.push(MaterialPageRoute(builder: (context)=>HomePage()));
      }
    });
  }

  getStatus(phNum) async {
    print('This function to check user login status! $phNum');
    var body = {
      "phone": "$phNum",
    };
    var checkuser = await http.post(
      Uri.parse(kCheckUser),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    print('the result is ${checkuser.body}');
    if (checkuser.body == '0') {
      //returned when access token is expired
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          ModalRoute.withName("/Home"));
    }
  }

  @override
  void initState() {
    length = 0;
    sum = 0;
    isMetricsDataPresent = false;
    initPlatformState();
    // _campaignController = new StreamController();
    _metricsDataController = StreamController();
    _selectBrand = StreamController();
    loadBrands();
    //loadcampaign();
    //get();
    getUserData();
    //loadMetricsData();
    super.initState();
  }

  Future _refreshData() async {
    await Future.delayed(const Duration(seconds: 4));
    setState(() {
      sum = 0;
    });
    getCustomer(customerId);
    getStatus(phonenumber);
    _metricsDataController.close();
    _metricsDataController = StreamController();
    loadMetricsData(phonenumber);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<String> cashbackScratched(String couponId) async {
  //   print('the the $customerId');
  //   if(couponId!=null){
  //     print('the customer id is $customerId');
  //     print("..8989..");
  //     print('the coupon id is $couponId');
  //     final String apiUrl = "https://nearlikes.com/v1/api/client/cashback/scratch";
  //     var body = {
  //       "id": "$couponId",
  //       "ownerId": "$customerId"
  //     };
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode(body),
  //     );
  //
  //     print(".....");
  //     print(response.statusCode);
  //     print('----');
  //     final String responseString = response.body.toString();
  //     print(']||/*/');
  //     print(responseString);
  //     print('232323');
  //     return responseString;
  //     // _getCustomer = customerFromJson(responseString);
  //     // print(";;;");
  //     // print(_getCustomer.customer.name);
  //     // return _getCustomer;
  //   }
  // }

  addPlayer(String customerId) async {
    print('inside the getPlayerId');
    final status = await OneSignal.shared.getDeviceState();
    final String osUserID = status.userId;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs
        .setString('playerId', osUserID)
        .then((value) => print('job done $value'));
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    // var PlayerId= prefs.getString('playerId');
    print('the player id inside is $osUserID');
    print('the customer id inside is $customerId');
    var body = {
      "id": customerId,
      "push": osUserID,
    };
    var response = await http.post(Uri.parse(kAddPlayer),
        headers: {"Content-Type": "application/json"}, body: json.encode(body));
    print(response.body);
    print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          bool closeApp = false;
          Get.dialog(
            AlertDialog(
              title: const Text('Exit Nearlikes'),
              content: const Text('Are you sure want to close the App?'),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kSecondaryBackgroundColor,
                    textStyle: const TextStyle(color: kWhiteColor),
                  ),
                  child: const Text('Yes'),
                  onPressed: () {
                    closeApp = true;
                    Get.back();
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: kSecondaryColor,
                    textStyle: const TextStyle(color: kWhiteColor),
                  ),
                  child: const Text('No'),
                  onPressed: () {
                    closeApp = false;
                    Get.back();
                  },
                ),
              ],
            ),
            barrierDismissible: false,
          );
          return closeApp;
        },
        child: SafeArea(
          child: Scaffold(
            body: _getCustomer == null
                ? const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  )
                : RefreshIndicator(
                    color: kPrimaryColor,
                    onRefresh: _refreshData,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 30, right: 30),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Welcome,',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationPage(cID: CID),
                                      ),
                                    );
                                  },
                                  child: Badge(
                                    toAnimate: true,
                                    animationType: BadgeAnimationType.scale,
                                    badgeContent: Text(
                                      '*',
                                      style: GoogleFonts.montserrat(
                                        //badgeContent: Text('13',style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.notifications_active,
                                      color: Colors.black,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(name,
                                style: GoogleFonts.montserrat(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: kBlackColor,
                                )),
                            SizedBox(
                              height: size.height * 0.200,
                              width: double.infinity,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 45,
                                    left: MediaQuery.of(context).size.width *
                                        0.188,
                                    child: Container(
                                      height: size.height * 0.125,
                                      width: size.width * 0.455,
                                      decoration: const BoxDecoration(
                                        color: Color(0xfff2f2f2),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: size.height * 0.060,
                                          ),
                                          if (_getCustomer.customer.status ==
                                              'normal')
                                            Text(
                                              '',
                                              style: GoogleFonts.montserrat(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xffB9B9B9),
                                              ),
                                            ),
                                          if (_getCustomer.customer.status ==
                                              'bronze')
                                            Text('Bronze',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.brown)),
                                          if (_getCustomer.customer.status ==
                                              'silver')
                                            Text('Silver',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black45)),
                                          if (_getCustomer.customer.status ==
                                              'gold')
                                            Text('Gold',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.amber)),

                                          // SizedBox(
                                          //   height: size.height*0.007,
                                          // ),
                                          // // Text("Rs. "+_getCustomer.customer.cashback[0].amount,
                                          // Text("Rs. $sum",
                                          //     style: GoogleFonts.montserrat(
                                          //       fontSize: 23,
                                          //       fontWeight: FontWeight.w600,
                                          //       color: kBlack,
                                          //     )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 15,
                                    left: MediaQuery.of(context).size.width *
                                        0.325,
                                    child: Container(
                                      height: size.height * 0.09,
                                      width: 72,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: const Offset(
                                              4,
                                              8,
                                            ),
                                            blurRadius: 20.0,
                                            spreadRadius: 0,
                                          ), //BoxShadow//BoxShadow
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset('assets/logo.png',
                                            width: 32.48, height: 42.28),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            upi == true
                                ? const Text('')
                                : Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LinkUPI(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Press to Add UPI',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                    ),
                                  ),
                            SizedBox(height: size.height * 0.01),
                            Text(
                              'Brands',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder(
                                  // future: getAvailableCampaigns(
                                  //     followers: 500, location: "kolkata", age: 40),
                                  stream: _selectBrand.stream,
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      print(snapshot.data);
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: kPrimaryColor,
                                        ),
                                      );
                                    }
                                    print(snapshot.data);
                                    return _getCampaigns.campaigns.isEmpty
                                        ? const Padding(
                                            padding: EdgeInsets.only(top: 180),
                                            child: Text(
                                              'No Brands available at your location for now,\nThank you!',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 15,
                                              ),
                                            ),
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount:
                                                _getCampaigns.campaigns.length,
                                            // _getCampaigns.campaigns.length,
                                            itemBuilder:
                                                (BuildContext ctx, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: size.height * 0.32,
                                                  width: 140,
                                                  // child: Card(
                                                  //   child: Image.network(
                                                  //       "${_getCampaigns.campaigns[index].logo}"),
                                                  // ),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        // Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                BrandDetails(
                                                              campaign:
                                                                  _getCampaigns
                                                                          .campaigns[
                                                                      index],
                                                            ),
                                                          ),
                                                        );

                                                        // if (_getCustomer
                                                        //         .customer
                                                        //         .status ==
                                                        //     'normal') {
                                                        //   showDialog(
                                                        //       context:
                                                        //           context,
                                                        //       builder:
                                                        //           (BuildContext
                                                        //               context) {
                                                        //         return AlertDialog(
                                                        //           title:
                                                        //               Row(
                                                        //             //mainAxisAlignment: MainAxisAlignment.center,
                                                        //             children: [
                                                        //               Text("Link with Instagram",
                                                        //                   style: GoogleFonts.montserrat(
                                                        //                     fontSize: 18,
                                                        //                     fontWeight: FontWeight.w500,
                                                        //                     color: kBlack,
                                                        //                   )),
                                                        //             ],
                                                        //           ),
                                                        //           content:
                                                        //               Text(
                                                        //             "Please link with your Instagram account to start sharing brands",
                                                        //             style: GoogleFonts.montserrat(
                                                        //                 fontSize: 16,
                                                        //                 fontWeight: FontWeight.w400,
                                                        //                 color: Colors.black),
                                                        //           ),
                                                        //           actions: [
                                                        //             Row(
                                                        //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        //               children: [
                                                        //                 ElevatedButton(
                                                        //                   style: ElevatedButton.styleFrom(
                                                        //                     primary: Colors.white,
                                                        //                     shape: const RoundedRectangleBorder(
                                                        //                       side: BorderSide(color: kPrimaryOrange),
                                                        //                       borderRadius: BorderRadius.all(
                                                        //                         Radius.circular(5),
                                                        //                       ),
                                                        //                     ),
                                                        //                   ),
                                                        //                   onPressed: () async {
                                                        //                     Navigator.pop(context);
                                                        //                   },
                                                        //                   child: Text(
                                                        //                     'Cancel',
                                                        //                     style: GoogleFonts.montserrat(
                                                        //                       fontSize: 16,
                                                        //                       fontWeight: FontWeight.w500,
                                                        //                       color: kPrimaryOrange,
                                                        //                     ),
                                                        //                   ),
                                                        //                 ),
                                                        //                 ElevatedButton(
                                                        //                   onPressed: () {
                                                        //                     Navigator.pop(context);
                                                        //                     Navigator.push(context, MaterialPageRoute(builder: (context) => SetupInstructions()));
                                                        //                   },
                                                        //                   style: ElevatedButton.styleFrom(
                                                        //                     primary: kPrimaryOrange.withOpacity(0.8),
                                                        //                     shape: const RoundedRectangleBorder(
                                                        //                       side: BorderSide(color: kPrimaryOrange),
                                                        //                       borderRadius: BorderRadius.all(
                                                        //                         Radius.circular(5),
                                                        //                       ),
                                                        //                     ),
                                                        //                   ),
                                                        //                   child: Text(
                                                        //                     'Okay',
                                                        //                     style: GoogleFonts.montserrat(
                                                        //                       fontSize: 16,
                                                        //                       fontWeight: FontWeight.w500,
                                                        //                       color: Colors.white,
                                                        //                     ),
                                                        //                   ),
                                                        //                 )
                                                        //               ],
                                                        //             )
                                                        //           ],
                                                        //           //descriptions: "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
                                                        //           //text: "Yes",
                                                        //         );
                                                        //       });
                                                        // } else {
                                                        //   Navigator.push(
                                                        //       context,
                                                        //       MaterialPageRoute(
                                                        //           builder: (context) => BrandDetails(
                                                        //                 campaign: _getCampaigns.campaigns[index],
                                                        //               )));
                                                        // }
                                                      },
                                                      //child: Image.asset('assets/brands.png'));
                                                      child: ShaderMask(
                                                        shaderCallback:
                                                            (bounds) {
                                                          return const LinearGradient(
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              colors: [
                                                                Colors
                                                                    .transparent,
                                                                Colors.black
                                                              ]).createShader(
                                                              bounds);
                                                        },
                                                        blendMode:
                                                            BlendMode.color,
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                      // image: AssetImage('assets/scratch_card.png'),
                                                                      image: NetworkImage(_getCampaigns
                                                                          .campaigns[
                                                                              0]
                                                                          .logo),
                                                                      fit: BoxFit
                                                                          .cover),
                                                              color: const Color(
                                                                  0xffaaaaaa),
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          5)),
                                                            ),
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          gradient:
                                                                              LinearGradient(
                                                                    colors: [
                                                                      Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.0),
                                                                      Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.9)
                                                                    ],
                                                                    begin: Alignment
                                                                        .topCenter,
                                                                    end: Alignment
                                                                        .bottomCenter,
                                                                  )),
                                                                ),
                                                                Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0,
                                                                        bottom:
                                                                            15),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          _getCampaigns
                                                                              .campaigns[0]
                                                                              .brand,
                                                                          style: GoogleFonts.montserrat(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.white),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        // Text(
                                                                        //   "${_getCampaigns.campaigns[index].text}",
                                                                        //   style: GoogleFonts.montserrat(
                                                                        //     fontSize: 14,
                                                                        //     fontWeight: FontWeight.w400,
                                                                        //     color: Colors.white,
                                                                        //   ),),
                                                                        // Text(
                                                                        //   "${readTimestamp(_getCampaigns.campaigns[index].start)}",style: GoogleFonts.montserrat(
                                                                        //     fontSize: 11,
                                                                        //     fontWeight: FontWeight.w500,
                                                                        //     color:Colors.white
                                                                        // ),),
                                                                        // Text(
                                                                        //   "to ${readTimestamp(_getCampaigns.campaigns[index].end)}",style: GoogleFonts.montserrat(
                                                                        //     fontSize: 11,
                                                                        //     fontWeight: FontWeight.w500,
                                                                        //     color: Colors.white
                                                                        // ),),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      )),
                                                ),
                                              );
                                            });

                                    //return Container();
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ));
  }

  //Title List for Metrics Data Cards
  List<String> titles = ["Views", "Reach", "Exits", "Replies", "Taps Forwards"];

  Widget makeCard(int index, bool isDataNotPresent) {
    print('the makecard widget $isDataNotPresent ');
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.135,
      width: size.width * 0.25,
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL, // default
        front: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (!isDataNotPresent && _getMetricsData != null)
                ? kSecondaryColor
                : Colors.grey,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icons[index],
                color: Colors.white,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: size.width * 0.25,
                child: Center(
                  child: Center(
                      child: Text(
                    titles[index],
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  )),
                ),
              )
            ],
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (!isDataNotPresent && _getMetricsData != null)
                ? kSecondaryColor
                : Colors.grey,
          ),
          child: Center(
              child: Text(
                  ((!isDataNotPresent && _getMetricsData != null)
                      ? _getMetricsData.data[index].values.first.value
                          .toString()
                      : "0"),
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ))),
        ),
      ),
    );
  }

  List<IconData> icons = [
    Icons.remove_red_eye,
    Icons.trending_up_outlined,
    Icons.exit_to_app_rounded,
    Icons.compare_arrows,
    Icons.fast_forward,
  ];

// Horizontal Card (No Flip) -> width * 0.85
  Widget makeTotalCard(String value, bool isDataNotPresent) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: size.height * 0.1,
        width: size.width * 0.85,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: (!isDataNotPresent && _getMetricsData != null)
                ? Colors.redAccent
                : Colors.grey),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  SizedBox(width: 20,),
                //Icon(Icons.done_all,color: Colors.white,size: 24,),
                const SizedBox(
                  width: 20,
                ),
                Center(
                    child: Text(
                  "Analytics Total",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )),
                const Spacer(
                  flex: 4,
                ),
                Center(
                  child: Text(
                    ((!isDataNotPresent && _getMetricsData != null)
                        ? value
                        : "0"),
                    style: GoogleFonts.montserrat(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String readTimestamp(int timestamp) {
  var now = DateTime.now();
  var format = DateFormat('d MMM h:mm a');
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var diff = format.format(date);
  return diff;
}

Future<bool> _mockCheckForSession() async {
  await Future.delayed(const Duration(milliseconds: 000), () {});
  return true;
}

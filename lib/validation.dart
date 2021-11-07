import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearlikes/constants/colors.dart';
import 'package:nearlikes/home_page.dart';
import 'package:get/get.dart';
import 'package:nearlikes/page_guide.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/get_campaigns.dart';
import 'package:nearlikes/models/get_customer.dart';

Customer _getCustomer;
String phonen;
String customerId;
String username;

Future<String> validation(String post, Campaign campaign, String story,
    String name, String phonen) async {
  print('the customer id is $phonen');
  // print("$userid");
  print('userid $username');

  final String apiUrl = "https://nearlikes.com/v1/api/client/add/post";
  var body = {
    "story": "$story",
    "post": "$post",
    "user": "$username",
    "name": "$name",
    "phone": "$phonen",
    "id": "${campaign.id}"
  };
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print('the status of validtio  ius ');
  print(response.statusCode);

  final String responseString = response.body.toString();

  print(responseString);

  return responseString;
}

class Valid extends StatefulWidget {
  const Valid({
    Key key,
    @required this.campaign,
  }) : super(key: key);

  final Campaign campaign;

  @override
  _ValidState createState() => _ValidState();
}

class _ValidState extends State<Valid> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _controllerstory = TextEditingController();

  bool pressed = false;

  final _formkey = GlobalKey<FormState>();

  Future<Customer> getCustomer(String customerId) async {
    print(".....injuinju");
    print(customerId);

    final String apiUrl = "https://nearlikes.com/v1/api/client/own/fetch";
    var body = {"id": "$customerId"};
    final response = await http.post(
      Uri.parse(apiUrl),
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

    print(";;;");
    print(_getCustomer.customer.name);
    setState(() {
      name = _getCustomer.customer.name;
      CID = _getCustomer.customer.id;
      username = _getCustomer.customer.user;
    });

    if (_getCustomer.customer.upi != null) {
      setState(() {
        upi = true;
      });
    } else
      setState(() {
        upi = false;
      });

    return _getCustomer;
  }

  getCustomerId(String phonenumber) async {
    var body = {"phone": "+91$phonenumber"};

    final response = await http.post(
      Uri.parse('https://nearlikes.com/v1/api/client/getid'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    var test = jsonDecode(response.body);
    print('the response is ${test}');
    customerId = test;
    getCustomer(customerId);
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerId = prefs.getString('customer_id');
    phonen = prefs.getString('phonenumber');
    print('the phone number is $phonenumber');
    print('user acc id is $customerId');

    if (customerId == null) {
      print('test');
      getCustomerId(phonenumber);
    } else {
      getCustomer(customerId);
    }
  }

  @override
  void initState() {
    getUserData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: kPrimaryColor),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo.png',
                          width: 56.31, height: 70.28),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            '       Validate your story',
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: kFontColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(right: 15, left: 15, top: 10),
                    child: TextFormField(
                      //key: _formkey,
                      controller: _controllerstory,
                      validator: (amt) {
                        if (amt == null || amt.isEmpty) {
                          return 'Please enter the url';
                        } else {
                          return null;
                        }
                      },

                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),

                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18)),
                        prefixStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: kLightGrey,
                            fontWeight: FontWeight.w700),
                        isDense: true,
                        contentPadding:
                        EdgeInsets.fromLTRB(15.0, 20.0, 5.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(width: 1, color: kLightGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(width: 1, color: kLightGrey),
                        ),
                        labelText: "Story media url",
                        labelStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: kLightGrey,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(right: 15, left: 15, top: 10),
                    child: TextFormField(
                      controller: _controller,
                      validator: (amt) {
                        if (amt == null || amt.isEmpty) {
                          return 'Please enter the url';
                        } else {
                          return null;
                        }
                      },
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18)),
                        prefixStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                        isDense: true,
                        contentPadding:
                        EdgeInsets.fromLTRB(15.0, 20.0, 5.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(width: 1, color: kLightGrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(width: 1, color: kLightGrey),
                        ),
                        labelText: "Post media url",
                        labelStyle: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: kLightGrey,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () async {
                        if (_formkey.currentState.validate()) {
                          print('hello guys;');
                          setState(() {
                            pressed = true;
                          });
                        }
                      },
                      child: Container(
                          height: height * 0.06,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  // kPrimaryPink,
                                  // kPrimaryOrange,
                                  Colors.pink,
                                  Colors.orange
                                ],
                              )),
                          child: Center(
                            child: Text('Validate',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                  //letterSpacing: 1
                                )),
                          )),
                    ),
                  ),
                  pressed
                      ? fetchdata(_controller.text, _controllerstory.text)
                      : Container(
                    height: 0,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<String> fetchdata(post, story) {
    print(post);
    return FutureBuilder<String>(
      future: validation(post, widget.campaign, story, name, phonen),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Future(() {
            Get.defaultDialog(
                title: "Bingo",
                titleStyle: TextStyle(fontSize: 24),
                content: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                          "Your story will be validated soon. Please don't delete your post/story. Cashback will be credited after that."),
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
                textConfirm: 'Okay',
                confirmTextColor: Colors.white,
                onConfirm: () {
                  pressed = false;
                  Get.off(PageGuide());
                });
          });
          // Get.to(HomePage);

        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return CircularProgressIndicator();
      },
    );
  }
}

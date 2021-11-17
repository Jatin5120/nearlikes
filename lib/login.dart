import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nearlikes/otp_verification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'constants/constants.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Uri backgroundAssetUri = Uri.parse(
      "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/2022-chevrolet-corvette-z06-1607016574.jpg?crop=0.737xw:0.738xh;0.181xw,0.218xh&resize=980:*");
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String phoneNum;
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return SystemNavigator.pop();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 90),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: kPrimaryColor,
                            size: 30,
                          )),
                      const SizedBox(
                        height: 22,
                      ),
                      Text(
                        "Login",
                        style: GoogleFonts.montserrat(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: kFontColor,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Enter your phone number to get started.",
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: kDarkGrey,
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      Image.asset('assets/login.png', width: 301, height: 301),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        height: 75.0,
                        decoration: BoxDecoration(
                            //color: kLightGrey,
                            border: Border.all(color: kLightGrey),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _phoneNumberController,
                            maxLines: 1,
                            keyboardType: TextInputType.phone,
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: kDarkGrey,
                                fontWeight: FontWeight.w700),
                            cursorColor: kPrimaryColor,
                            //autofocus: true,
                            decoration: InputDecoration(
                              prefixText: '+91 ',
                              prefixStyle: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: kDarkGrey,
                                  fontWeight: FontWeight.w700),
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                              prefixIcon: const Icon(
                                Icons.phone_android,
                                color: kLightGrey,
                                size: 20,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              labelText: "Phone Number",
                              labelStyle: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: kLightGrey,
                                  fontWeight: FontWeight.w400),
                            ),
                            validator: (val) => (val.isEmpty) ||
                                    (val.length < 10) ||
                                    (val.length > 10)
                                ? 'Enter Proper Phone Number'
                                : null,
                            onChanged: (val) {
                              phoneNum = val;
                            },
                            onSaved: (val) {
                              phoneNum = val;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: Text(
                        error,
                        style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: InkWell(
                          onTap: () async {
                            // SharedPreferences prefs = await SharedPreferences.getInstance();
                            // prefs.clear().then((value) => {print('shared preferences cleared!!!! $value')});

                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              print('in');
                              //var rand= (Random().nextInt(900000)+100000).toString();
                              //print(rand);
                              print(phoneNum);
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => OTPVerification(phNum)));
                              var response = await http
                                  .post(Uri.parse('$kGetOtp$phoneNum'));
                              var decoded = json.decode(response.body);
                              print(response.body);
                              print(response.statusCode);
                              var type = decoded['type'];
                              //  if(phNum=='8888888888'){
                              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Register(phNum)));
                              // }
                              if (type == 'success') {
                                setState(() {
                                  loading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OTPVerification(phoneNum)));
                              } else {
                                setState(() {
                                  error = 'Something went wrong, Try again!!';
                                  loading = false;
                                });
                              }
                            }
                          },
                          child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      kSecondaryColor,
                                      kPrimaryColor,
                                    ],
                                  )),
                              child: Center(
                                child: Text('Continue',
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.white,
                                      //letterSpacing: 1
                                    )),
                              )),
                        ),
                      ),
                    ],
                  ),
                  loading == true
                      ? const Padding(
                          padding: EdgeInsets.only(
                            top: 250,
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              //valueColor: Colors.black,
                              //Color: Colors.black,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        )
                      : Container(
                          height: 0,
                        ),
                ],
              ),
            ),
          ),
        ));
  }
}

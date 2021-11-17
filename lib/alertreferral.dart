// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:nearlikes/page_guide.dart';
// import 'package:http/http.dart' as http;

// class MyAlertDialog extends StatefulWidget {
//   final phonenumber;
//   MyAlertDialog({this.phonenumber});

//   @override
//   _MyAlertDialogState createState() => _MyAlertDialogState();
// }

// Future check() async {
//   print("data..");
//   final String apiUrl = "http://localhost:3000/v1/api/client/referal";
//   var body = {"code": "avishek005"};
//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {"Content-Type": "application/json"},
//     body: json.encode(body),
//   );

//   print("data");
//   print(response.statusCode);
//   final String responseString = response.body.toString();

//   print(responseString);
// }

// class _MyAlertDialogState extends State<MyAlertDialog> {
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Center(
//         child: RaisedButton(
//           onPressed: () {
//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(15))),
//                     content: SingleChildScrollView(
//                       child: Container(
//                         height: height * 0.55,
//                         width: width * 0.90,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                   height: height * 0.22,
//                                   child: Image.asset('assets/pic1.jpeg')),
//                               Spacer(),
//                               Text(
//                                 'Enter the referral code ',
//                                 style: TextStyle(
//                                     fontSize: 21, fontWeight: FontWeight.bold),
//                               ),
//                               Spacer(
//                                 flex: 2,
//                               ),
//                               Container(
//                                 width: width * 0.60,
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey.shade200,
//                                     shape: BoxShape.rectangle,
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10))),
//                                 child: TextField(
//                                   textAlign: TextAlign.center,
//                                   decoration: InputDecoration(
//                                     hintText: 'Enter the code',
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),

//                               // ElevatedButton(
//                               //     style: ButtonStyle(
//                               //         backgroundColor:
//                               //         MaterialStateProperty.all(Colors.red)),
//                               //     onPressed: null,
//                               //     child: Text(
//                               //       'Continue',
//                               //       style: TextStyle(color: Colors.white),
//                               //     )),
//                               Spacer(),
//                               Container(
//                                 width: width * 0.40,
//                                 decoration: BoxDecoration(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10)),
//                                     color: Colors.red),
//                                 child: TextButton(
//                                   child: Text(
//                                     'Continue',
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 20),
//                                   ),
//                                   onPressed: null,
//                                 ),
//                               ),
//                               Spacer(),
//                               Container(
//                                 width: width * 0.3,
//                                 decoration: BoxDecoration(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10)),
//                                     color: Colors.white,
//                                     border: Border.all(color: Colors.red)),
//                                 child: TextButton(
//                                   child: Text(
//                                     'Skip',
//                                     style: TextStyle(
//                                         color: Colors.red, fontSize: 20),
//                                   ),
//                                   onPressed: () {
//                                     Navigator.pushReplacement(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => PageGuide(
//                                                 phoneNumber:
//                                                     widget.phonenumber)));
//                                   },
//                                 ),
//                               ),
//                               // ElevatedButton(
//                               //     style: ButtonStyle(
//                               //         backgroundColor:
//                               //             MaterialStateProperty.all(
//                               //                 Colors.white)),
//                               //     onPressed: null,
//                               //     child: Text(
//                               //       'Skip',
//                               //       style: TextStyle(color: Colors.red),
//                               //     )),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 });
//           },
//           child: Text('Ok'),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nearlikes/constants/colors.dart';
import 'package:nearlikes/constants/constants.dart';
import 'package:nearlikes/page_guide.dart';
import 'package:shared_preferences/shared_preferences.dart';

String phonenumber;
String customerId;

Future<Refer> createRefer(String code, String customerId) async {
  var body = {"id": customerId, "code": code};
  final response = await http.post(
    Uri.parse(kReferal),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    return Refer.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed .');
  }
}

class Refer {
  final bool title;

  Refer({@required this.title});

  factory Refer.fromJson(Map<String, dynamic> json) {
    return Refer(
      title: json['type'],
    );
  }
}

class MyAlertDialog extends StatefulWidget {
  final phonenumber;
  // const MyAlertDialog({Key key}) : super(key: key);
  MyAlertDialog({@required this.phonenumber});
  @override
  _MyAlertDialogState createState() {
    return _MyAlertDialogState();
  }
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  final TextEditingController _controller = TextEditingController();
  Future<Refer> _futureRefer;

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    phonenumber = prefs.getString('phonenumber');
    var body = {"phone": "+91$phonenumber"};

    final response = await http.post(
      Uri.parse(kGetId),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    setState(() {
      customerId = jsonDecode(response.body);
    });
    print('the response is $customerId');
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: (_futureRefer == null)
            ? builColumn(context)
            : buildFutureBuilder(context),
      ),
    );
  }

  AlertDialog builColumn(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        content: SingleChildScrollView(
          child: Container(
            height: height * 0.55,
            width: width * 0.90,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                      height: height * 0.22,
                      child: Image.asset('assets/pic.jpg')),
                  Spacer(),
                  Text(
                    'Enter the referral code ',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Container(
                    width: width * 0.60,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: 'Enter code, if you have any',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: width * 0.40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.red),
                    child: TextButton(
                      child: Text(
                        'Continue',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        if (this.mounted)
                          setState(() {
                            _futureRefer =
                                createRefer(_controller.text, customerId);
                          });
                      },
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: width * 0.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        border: Border.all(color: Colors.red)),
                    child: TextButton(
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.red, fontSize: 20),
                      ),
                      // onPressed: null,
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PageGuide(
                                    phoneNumber: widget.phonenumber)));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  FutureBuilder<Refer> buildFutureBuilder(BuildContext context) {
    return FutureBuilder<Refer>(
      future: _futureRefer,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.title == true) {
            Future.delayed(Duration.zero, () async {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Voila! Referral code is correct')));
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => PageGuide(
                        phoneNumber: widget.phonenumber,
                      )));
            });
            print(snapshot.data.title);
          } else {
            Future.delayed(Duration.zero, () async {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Incorrect Referral Code. Try Again!')));
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MyAlertDialog(
                        phonenumber: widget.phonenumber,
                      )));
            });
            print(snapshot.data.title);
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator(color: kPrimaryColor);
      },
    );
  }
}

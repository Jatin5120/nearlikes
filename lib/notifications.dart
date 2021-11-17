import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'constants/constants.dart';
import 'package:nearlikes/redeem_coupon.dart';
import 'package:nearlikes/models/get_customer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Customer _getCustomer;

class NotificationPage extends StatefulWidget {
  final cID;
  NotificationPage({this.cID});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

StreamController _customerController;
Future<Customer> getCustomerID({phone}) async {
  print(".....");
  print(phone);
  var body = {"id": "$phone"};
  // var body = {
  //   "id" : "610d8bc622eefa4db0aeed0b"
  // };
  final response = await http.post(
    Uri.parse(kGetCustomer),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  print(".....");
  print(response.statusCode);
  final String responseString = response.body.toString();

  print(responseString);
  _getCustomer = customerFromJson(responseString);
  print(_getCustomer.customer.cashback.length);
  return _getCustomer;
}

loadPosts(var phone) async {
  getCustomerID(phone: phone).then((res) async {
    _customerController.add(res);
    return res;
  });
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    // TODO: implement initState
    _customerController = StreamController();
    loadPosts(widget.cID);
    // print(_getCustomer.customer.cashback.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: kPrimaryColor,
                      size: 30,
                    )),
              ),
              Image.asset('assets/logo.png', width: 46.31, height: 60),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: Text(
                  "NOTIFICATIONS",
                  style: GoogleFonts.montserrat(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: kFontColor,
                  ),
                ),
              ),
              StreamBuilder(
                  stream: _customerController.stream,
                  //future: getCustomerID(phone: "${widget.cID}"),
                  //future: getCustomerID(phone: ""),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      print(snapshot.data);
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _getCustomer.customer.cashback.isEmpty &&
                            _getCustomer.customer.coupons.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 180),
                            child: Text(
                              'No Notifications for now!',
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ))
                        : Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.bottomLeft,
                                child: Text("Reward Section:",
                                    style: GoogleFonts.poppins(
                                      fontSize: 19,
                                      color: Colors.grey.shade800,
                                    )),
                              ),

                              Container(
                                child: _getCustomer.customer.cashback.isNotEmpty
                                    ? ListView.builder(
                                        reverse: true,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _getCustomer
                                            .customer.cashback.length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          int timestamp = _getCustomer.customer
                                              .cashback[index].createdAt;
                                          var date = DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  timestamp * 1000);
                                          var day = DateFormat('dd/MM/yy')
                                              .format(date);
                                          var time =
                                              DateFormat('HH:mm').format(date);
                                          if (_getCustomer.customer
                                                  .cashback[index].used ==
                                              true) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {});
                                              },
                                              child: Column(
                                                children: [
                                                  ListTile(
                                                    contentPadding:
                                                        EdgeInsets.all(1.2),
                                                    // tileColor: Colors.grey,
                                                    trailing: Text(
                                                      "$time\n$day",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: kFontColor,
                                                      ),
                                                    ),
                                                    title: Text(
                                                      'Congrats!',
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      "You've won Rs.${_getCustomer.customer.cashback[index].amount} for posting a story!",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kFontColor,
                                                      ),
                                                    ),
                                                    selected: true,
                                                  ),
                                                  Divider(
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                          return null;
                                        },
                                      )
                                    : Text(
                                        "\nNo Rewards for now!",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red),
                                      ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Coupon Section:",
                                  style: GoogleFonts.poppins(
                                    fontSize: 19,
                                    color: Colors.grey.shade800,
                                  ),
                                  // style: TextStyle(
                                  //   fontSize: 20,
                                  // ),
                                ),
                              ),
                              Container(
                                child: _getCustomer.customer.coupons.isNotEmpty
                                    ? ListView.builder(
                                        reverse: true,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _getCustomer
                                            .customer.coupons.length,
                                        itemBuilder: (BuildContext ctx, index) {
                                          int timestamp = _getCustomer.customer
                                              .coupons[index].createdAt;
                                          var date = DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  timestamp * 1000);
                                          var day = DateFormat('dd/MM/yy')
                                              .format(date);
                                          var time =
                                              DateFormat('HH:mm').format(date);

                                          // if (_getCustomer.customer
                                          //     .coupons[index].used ==
                                          //     false || _getCustomer.customer
                                          //     .coupons[index].used ==
                                          //     true) {
                                          //
                                          // }
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {});
                                            },
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.all(1.2),
                                                  tileColor: Colors.grey,
                                                  //leading: Icon(Icons.add),
                                                  title: Text(
                                                    _getCustomer.customer
                                                        .coupons[index].brand,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    "$time\n$day",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: kFontColor,
                                                    ),
                                                  ),
                                                  subtitle: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Text(
                                                      "Enjoy ${_getCustomer.customer.coupons[index].discount} off on your next visit with code ${_getCustomer.customer.coupons[index].code}",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kFontColor,
                                                      ),
                                                    ),
                                                  ),
                                                  selected: true,
                                                ),
                                                Divider(
                                                  color: Colors.grey,
                                                )
                                              ],
                                            ),
                                          );
                                          // return null;
                                        })
                                    : Text(
                                        "\nNo coupons for now!",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.red),
                                      ),
                              ),

                              // For the refferal part.. uncomment only when the api work is done.
                              // Container(
                              //     child: ListView.builder(
                              //         reverse: true,
                              //         shrinkWrap: true,
                              //         physics: NeverScrollableScrollPhysics(),
                              //         itemCount:
                              //             _getCustomer.customer.referals.length,
                              //         itemBuilder: (BuildContext ctx, index) {
                              //           return GestureDetector(
                              //             onTap: () {
                              //               setState(() {});
                              //             },
                              //             child: Column(
                              //               children: [
                              //                 ListTile(
                              //                   contentPadding:
                              //                       EdgeInsets.all(1.2),
                              //                   tileColor: Colors.grey,
                              //                   //leading: Icon(Icons.add),
                              //                   title: Text(
                              //                     _getCustomer.customer
                              //                         .coupons[index].brand,
                              //                     style: GoogleFonts.montserrat(
                              //                       fontSize: 14,
                              //                       fontWeight: FontWeight.w500,
                              //                       color: kFontColor,
                              //                     ),
                              //                   ),
                              //                   trailing: Text(
                              //                     "13:21",
                              //                     style: GoogleFonts.montserrat(
                              //                       fontSize: 14,
                              //                       fontWeight: FontWeight.w500,
                              //                       color: kFontColor,
                              //                     ),
                              //                   ),
                              //                   subtitle: Padding(
                              //                     padding:
                              //                         const EdgeInsets.all(2.0),
                              //                     child: Text(
                              //                       "Voila!, You've won Rs.10 for the referral on date and day.",
                              //                       style:
                              //                           GoogleFonts.montserrat(
                              //                         fontSize: 13,
                              //                         fontWeight:
                              //                             FontWeight.w400,
                              //                         color: kFontColor,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   selected: true,
                              //                 ),
                              //                 Divider(
                              //                   color: Colors.grey,
                              //                 )
                              //               ],
                              //             ),
                              //           );
                              //         })),
                            ],
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
// return GestureDetector(
//   onTap: () {
//     setState(() {});
//   },
//   child: Column(
//     children: [
//       ListTile(
//         contentPadding: EdgeInsets.all(1.2),
//         tileColor: Colors.grey,
//         //leading: Icon(Icons.add),
//         title: Text(
//           _getCustomer.customer
//               .cashback[index].amount,
//           style: GoogleFonts.montserrat(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: kFontColor,
//           ),
//         ),
//         trailing: Text(
//           "13:21",
//           style: GoogleFonts.montserrat(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: kFontColor,
//           ),
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.all(2.0),
//           child: Text(
//             "Enjoy ${_getCustomer.customer.cashback[index].amount} off on your next visit with code ${_getCustomer.customer.coupons[index].code}",
//             style: GoogleFonts.montserrat(
//               fontSize: 13,
//               fontWeight: FontWeight.w400,
//               color: kFontColor,
//             ),
//           ),
//         ),
//         selected: true,
//       ),
//       Divider(
//         color: Colors.grey,
//       )
//     ],
//   ),

//   // child: Container(
//   //
//   //     // decoration: BoxDecoration(
//   //     //   border: Border(
//   //     //     bottom: BorderSide(
//   //     //     color: Colors.grey,
//   //     //     width: 0.5,
//   //     //   ),),
//   //     //
//   //     //     ),
//   //     child: Padding(
//   //       padding: const EdgeInsets.only(top: 8,bottom: 8),
//   //       child: ListTile(
//   //         tileColor: Colors.grey,
//   //         //leading: Icon(Icons.add),
//   //         title: Text("Brand XYZ",style: GoogleFonts.montserrat(
//   //           fontSize: 14,
//   //           fontWeight: FontWeight.w500,
//   //           color: kFontColor,
//   //         ),),
//   //         trailing: Text("13:21",style: GoogleFonts.montserrat(
//   //           fontSize: 14,
//   //           fontWeight: FontWeight.w500,
//   //           color: kFontColor,
//   //         ),),
//   //         subtitle: Padding(
//   //           padding: const EdgeInsets.all(2.0),
//   //           child: Text("Enjoy 10% off on your next visit with code a3hiKuZsh2",style: GoogleFonts.montserrat(
//   //             fontSize: 13,
//   //             fontWeight: FontWeight.w400,
//   //             color: kFontColor,
//   //           ),),
//   //         ),
//   //         selected: true,
//   //       ),
//   //     ))
// );
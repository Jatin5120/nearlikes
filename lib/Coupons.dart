import 'package:flutter/material.dart';
import 'package:nearlikes/constants/constants.dart';
import 'package:nearlikes/redeem_coupon.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scratcher/widgets.dart';
import 'package:nearlikes/models/get_customer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:nearlikes/models/get_customer.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

Customer _getCustomer;
String customerId;
String phonenumber;

class Coupons extends StatefulWidget {
  final String cID;
  const Coupons({Key key, this.cID}) : super(key: key);

  @override
  _CouponsState createState() => _CouponsState();
}

Future<Customer> getCustomerID({phone}) async {
  print(".....");
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

  return _getCustomer;
}

Future<Customer> couponScratched(String couponId) async {
  print(".....");
  var body = {"id": "$couponId"};
  final response = await http.post(
    Uri.parse(kScratchCoupon),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  print(".....");
  print(response.statusCode);
  final String responseString = response.body.toString();

  print(responseString);

  // _getCustomer = customerFromJson(responseString);
  // print(";;;");
  // print(_getCustomer.customer.name);
  // return _getCustomer;
}

class _CouponsState extends State<Coupons> {
  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // customerId= prefs.getString('customer_id');
    // phonenumber=prefs.getString('phonenumber');
    setState(() {
      customerId = prefs.getString('customer_id');
      phonenumber = prefs.getString('phonenumber');
    });
    print('the phone number is $phonenumber');
    print('user acc id is $customerId');
    if (customerId == null) {
      print('test');
      getCustomerId(phonenumber);
    } else
      getCustomer(customerId);
  }

  Future<Customer> getCustomer(String customerId) async {
    print(".....");
    // var body = {
    //   "id" : "610d8bc622eefa4db0aeed0b"
    // };
    var body = {"id": "$customerId"};
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

    print(";;;");
    //print(sum);
    print(_getCustomer.customer.name);

    // setState(() {
    //   name=_getCustomer.customer.name;
    // });
    return _getCustomer;
  }

  Future getCustomerId(String phonenumber) async {
    // var body = {
    //   "phone" : "+91$phonenumber"
    // };
    var body = {"phone": "+91$phonenumber"};
    final response = await http.post(
      Uri.parse(kGetId),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    var test = jsonDecode(response.body);
    print('the response is ${test}');
    getCustomer(test);
  }

  ConfettiController _controllerTopCenter;
  List mySelTeams;
  String animationName = "celebrationstart";

  void _playAnimation() {
    setState(() {
      if (animationName == "celebrationstart")
        animationName = "celebrationstop";
      else
        animationName = "celebrationstart";
    });
  }

  @override
  void initState() {
    print("customer id is --->${widget.cID}");
    getUserData();
    _controllerTopCenter = ConfettiController(duration: Duration(seconds: 10));
    _controllerTopCenter.play();
    _playAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Color(0xffFF5C58),
              child: Column(
                children: [
                  SizedBox(
                    height: 36,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // Image.asset('assets/logo.png', width: 46.31, height: 60),
                  // SizedBox(
                  //   height: 35,
                  // ),
                  Center(
                    child: Text(
                      "MY COUPONS",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        // color: kFontColor,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilder(
                future: getCustomerID(phone: "${widget.cID}"),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    print(snapshot.data);
                    return Center(child: CircularProgressIndicator());
                  }
                  return _getCustomer.customer.coupons.length == 0
                      ? Padding(
                          padding: EdgeInsets.only(top: 180),
                          child: Text(
                            'Post a story to get coupon',
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ))
                      : GridView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 5 / 4,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 20),
                          itemCount: _getCustomer.customer.coupons.length,
                          itemBuilder: (BuildContext ctx, index) {
                            if (_getCustomer.customer.coupons[index].used ==
                                true) {
                              int a =
                                  _getCustomer.customer.coupons[index].expiry;
                              a = a * 1000;
                              int z =
                                  DateTime.now().toUtc().millisecondsSinceEpoch;
                              bool expired = false;
                              if (z > a) expired = true;
                              print('hel $a');
                              print('ckg $z');
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RedeemCoupon(
                                              code: _getCustomer
                                                  .customer.coupons[index].code,
                                              brand: _getCustomer.customer
                                                  .coupons[index].brand,
                                              link: _getCustomer
                                                  .customer.coupons[index].link,
                                              discount: _getCustomer.customer
                                                  .coupons[index].discount,
                                              expiry: _getCustomer.customer
                                                  .coupons[index].expiry)));
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 8),
                                  child: Card(
                                    elevation: 5,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            color: expired
                                                ? Colors.red
                                                : kFontColor.withOpacity(0.2)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: expired
                                                ? Icon(
                                                    Icons.error_rounded,
                                                    color: Colors.red,
                                                    size: 18,
                                                  )
                                                : Icon(
                                                    Icons.check,
                                                    color: Colors.transparent,
                                                  ),
                                          ),

                                          SizedBox(
                                            height: 7,
                                          ),
                                          Image.asset(
                                            "assets/trophy.png",
                                            width: 30,
                                            height: 30,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "You've won",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            _getCustomer
                                                .customer.coupons[index].code,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: kPrimaryColor),
                                          ),
                                          Text(
                                            _getCustomer
                                                .customer.coupons[index].brand,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                                color: kFontColor),
                                          ),
                                          // SizedBox(
                                          //   height: 5,
                                          // ),
                                        ],
                                      ),
                                      //child: Center(child: Text("Rs. "+_getCustomer.customer.cashback[index].amount,)),
                                    ),
                                  ),
                                ),
                              );
                            } else
                              return GestureDetector(
                                  onTap: () async {
                                    await goToDialog(
                                        _getCustomer
                                            .customer.coupons[index].code,
                                        _getCustomer
                                            .customer.coupons[index].brand,
                                        _getCustomer
                                            .customer.coupons[index].id);
                                    print("tapped");

                                    // setState(() {
                                    //   couponScratched(_getCustomer.customer.coupons[index].id);
                                    // });
                                    await couponScratched(_getCustomer
                                        .customer.coupons[index].id);
                                    setState(() {
                                      print("tapped");
                                    });

                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => BrandStories()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Image.asset('assets/scratch_card.png'),
                                  ));
                          });
                }),
            // Container(
            //   height: 500,
            //   child:
            // ),

            // GridView.builder(
            //     physics: NeverScrollableScrollPhysics(),
            //     shrinkWrap: true,
            //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //         maxCrossAxisExtent: 200,
            //         childAspectRatio: 3 / 2,
            //         crossAxisSpacing: 0,
            //         mainAxisSpacing: 20),
            //     itemCount: _getCustomer.customer.coupons.length,
            //     itemBuilder: (BuildContext ctx, index) {
            //       if(_getCustomer.customer.coupons[index].used)
            //       {
            //         return GestureDetector(
            //           onTap: (){
            //             Navigator.push(context, MaterialPageRoute(builder: (context) =>RedeemCoupon(code:_getCustomer.customer.coupons[index].code,brand: _getCustomer.customer.coupons[index].brand,link: _getCustomer.customer.coupons[index].link,discount: _getCustomer.customer.coupons[index].discount,expiry:_getCustomer.customer.coupons[index].expiry)));
            //           },
            //           child: Padding(
            //             padding: const EdgeInsets.only(right: 8,left: 8),
            //             child: Container(
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.all(Radius.circular(5)),
            //                 border: Border.all(color: kFontColor.withOpacity(0.2)),
            //               ),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: <Widget>[
            //                   SizedBox(height: 7,),
            //                   Image.asset(
            //                     "assets/trophy.png",width: 30,height: 30,),
            //                   SizedBox(height: 8,),
            //                   Text(
            //                     "You've won",
            //                     style: TextStyle(
            //                         fontWeight: FontWeight.bold,
            //                         fontSize: 12,
            //                         color: Colors.black),
            //                   ),
            //                   SizedBox(height: 2,),
            //                   Text(
            //                     _getCustomer.customer.coupons[index].code,
            //                     style: TextStyle(
            //                         fontWeight: FontWeight.bold,
            //                         fontSize: 15,
            //                         color: kPrimaryOrange),
            //                   ),
            //                   Text(
            //                     _getCustomer.customer.coupons[index].brand,
            //                     style: TextStyle(
            //                         fontWeight: FontWeight.bold,
            //                         fontSize: 13,
            //                         color: kFontColor),
            //                   ),
            //                   SizedBox(height: 5,),
            //
            //                 ],
            //               ),
            //               //child: Center(child: Text("Rs. "+_getCustomer.customer.cashback[index].amount,)),
            //             ),
            //           ),
            //         );
            //       }
            //       else
            //         return GestureDetector(
            //             onTap: () async{
            //               await goToDialog(_getCustomer.customer.coupons[index].code,_getCustomer.customer.coupons[index].brand);
            //               print("tapped");
            //               print(_getCustomer.customer.coupons[index].id);
            //               setState(() async{
            //                 await couponScratched(_getCustomer.customer.coupons[index].id);
            //               });
            //               // await couponScratched(_getCustomer.customer.coupons[index].id);
            //               // setState(() {
            //               //   print("tapped");
            //               // });
            //
            //               //Navigator.push(context, MaterialPageRoute(builder: (context) => BrandStories()));
            //             },
            //             child: Image.asset('assets/scratch_card.png'));
            //     }),
            // Container(
            //   height: 500,
            //   child: GridView.builder(
            //       physics: NeverScrollableScrollPhysics(),
            //       shrinkWrap: true,
            //       gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //           maxCrossAxisExtent: 200,
            //           childAspectRatio: 3 / 2,
            //           crossAxisSpacing: 0,
            //           mainAxisSpacing: 20),
            //       itemCount: _getCustomer.customer.coupons.length,
            //       itemBuilder: (BuildContext ctx, index) {
            //         if(_getCustomer.customer.coupons[index].used)
            //         {
            //           return GestureDetector(
            //             onTap: (){
            //               Navigator.push(context, MaterialPageRoute(builder: (context) =>RedeemCoupon(code:_getCustomer.customer.coupons[index].code,brand: _getCustomer.customer.coupons[index].brand,link: _getCustomer.customer.coupons[index].link,discount: _getCustomer.customer.coupons[index].discount,expiry:_getCustomer.customer.coupons[index].expiry)));
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 8,left: 8),
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.all(Radius.circular(5)),
            //                   border: Border.all(color: kFontColor.withOpacity(0.2)),
            //                 ),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: <Widget>[
            //                     SizedBox(height: 7,),
            //                     Image.asset(
            //                       "assets/trophy.png",width: 30,height: 30,),
            //                     SizedBox(height: 8,),
            //                     Text(
            //                       "You've won",
            //                       style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 12,
            //                           color: Colors.black),
            //                     ),
            //                     SizedBox(height: 2,),
            //                     Text(
            //                       _getCustomer.customer.coupons[index].code,
            //                       style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 15,
            //                           color: kPrimaryOrange),
            //                     ),
            //                     Text(
            //                       _getCustomer.customer.coupons[index].brand,
            //                       style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 13,
            //                           color: kFontColor),
            //                     ),
            //                     SizedBox(height: 5,),
            //
            //                   ],
            //                 ),
            //                 //child: Center(child: Text("Rs. "+_getCustomer.customer.cashback[index].amount,)),
            //               ),
            //             ),
            //           );
            //         }
            //         else
            //           return GestureDetector(
            //               onTap: () async{
            //                 await goToDialog(_getCustomer.customer.coupons[index].code,_getCustomer.customer.coupons[index].brand);
            //                 print("tapped");
            //                 print(_getCustomer.customer.coupons[index].id);
            //                 setState(() {
            //                   couponScratched(_getCustomer.customer.coupons[index].id);
            //                 });
            //                 // await couponScratched(_getCustomer.customer.coupons[index].id);
            //                 // setState(() {
            //                 //   print("tapped");
            //                 // });
            //
            //                 //Navigator.push(context, MaterialPageRoute(builder: (context) => BrandStories()));
            //               },
            //               child: Image.asset('assets/scratch_card.png'));
            //       }),
            // ),

            // Container(
            //   height: 500,
            //   child: FutureBuilder(
            //       future: getCustomer("$customerId"),
            //       builder: (context, AsyncSnapshot snapshot) {
            //         if (!snapshot.hasData) {
            //           print(snapshot.data);
            //           return Center(child: CircularProgressIndicator());
            //         }
            //         return GridView.builder(
            //             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //                 maxCrossAxisExtent: 200,
            //                 childAspectRatio: 3 / 2,
            //                 crossAxisSpacing: 0,
            //                 mainAxisSpacing: 20),
            //             itemCount: _getCustomer.customer.coupons.length,
            //             itemBuilder: (BuildContext ctx, index) {
            //               if(_getCustomer.customer.coupons[index].used)
            //               {
            //                 return GestureDetector(
            //                   onTap: (){
            //                     Navigator.push(context, MaterialPageRoute(builder: (context) =>RedeemCoupon(code:_getCustomer.customer.coupons[index].code,brand: _getCustomer.customer.coupons[index].brand,link: _getCustomer.customer.coupons[index].link,discount: _getCustomer.customer.coupons[index].discount,expiry:_getCustomer.customer.coupons[index].expiry)));
            //                   },
            //                   child: Padding(
            //                     padding: const EdgeInsets.only(right: 8,left: 8),
            //                     child: Container(
            //                       decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.all(Radius.circular(5)),
            //                         border: Border.all(color: kFontColor.withOpacity(0.2)),
            //                       ),
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.center,
            //                         children: <Widget>[
            //                           SizedBox(height: 7,),
            //                           Image.asset(
            //                             "assets/trophy.png",width: 30,height: 30,),
            //                           SizedBox(height: 8,),
            //                           Text(
            //                             "You've won",
            //                             style: TextStyle(
            //                                 fontWeight: FontWeight.bold,
            //                                 fontSize: 12,
            //                                 color: Colors.black),
            //                           ),
            //                           SizedBox(height: 2,),
            //                           Text(
            //                             _getCustomer.customer.coupons[index].code,
            //                             style: TextStyle(
            //                                 fontWeight: FontWeight.bold,
            //                                 fontSize: 15,
            //                                 color: kPrimaryOrange),
            //                           ),
            //                           Text(
            //                             _getCustomer.customer.coupons[index].brand,
            //                             style: TextStyle(
            //                                 fontWeight: FontWeight.bold,
            //                                 fontSize: 13,
            //                                 color: kFontColor),
            //                           ),
            //                           SizedBox(height: 5,),
            //
            //                         ],
            //                       ),
            //                       //child: Center(child: Text("Rs. "+_getCustomer.customer.cashback[index].amount,)),
            //                     ),
            //                   ),
            //                 );
            //               }
            //               else
            //                 return GestureDetector(
            //                     onTap: () async{
            //                       await goToDialog(_getCustomer.customer.coupons[index].code,_getCustomer.customer.coupons[index].brand);
            //                       print("tapped");
            //                       // setState(() {
            //                       //   couponScratched(_getCustomer.customer.coupons[index].id);
            //                       // });
            //                       await couponScratched(_getCustomer.customer.coupons[index].id);
            //                       setState(() {
            //                         print("tapped");
            //                       });
            //
            //                       //Navigator.push(context, MaterialPageRoute(builder: (context) => BrandStories()));
            //                     },
            //                     child: Image.asset('assets/scratch_card.png'));
            //             });
            //       }
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  goToDialog(amount, brand, coupon_id) {
    showDialog(
        //barrierColor: Colors.black.withOpacity(0.2),
        context: context,
        //barrierDismissible: true,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    successTicket(amount, brand, coupon_id),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.black54,
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  successTicket(amount, brand, coupon_id) => Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Material(
              clipBehavior: Clip.antiAlias,
              elevation: 2.0,
              borderRadius: BorderRadius.circular(4.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _controllerTopCenter.play();
                          },
                          child: Text(
                            "Congratulations!",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              color: kFontColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "You have won a scratch card.",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            color: kFontColor,
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: ConfettiWidget(
                                confettiController: _controllerTopCenter,
                                blastDirection: 0,
                                emissionFrequency: 0.1,
                                numberOfParticles: 90,
                                maxBlastForce: 15,
                                minBlastForce: 9,
                                //  maxBlastForce: 10,
                                //shouldLoop: true,
                                minimumSize: const Size(2,
                                    5), // set the minimum potential size for the confetti (width, height)
                                maximumSize: const Size(10, 10),
                                //colors: [kPrimaryOrange,kPrimaryPink,kLightGrey]
                              ),
                            ),
                            Card(
                              elevation: 6.0,
                              //margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 10,
                                        spreadRadius: 0,
                                        offset: Offset(0, 0))
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: new ScratchCardW(
                                    brand: brand,
                                    value: amount,
                                    docId: "ddd",
                                    uId: coupon_id),
                              ),
                            ),
                          ],
                        ),
                        // ScratchCardView(
                        //                                           value: paidAmount.round(), docId: docId, uId: userId
                        //                                             ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

class ScratchCardW extends StatefulWidget {
  final String brand;
  final String value;
  final String docId, uId;
  const ScratchCardW({this.value, this.docId, this.uId, this.brand});

  @override
  _ScratchCardWState createState() => _ScratchCardWState();
}

class _ScratchCardWState extends State<ScratchCardW> {
  double _opacity = 0.0;
  double brush = 50;
  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 1000), () {});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scratcher(
      onScratchEnd: () {
        setState(() async {
          await couponScratched(widget.uId);
        });
      },
      accuracy: ScratchAccuracy.low,
      threshold: 35,
      brushSize: brush,
      onThreshold: () {
        print("Threshold reached, you won!");
        setState(() {
          _opacity = 1;
          brush = 500;
        });
      },
      color: Colors.greenAccent.shade700,
      image: Image.asset("assets/scratchcard.png"),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 250),
        opacity: _opacity,
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/trophy.png",
                  width: 100,
                  height: 95,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "You've won",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.value}".toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: kPrimaryColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.brand}" == "" ? "" : widget.brand,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: kDarkGrey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

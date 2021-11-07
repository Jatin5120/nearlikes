import 'package:flutter/material.dart';
import 'package:nearlikes/home_page.dart';
import 'package:nearlikes/link_UPI.dart';
import 'package:nearlikes/page_guide.dart';
import 'theme.dart';
import 'package:confetti/confetti.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scratcher/widgets.dart';
import 'package:nearlikes/models/get_customer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rate_my_app/rate_my_app.dart';

Customer _getCustomer;
String customerId;
String phonenumber;
String cashbackId;
bool  upi=false;

Future<String> cashbackScratched(String couponId) async {
  print('the customer id is $phonenumber');
  print("..8989..");
  print('the coupon id is $couponId');
  final String apiUrl =
      "https://nearlikes.com/v1/api/client/cashback/scratch/v2";
  var body = {"id": "$couponId", "phone": "+91$phonenumber"};
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  print(".....");
  print(response.statusCode);
  print('----');
  final String responseString = response.body.toString();
  print(']||/*/');
  print(responseString);
  print('232323');
  return responseString;
  // _getCustomer = customerFromJson(responseString);
  // print(";;;");
  // print(_getCustomer.customer.name);
  // return _getCustomer;
}

// Future<String> cashbackScratched(String couponId) async {
//   print('the customer id is $customerId');
//   print("..8989..");
//   print('the coupon id is $couponId');
//   final String apiUrl = "https://nearlikes.com/v1/api/client/cashback/scratch";
//   var body = {
//     "id": "$couponId",
//     "ownerId": "$customerId"
//   };
//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {"Content-Type": "application/json"},
//     body: json.encode(body),
//   );
//
//   print(".....");
//   print(response.statusCode);
//   print('----');
//   final String responseString = response.body.toString();
//   print(']||/*/');
//   print(responseString);
//   print('232323');
//   return responseString;
//   // _getCustomer = customerFromJson(responseString);
//   // print(";;;");
//   // print(_getCustomer.customer.name);
//   // return _getCustomer;
// }

class ScratchCards extends StatefulWidget {

  final cID;
  ScratchCards({this.cID});

  @override
  _ScratchCardsState createState() => _ScratchCardsState();
}

// getCustomerId(String phonenumber)async{
//   var body = {
//     "phone" : "+91$phonenumber"
//   };
//
//   final response = await http.post(
//     Uri.parse('https://nearlikes.com/v1/api/client/getid'),
//     headers: {"Content-Type": "application/json"},
//     body: json.encode(body),
//   );
//   var customerId=jsonDecode(response.body);
//   print('the response is ${customerId}');
// }

// Future<Customer> getCustomerID({phone}) async {
//   print('13231323 $phone');
//   print(".....");
//   final String apiUrl = "https://nearlikes.com/v1/api/client/own/fetch";
//   var body = {
//     "id" : "$phone"
//   };
//   final response = await http.post(
//     Uri.parse(apiUrl),
//     headers: {"Content-Type": "application/json"},
//     body: json.encode(body),
//   );
//
//   print(".....");
//   print(response.statusCode);
//   final String responseString = response.body.toString();
//
//   print(responseString);
//   _getCustomer = customerFromJson(responseString);
//
//   return _getCustomer;
// }


class _ScratchCardsState extends State<ScratchCards> {

  Future<Customer> getCustomer(String customerId) async {
    print(".....");
    print('13231323 $customerId');
    final String apiUrl = "https://nearlikes.com/v1/api/client/own/fetch";
    var body = {
      "id" : "$customerId"
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    print(".....");
    print(response.statusCode);
    final String responseString = response.body.toString();

    print(responseString);
    _getCustomer = customerFromJson(responseString);
    print(";;;");
    print(_getCustomer.customer.name);

    if( _getCustomer.customer.upi!=null)
    {print('upi is true');
     setState(() {
       upi=true;
     });
    }
    return _getCustomer;
  }



  int sum = 0;
  Future getCustomerId(String phonenumber)async{
    // var body = {
    //   "phone" : "+91$phonenumber"
    // };
    var body = {
      "phone" : "+91$phonenumber"
    };
    final response = await http.post(
      Uri.parse('https://nearlikes.com/v1/api/client/getid'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    var test=jsonDecode(response.body);
    print('the response is ${test}');
    setState(() {
      customerId=test;
    });
    for (int i = 0; i < _getCustomer.customer.cashback.length; i++) {
      if (_getCustomer.customer.cashback[i].used == true) {
        var a = int.parse(_getCustomer.customer.cashback[i].amount);
        assert(a is int);

        sum = sum + a;
      }
    }
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

  getUserData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // customerId= prefs.getString('customer_id');
    // phonenumber=prefs.getString('phonenumber');
    setState(() {
      customerId= prefs.getString('customer_id');
      phonenumber=prefs.getString('phonenumber');
    });
    print('the phone number is $phonenumber');
    print('user acc id is $customerId');
    if(customerId==null){
      print('test');
      getCustomerId(phonenumber);
    }
    else getCustomer(customerId);

  }

  @override
  void initState() {
    getUserData();
    _controllerTopCenter = ConfettiController(duration: Duration(seconds: 10));
    _controllerTopCenter.play();
    _playAnimation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // color: Colors.redAccent.shade400,

                color: Color(0xffFF5C58),
                child: Column(
                  children: [
                    SizedBox(
                      height: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
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

                    // SizedBox(
                    //   height: 0,
                    // ),
                    // Image.asset('assets/logo.png', width: 46.31, height: 60),
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      'Rs. $sum',
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 24),
                    ),
                    Center(
                      child: Text(
                        "TOTAL CASH REWARDS",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            // color: kFontColor,
                            color: Colors.white),
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
                  future: getCustomer(widget.cID),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      print(snapshot.data);
                      return Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return _getCustomer.customer.cashback.length == 0
                        ? Padding(
                        padding: EdgeInsets.only(top: 180),
                        child: Text(
                          'Post a story to get cash reward',
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        ))
                        : GridView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                        SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 220,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 20),
                        itemCount: _getCustomer.customer.cashback.length,
                        itemBuilder: (BuildContext ctx, index) {
                          if (_getCustomer
                              .customer.cashback[index].scratched) {
                            return Padding(
                              padding:
                              const EdgeInsets.only(right: 8, left: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                      color: kFontColor.withOpacity(0.2)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 7,
                                    ),
                                    Image.asset(
                                      "assets/trophy.png",
                                      width: 40,
                                      height: 40,
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
                                      "Rs. " +
                                          _getCustomer.customer
                                              .cashback[index].amount,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: kPrimaryOrange),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                //child: Center(child: Text("Rs. "+_getCustomer.customer.cashback[index].amount,)),
                              ),
                            );
                          } else
                            return GestureDetector(
                                onTap: () async {
                                  await goToDialog(
                                      "Rs. " +
                                          _getCustomer.customer
                                              .cashback[index].amount,
                                      "");
                                  print("tapped");

                                  setState(() {
                                    cashbackId = _getCustomer
                                        .customer.cashback[index].id;
                                  });
                                  // upi=await cashbackScratched(_getCustomer.customer.cashback[index].id);
                                  // print('2323 $upi');

                                  // setState(() {
                                  //   cashbackScratched(_getCustomer.customer.cashback[index].id);
                                  // });

                                  // await Future.delayed(const Duration(milliseconds: 500), () {
                                  //   setState(() async{
                                  //     await  cashbackScratched(_getCustomer.customer.cashback[index].id);
                                  //   });
                                  //
                                  // });

                                  // setState(() {
                                  //   print("tapped");
                                  // });

                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => BrandStories()));
                                },
                                child:
                                Image.asset('assets/scratch_card.png'));
                        });
                  }),

              // Container(
              //   height: 200,
              //   child: FutureBuilder(
              //       future: getCustomerID(phone:'+919790984081'),
              //       builder: (context, AsyncSnapshot snapshot) {
              //         // if (!snapshot.hasData) {
              //         //   print(snapshot.data);
              //         //   return Center(child: CircularProgressIndicator());
              //         // }
              //         return GridView.builder(
              //             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //                 maxCrossAxisExtent: 200,
              //                 childAspectRatio: 3 / 2,
              //                 crossAxisSpacing: 20,
              //                 mainAxisSpacing: 20),
              //             itemCount: _getCustomer.customer.coupons.length,
              //             itemBuilder: (BuildContext ctx, index) {
              //               return GestureDetector(
              //                   onTap: () {
              //                     goToDialog(_getCustomer.customer.coupons[index].code,_getCustomer.customer.coupons[index].brand);
              //                     //Navigator.push(context, MaterialPageRoute(builder: (context) => BrandStories()));
              //                   },
              //                   child: Image.asset('assets/scratch_card.png'));
              //             });
              //       }
              //   ),
              // ),
            ],
          ),
        ),
      );
  }
  goToDialog(amount,brand){
    showDialog(
      //barrierColor: Colors.black.withOpacity(0.2),
        context: context,
        //barrierDismissible: true,
        builder: (context) => Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                successTicket(amount,brand),
                SizedBox(
                  height: 10.0,
                ),
                // FloatingActionButton(
                //   backgroundColor: Colors.black54,
                //   child: Icon(
                //     Icons.clear,
                //     color: Colors.white,
                //   ),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                // )
              ],
            ),
          ),
        ));
  }
  successTicket(amount,brand) => Stack(
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
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){ _controllerTopCenter.play();

                      },
                      child: Text(
                        "Congratulations!",
                        style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w700, color:kFontColor,),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "You have won a scratch card.",
                      style: TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.normal, color:kFontColor,),
                    ),
                    SizedBox(height: 18,),
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
                            child:  new ScratchCardW(
                              brand: brand,
                                value: amount,
                                docId: "ddd",
                                uId: "dddd"
                            ),
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
  ScratchCardW({this.value, this.docId, this.uId,this.brand});

  @override
  _ScratchCardWState createState() => _ScratchCardWState();
}

class _ScratchCardWState extends State<ScratchCardW> {
  double _opacity = 0.0;
  double brush= 50;
  Future<bool> _mockCheckForSession() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    return true;
  }

ScratchCardValue(couponId)async{
    print('the cashback id is @$couponId');
  var body = {
    "id": "$couponId",

  };
  final response = await http.post(
    Uri.parse("https://nearlikes.com/v1/api/client/card/scratch"),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );
  print('value value ${response.body}');
}

  RateMyApp rateMyApp = RateMyApp(
    googlePlayIdentifier: 'com.evolveinno.nearlikes',
    minDays: 0,
    minLaunches: 0,
    remindLaunches: 0,
    remindDays: 0,
  );
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => reset());
  }
  List<DebuggableCondition> conditions = [];
  bool shouldOpenDialog;
  T getCondition<T>() => rateMyApp.conditions.whereType<T>().toList().first;
  @override
  Widget build(BuildContext context) {
    final minimumDays = getCondition<MinimumDaysCondition>();
    final minimumLaunches = getCondition<MinimumAppLaunchesCondition>();
    final doNotOpenAgain = getCondition<DoNotOpenAgainCondition>();
    minimumDays.minimumDate = DateTime.now();
    return RateMyAppBuilder(
      builder: (context) => Scratcher(
        accuracy: ScratchAccuracy.low,
        threshold:5,
        brushSize: brush,
        onChange: (value){print('sadasd$value');},

        onThreshold: () {
          print("Threshold reached, you won!");
          setState(() {
            _opacity = 1;
            brush=500;
          });

          _mockCheckForSession().then((value) async{
            if(upi==false){
              return showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text('Add UPI'),
                  content: Text('Please add your upi for getting the cash reward '),
                  actions: [
                    FlatButton(onPressed: ()async{
                      await ScratchCardValue(cashbackId);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LinkUPI(cashbackId: cashbackId,)));
                    }, child:Text('OK') )
                  ],
                );});}
            else if (upi==true){
              // await ScratchCardValue(cashbackId);
              await cashbackScratched(cashbackId);
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Bravo!',style: TextStyle(color: Colors.red),),
                      content: Text(
                          'Your cashback will be credited after 24 hours! '),
                      actions: [
                        FlatButton(
                            onPressed: () async {
                              // await ScratchCardValue(cashbackId);
                              // Navigator.pop(context);
                              // Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return PageGuide();
                                  }));
                            },
                            child: Text('OK'))
                      ],
                    );
                  });
              //Navigator.push(context, MaterialPageRoute(builder: (context) { return PageGuide();}));

            }
          });


        },
        color: Colors.greenAccent.shade700,
        image: Image.asset("assets/scratchcard.png"),

        child: AnimatedOpacity(
          duration: Duration(milliseconds: 250),
          opacity: _opacity,
          child: Container(
            alignment: Alignment.center,
            child:
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/trophy.png",width: 100,height: 95,),
                  SizedBox(height: 10,),
                  Text(
                    "You've won",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "${widget.value}".toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: kPrimaryOrange),
                  ),
                  SizedBox(height: 2,),
                  // Text(
                  //   "${widget.brand}"==""?"":widget.brand,
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 22,
                  //       color:kDarkGrey),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
      rateMyApp: rateMyApp,
      onInitialized: (context, rateMyApp) {
        setState(() {
          this.rateMyApp = rateMyApp;
          shouldOpenDialog = rateMyApp.shouldOpenDialog;
          doNotOpenAgain.doNotOpenAgain = false;
        });

        // print("Conditions 1 ----------------------------------------------------------------");
        // print('Minimum Days: ${minimumDays.minDays}');
        // print('Remind After Days: ${minimumDays.remindDays}');
        // print('Current Launches: ${minimumLaunches.launches}');
        // print('Minimum Launches: ${minimumLaunches.minLaunches}');
        // print('Remind After Launches: ${minimumLaunches.remindLaunches}');
        // //print('Open Rating Again? $openRatingAgain');
        // print('Are Conditions Met? $hasMetConditions');

        print("Conditions  ----------------------------------------------------------------");

        rateMyApp.conditions.forEach((condition) {
          if (condition is DebuggableCondition) {
            print(condition.valuesAsString);
          }
        });

        print('Are all conditions met ? ' + (rateMyApp.shouldOpenDialog ? 'Yes' : 'No'));

        if (shouldOpenDialog && doNotOpenAgain.doNotOpenAgain == false) {
          print("Show Star Rate Dialog");
          rateMyApp.showStarRateDialog(
            context,
            title: 'Rate this app',
            message: 'You like this app ? Then take a little bit of your time to leave a rating :',
            actionsBuilder: (context, stars) { // Triggered when the user updates the star rating.
              return [
                TextButton(
                  child: Text('RATE US'),
                  onPressed: () async {
                    print('Thanks for the ' + (stars == null ? '0' : stars.round().toString()) + ' star(s) !');
                    await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                    await rateMyApp.launchStore();
                    rateMyApp.save().then((v) => setState(() {
                      doNotOpenAgain.doNotOpenAgain = true;
                      shouldOpenDialog = false;
                    }));
                    Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.rate);
                  },
                ),
                TextButton(
                  child: Text('MAYBE LATER'),
                  onPressed: () async {
                    await rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
                    rateMyApp.save().then((v) => setState(() {
                      doNotOpenAgain.doNotOpenAgain = false;
                      shouldOpenDialog = true;
                    }));
                    Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.later);
                  },
                ),
                TextButton(
                  child: Text('NO, THANKS!'),
                  onPressed: () async {
                    await rateMyApp.callEvent(RateMyAppEventType.noButtonPressed);
                    rateMyApp.save().then((v) => setState(() {
                      doNotOpenAgain.doNotOpenAgain = true;
                      shouldOpenDialog = false;
                    }));
                    print("doNotOpenAgain - " + doNotOpenAgain.doNotOpenAgain.toString());
                    print("shouldOpenDialog - " + shouldOpenDialog.toString());
                    Navigator.pop<RateMyAppDialogButton>(context, RateMyAppDialogButton.no);
                  },
                ),
              ];
            },
            dialogStyle: DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions: StarRatingOptions(
              initialRating: 4.0,
            ),
          );
        }
      },
    );
  }

  Future reset() async {
    print("Reset Dialog Called");
    await rateMyApp.reset();
    setState(() {
      conditions = rateMyApp.conditions.whereType<DebuggableCondition>().toList();
      shouldOpenDialog = rateMyApp.shouldOpenDialog;
    });
  }

}
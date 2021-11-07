import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearlikes/Coupons.dart';
import 'package:nearlikes/LinkBank.dart';
import 'package:nearlikes/about_page.dart';
import 'package:nearlikes/brand_stories.dart';
import 'package:nearlikes/faq.dart';
import 'package:nearlikes/help_page.dart';
import 'package:nearlikes/history_page.dart';
import 'package:nearlikes/login.dart';
import 'package:nearlikes/page_guide.dart';
import 'package:nearlikes/referral.dart';
import 'package:nearlikes/scratch_cards.dart';
import 'package:nearlikes/select_brand.dart';
import 'constants/colors.dart';
import 'link_UPI.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'models/get_campaigns.dart';
import 'dart:convert';
import 'dart:async';
import 'package:nearlikes/models/get_customer.dart';
import 'theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

Customer _getCustomer;
String CID;
String code;

String name='';
String phonenumber;
class ProfilePage extends StatefulWidget {
  final phoneNumber;
  ProfilePage({this.phoneNumber});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}


// void get()async{
//   await getCustomer();
// }

class _ProfilePageState extends State<ProfilePage> {
  int sum=0;

  // Future<Customer> getCustomer(String customerId) async {
  //   print(".....");
  //   final String apiUrl = "https://nearlikes.com/v1/api/client/own/fetch";
  //   var body = {
  //     "id" : "$customerId"
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
  //   for(int i=0;i<_getCustomer.customer.cashback.length;i++)
  //   {
  //     if(_getCustomer.customer.cashback[i].used)
  //     {
  //       print(_getCustomer.customer.cashback[i].amount);
  //       var a = int.parse(_getCustomer.customer.cashback[i].amount);
  //       assert(a is int);
  //
  //       sum = sum + a;
  //     }
  //   }
  //   print(";;;");
  //   print(sum);
  //   print(_getCustomer.customer.name);
  //   setState(() {
  //     name=_getCustomer.customer.name;
  //   });
  //   return _getCustomer;
  // }

  Future<Customer> getCustomer(String customerId) async {
    setState(() {sum=0;});
    print(".....");
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
    // for(int i=0;i<_getCustomer.customer.cashback.length;i++)
    //   {
    //     print(_getCustomer.customer.cashback[i].amount);
    //   var a=int.parse(_getCustomer.customer.cashback[i].amount);
    //   assert(a is int);
    //
    //   sum=sum + a;
    //   }
    for(int i=0;i<_getCustomer.customer.cashback.length;i++)
    {
      if(_getCustomer.customer.cashback[i].used==true){
        var a=int.parse(_getCustomer.customer.cashback[i].amount);
        assert(a is int);

        sum=sum + a;
      }

    }
    print(";;;");
    print(sum);
    print(_getCustomer.customer.name);
    setState(() {
      name=_getCustomer.customer.name;
      CID=_getCustomer.customer.id;
      code = _getCustomer.customer.code;
    });
    return _getCustomer;
  }

  deleteAcc()async {

    print('the phone number is $phonenumber');
    // var body = {
    //   "phone": "+91${phonenumber}"
    // };
    var body = {
      "phone" : "+91$phonenumber"
    };
    final response1 = await http.post(
      Uri.parse('https://nearlikes.com/v1/api/client/delete'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    print(response1.statusCode);
    print('/////////');
    print(response1.body);
  }
  getCustomerId(String phonenumber)async{
    var body = {
      "phone" : "+91$phonenumber"
    };
    // var body = {
    //   "phone" : "+919840746712"
    // };
    final response = await http.post(
      Uri.parse('https://nearlikes.com/v1/api/client/getid'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    var test=jsonDecode(response.body);
    print('the response is ${test}');
    getCustomer(test);
  }
  String customerId;
  getUserData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
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

  getStatus(phNum)async{
    print('This function to check user login status! $phNum');
    var body = {"phone": "${phNum}",};
    var checkuser= await http.post(Uri.parse('https://nearlikes.com/v1/api/client/check'),headers: {"Content-Type": "application/json"},
      body: json.encode(body),);
    print(checkuser.body);
    if(checkuser.body=='2'){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await  prefs.clear();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()),ModalRoute.withName("/Home"));
    }
  }

  @override
  void initState() {
    //get();
    getUserData();
    super.initState();
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 4));
    setState(() {sum=0;});
    getUserData();
    getCustomer(customerId);
    getStatus(phonenumber);

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: (){
          return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PageGuide()),ModalRoute.withName("/Home"));
          //   Navigator.popUntil(context,ModalRoute.withName(PageGuide().toString()));
          // },
        },
        child: SafeArea(child:  Scaffold(
          body: RefreshIndicator(
            color: kPrimaryOrange,
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(top: 24, left: 30, right: 30),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(name.toString(),
                              style: GoogleFonts.montserrat(
                                fontSize: 29,
                                fontWeight: FontWeight.w700,
                                color: kBlack,
                              )),
                          IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Help()));
                              },
                              icon: Icon(Icons.help_outline_sharp,
                                size: 25,
                                color: kPrimaryOrange,
                              ))
                        ],
                      ),
                      Container(
                        height: 200,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Positioned(
                            //   top:70,
                            //   left:MediaQuery.of(context).size.width*0.178,
                            //   child: Container(
                            //     height: 117,
                            //     width: 186,
                            //     decoration: BoxDecoration(
                            //         color: Color(0xfff2f2f2),
                            //         borderRadius: BorderRadius.all(Radius.circular(8))
                            //     ),
                            //     child: Column(
                            //       children: [
                            //         // SizedBox(height: 45,),
                            //         // Text('TOTAL REWARDS',style: GoogleFonts.montserrat(
                            //         //   fontSize: 11,
                            //         //   fontWeight: FontWeight.w300,
                            //         //   color: Color(0xffB9B9B9),
                            //         // )),
                            //         // SizedBox(height: 8,),
                            //         // Text("Rs. $sum",
                            //         //     style: GoogleFonts.montserrat(
                            //         //       fontSize: 24,
                            //         //       fontWeight: FontWeight.w600,
                            //         //       color: kBlack,
                            //         //     )),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            Positioned(
                              top:30,
                              left:MediaQuery.of(context).size.width*0.325,
                              child: Container(
                                height: 72,
                                width: 72,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape:BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: const Offset(
                                        4, 8,
                                      ),
                                      blurRadius: 20.0,
                                      spreadRadius: 0,
                                    ), //BoxShadow//BoxShadow
                                  ],
                                ),
                                child:  Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Image.asset('assets/logo.png',width:32.48,height:42.28),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //SizedBox(height: 50,),
                      // GestureDetector(
                      //   onTap: (){
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => ScratchCards(cID: CID,)));
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     // children: [
                      //     //   // Expanded(child: Text('Cash Rewards',style: GoogleFonts.montserrat(
                      //     //   //   fontSize: 16,
                      //     //   //   fontWeight: FontWeight.w500,
                      //     //   //   color: kBlack,
                      //     //   // )),),
                      //     //   //Icon(Icons.arrow_forward,color: kPrimaryOrange,)
                      //     // ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 15),
                      //   child: Divider(color: Color(0xffDDDDDD)),
                      // ),
                      // GestureDetector(
                      //   onTap: (){
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => Coupons(cID:CID,)));
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Expanded(child: Text('Coupons',style: GoogleFonts.montserrat(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500,
                      //         color: kBlack,
                      //       )),),
                      //       Icon(Icons.arrow_forward,color: kPrimaryOrange,)
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(color: Color(0xffDDDDDD)),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LinkUPI(phoneNumber:widget.phoneNumber)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('Link UPI ID',style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kBlack,
                            )),),
                            Icon(Icons.arrow_forward,color: kPrimaryOrange,)
                          ],
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 15),
                      //   child: Divider(color: Color(0xffDDDDDD)),
                      // ),
                      // GestureDetector(
                      //   onTap: (){
                      //     //Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text('History',style: GoogleFonts.montserrat(
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500,
                      //         color: kBlack,
                      //       )),
                      //       Icon(Icons.arrow_forward,color: kPrimaryOrange,)
                      //     ],
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(color: Color(0xffDDDDDD)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Referral(
                                    ref1: code,
                                  )));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Expanded(child:   Text('Referral',
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: kBlack,
                              )),),
                            Icon(
                              Icons.arrow_forward,
                              color: kPrimaryOrange,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(color: Color(0xffDDDDDD)),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('About',style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kBlack,
                            )),),

                            Icon(Icons.arrow_forward,color: kPrimaryOrange,)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Divider(color: Color(0xffDDDDDD)),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FAQ()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child:Text('FAQ',style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kBlack,
                            )),),
                            Icon(Icons.arrow_forward,color: kPrimaryOrange,)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Divider(color: Color(0xffDDDDDD)),
                      ),
                      GestureDetector(
                        onTap: ()async {
                          // SharedPreferences prefs = await SharedPreferences.getInstance();
                          // await  prefs.clear();

                          showDialog(context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Row(
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Warning!",
                                          style: GoogleFonts.montserrat(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: kBlack,
                                          )),
                                    ],
                                  ),
                                  content: Text("Are you sure, You wanna logout?",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: kTextColor[300]
                                    ),),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        RaisedButton(
                                          onPressed: ()async{
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            await  prefs.clear();
                                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()),ModalRoute.withName("/Home"));
                                          },
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(side: BorderSide(color: kPrimaryOrange), borderRadius: BorderRadius.all(Radius.circular(5))),
                                          child: Text(
                                            'Yes',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: kPrimaryOrange,
                                            ),
                                          ),
                                        ),
                                        RaisedButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          color: kPrimaryOrange.withOpacity(0.8),
                                          shape: RoundedRectangleBorder(side: BorderSide(color: kPrimaryOrange), borderRadius: BorderRadius.all(Radius.circular(5))),
                                          child: Text(
                                            'No',
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                  //descriptions: "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
                                  //text: "Yes",
                                );
                              }
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text('Logout',style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: kPrimaryOrange,
                              )),
                            ),

                          ],
                        ),
                      ),
                      // Divider(color: Colors.black26,thickness: 1,),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 0),
                      //   child: Divider(color: Color(0xffDDDDDD)),
                      // ),
                      // GestureDetector(
                      //   onTap: ()async {
                      //     await deleteAcc();
                      //     SharedPreferences prefs = await SharedPreferences.getInstance();
                      //     prefs.clear();
                      //
                      //    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Center(
                      //         child: Text('Delete My Account',style: GoogleFonts.montserrat(
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w500,
                      //           color: kPrimaryOrange,
                      //         )),
                      //       ),
                      //
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),


            ),
          ),
        )),);
  }
  // Future<bool> _onWillPop() async {
  //   Navigator.of(context).pop(false);
  //   Navigator.pushNamed(context, PageGuide().toString());
  // }
}

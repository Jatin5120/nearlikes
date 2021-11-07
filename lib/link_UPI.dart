

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:nearlikes/models/get_customer.dart';

import 'package:nearlikes/page_guide.dart';
import 'theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

String text;
Customer _getCustomer;
String customerId;
String phonenumber;
//RegExp upivalidate= new RegExp("/[a-zA-Z0-9_]{3,}@[a-zA-Z]{3,}/");


class LinkUPI extends StatefulWidget {
  final cashbackId;
  final phoneNumber;
  LinkUPI({this.phoneNumber,this.cashbackId});

  @override
  _LinkUPIState createState() => _LinkUPIState();
}


Future<Customer> getCustomerID({phone}) async {
  print("2222");
  final String apiUrl = "https://nearlikes.com/v1/api/client/own/fetch/phone";
  var body = {
    "phone": "${phone}"
  };
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  print("2222");
  print(response.statusCode);
  final String responseString = response.body.toString();

  print(responseString);
  _getCustomer = customerFromJson(responseString);
  print(_getCustomer.customer.upi);
  return _getCustomer;
}



Future<String> updateUPI({String id,String upi,String email}) async {
  print("1111");
  final String apiUrl = "https://nearlikes.com/v1/api/client/add/pay";
  var body = {
    "id": "$id",
    "upi": "$upi",
    "email": "$email"
  };
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  print("1111");
  print(response.statusCode);
  if(response.statusCode==200)
  {
    print("Updated");
    text="Successfully Updated!";
    return "Successfully Updated!";

  }
  else{
    text="The UPI provided is already linked with another NearLikes account, Please provide another UPI";
    return "The UPI provided is already linked with another NearLikes account, Please provide another UPI";
  }

  return null;
}

class _LinkUPIState extends State<LinkUPI> {
  String upierror='';
  bool UPI=false;
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String upi;
  String email;
  String error='';
  bool loading= false;

  Future<int> cashbackScratched(String couponId) async {
    if (couponId != null) {
      print('the customer id is $customerId');
      print("..8989..");
      print('the coupon id is $couponId');
      final String apiUrl =
          "https://nearlikes.com/v1/api/client/cashback/scratch/v2";
      var body = {"id": "$couponId", "phone": "+91$phonenumber"};
      //  var body = {
      //    "id": "$couponId",
      //    "ownerId": "$customerId"
      //  };
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
      return response.statusCode;
      // _getCustomer = customerFromJson(responseString);
      // print(";;;");
      // print(_getCustomer.customer.name);
      // return _getCustomer;
    }
  }
  // Future<String> cashbackScratched(String couponId) async {
  //  if(couponId!=null){
  //    print('the customer id is $customerId');
  //    print("..8989..");
  //    print('the coupon id is $couponId');
  //    final String apiUrl = "https://nearlikes.com/v1/api/client/cashback/scratch";
  //    var body = {
  //      "id": "$couponId",
  //      "ownerId": "$customerId"
  //    };
  //    final response = await http.post(
  //      Uri.parse(apiUrl),
  //      headers: {"Content-Type": "application/json"},
  //      body: json.encode(body),
  //    );
  //
  //    print(".....");
  //    print(response.statusCode);
  //    print('----');
  //    final String responseString = response.body.toString();
  //    print(']||/*/');
  //    print(responseString);
  //    print('232323');
  //    return responseString;
  //    // _getCustomer = customerFromJson(responseString);
  //    // print(";;;");
  //    // print(_getCustomer.customer.name);
  //    // return _getCustomer;
  //  }
  // }

  Future<Customer> getCustomer(String customerId) async {
    print(".....");
    print(customerId);
    final String apiUrl = "https://nearlikes.com/v1/api/client/own/fetch";
    var body = {
      "id" : "$customerId"
    };
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


    print(";;;");

    print(_getCustomer.customer.upi);
    if( _getCustomer.customer.upi!=null)
      {
        setState(() {
          loading=false;
           upierror='UPI ID already linked,\n To update contact Support Team';
           UPI=true;
        });
      }
    else setState(() {
      loading = false;
    });

    return _getCustomer;
  }
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
      customerId= test;
    });
    getCustomer(test);
    print('.,.111,.,.,$customerId');
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

   checkUpi(upi)async{
    print(upi);
    var body = {
      "vpa": "$upi"
    };
    final response = await http.post(
      Uri.parse('https://nearlikes.com/v1/api/client/vpa'),
      headers: {"content-type": "application/json",},
      body: json.encode(body),
    );
    print('UPI UPI');
    print(response.body);
    print(response.statusCode);
    var decoded= json.decode(response.body);

    var valid= decoded['valid'];
    print('090909 $valid');
    return valid;
  }

  @override
  void initState() {
    getUserData();
    loading=true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getCustomerID({phone})
    //getCustomerID(phone: "+917044065200");


    double height = MediaQuery.of(context).size.height;



    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Stack(
          children: [
            Padding(
              padding:EdgeInsets.symmetric(horizontal:40,vertical:  height*0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back,color: kPrimaryOrange,size: 30,)),
                  ),


                  SizedBox(height: 0,),
                  Image.asset('assets/logo.png',width:46.31,height:60.28),
                  SizedBox(height: height*0.025,),
                  Center(
                    child: Text("LINK UPI ID",style: GoogleFonts.montserrat(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: kFontColor,
                    ),),
                  ),
                  SizedBox(height: height*0.024,),
                  Center(
                    child: Text("You need to link your UPI for instant withdrawal of money.",style: GoogleFonts.montserrat(
                      fontSize:13,
                      fontWeight: FontWeight.w400,
                      color: kDarkGrey,
                    ),textAlign: TextAlign.center,),
                  ),
                  SizedBox(height: height*0.034,),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          height: height*0.08,
                          decoration: new BoxDecoration(
                            //color: kLightGrey,
                              border: Border.all(color: kLightGrey),
                              borderRadius: new BorderRadius.circular(
                                  15.0)),
                          child: TextFormField(
                            maxLines: 1,
                            onChanged: (value) {
                              upi = value;
                            },
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: kDarkGrey,
                                fontWeight: FontWeight.w700),
                            cursorColor: kPrimaryOrange,
                            //autofocus: true,
                            decoration: InputDecoration(
                              prefixStyle: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: kDarkGrey,
                                  fontWeight: FontWeight.w700),
                              isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                              prefixIcon: Icon(
                                Icons.person_outline_sharp,
                                color:kLightGrey,
                                size: 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              labelText: "UPI ID",
                              labelStyle: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: kLightGrey,
                                  fontWeight: FontWeight.w400),
                            ),
                            validator: (val)=>val.isEmpty?'The field cannot be empty':null,
                            onSaved: (val){
                              upi=val;
                            },
                          ),
                        ),

                        SizedBox(height: height*0.024,),
                        Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          height: height*0.08,
                          decoration: new BoxDecoration(
                            //color: kLightGrey,
                              border: Border.all(color: kLightGrey),
                              borderRadius: new BorderRadius.circular(
                                  15.0)),
                          child: TextFormField(
                            maxLines: 1,
                            onChanged: (value) {
                              email = value;
                            },
                            style: GoogleFonts.montserrat(
                                fontSize: 16,
                                color: kDarkGrey,
                                fontWeight: FontWeight.w700),
                            cursorColor: kPrimaryOrange,
                            //autofocus: true,
                            decoration: InputDecoration(
                              prefixStyle: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  color: kDarkGrey,
                                  fontWeight: FontWeight.w700),
                              isDense: true,
                              contentPadding:
                              EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                              prefixIcon: Icon(
                                Icons.mail_outline,
                                color:kLightGrey,
                                size: 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.transparent),
                              ),
                              labelText: "Email",
                              labelStyle: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: kLightGrey,
                                  fontWeight: FontWeight.w400),
                            ),
                            validator: (val)=>EmailValidator.validate(val)==false?'Enter valid email ID(check for unwanted spaces)':null,
                            onSaved: (val){
                              email=val;
                            },
                          ),
                        ),
                      ],
                    ),),

                  SizedBox(height: height*0.15,),
                  Text(error,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 15),),
                  // GestureDetector(
                  //   onTap: (){
                  //     Navigator.pop(context);
                  //   },
                  //   child: Text("Use Bank Details instead",style: GoogleFonts.montserrat(
                  //     decoration: TextDecoration.underline,
                  //     fontSize:13,
                  //     fontWeight: FontWeight.w400,
                  //     color: kPrimaryOrange,
                  //   ),textAlign: TextAlign.center,),
                  // ),
                  SizedBox(height: height*0.024,),
                  Text(upierror,style: GoogleFonts.montserrat(

                    fontSize:15,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryOrange,
                  ),textAlign: TextAlign.center,),
                  SizedBox(height: height*0.024,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: loading?Container(height: 0,):InkWell(
                      onTap: ()async{
                        //   print("the check ${widget.cashbackId}");
                        setState(() {loading=true;});
                        if(!UPI)
                        { if(_formKey.currentState.validate()){
                          var response=  await checkUpi(upi);
                          print('121212 $response');
                          if(response==true)
                          {
                            await updateUPI(upi: upi,email: email,id: "$customerId");
                            if(text=='Successfully Updated!')
                            {
                              int response =await cashbackScratched(widget.cashbackId);
                              // var snackBar = SnackBar(content: Text(text));
                              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              if(response==200){
                                setState(() {loading=false;error='';});
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
                              } else{
                                var snackBar = SnackBar(content: Text(text));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                setState(() {loading=false;error='';});
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PageGuide()));
                              }

                            }
                            else {
                              var snackBar = SnackBar(content: Text('some error occured, Try again!'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              setState(() {loading=false;error='';});
                            }
                          }
                          else setState(() {loading=false;error='Provide proper UPI ID';});

                        }}
                        else {
                          setState(() {loading=false;});
                          var snackBar1 = SnackBar(content: Text('UPI ID Already linked'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar1);
                        }
                        setState(() {loading=false;});

                      },

                      child: Container(
                          height: height*0.06,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  UPI?kLightGrey:kPrimaryPink,
                                  UPI?kLightGrey:kPrimaryOrange,
                                ],
                              )
                          ),
                          child: Center(
                            child:  Text('Add Account',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white,
                                  //letterSpacing: 1
                                )),
                          )),
                    ),
                  ),
                  //SizedBox(height: 20,),

                ],
              ),
            ),
            loading==true?Padding(
              padding:EdgeInsets.only(top: MediaQuery.of(context).size.height/2,),
              child: Center(
                child: CircularProgressIndicator(
                  //valueColor: Colors.black,
                  //Color: Colors.black,
                  backgroundColor: Colors.white,
                ),
              ),
            ):Container(height: 0,),
          ],
        ),
      )
    );
  }
  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearlikes/brand_stories.dart';
import 'package:nearlikes/login.dart';
import 'package:nearlikes/page_guide.dart';
import 'package:nearlikes/select_brand.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'models/get_campaigns.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

// String id;//owner id
// String brand;
// String campaign_id;
// bool value;

StreamController _selectBrand;

GetCampaigns _getCampaigns;

class SelectBrand extends StatefulWidget {
  final String id;//owner id
  final String brand;
  final String campaign_id;
  final bool value;



  SelectBrand({@required this.id,@required this.brand,@required this.campaign_id,this.value});

  @override
  _SelectBrandState createState() => _SelectBrandState();
}

Future<GetCampaigns> getAvailableCampaigns(
    {int followers, String location, int age}) async {
  print("data..");
  final String apiUrl = "https://nearlikes.com/v1/api/campaign/get/campaigns";
  var body = {"followers": followers, "location": "kolkata", "age": age};
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  print("data");
  print(response.statusCode);
  final String responseString = response.body.toString();

  print(responseString);
  _getCampaigns = getCampaignsFromJson(responseString);
  print('helllloooooo ${ _getCampaigns.campaigns.length.toString()}');
  return _getCampaigns;
}

loadBrands() async{
  getAvailableCampaigns(followers: 500, location: "kolkata", age: 40)
      .then((res) async {
    _selectBrand.add(res);
    return res;
  });
}

class _SelectBrandState extends State<SelectBrand> {


  @override
  void initState() {
    _selectBrand = new StreamController() ;
    loadBrands();
    getStatus();
    //get();
    super.initState();

  }

  getStatus()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phonenumber = prefs.getString('phonenumber');
    print('SelectBrand ---> This function to check user login status! $phonenumber');
    var body = {"phone": "${phonenumber}",};
    var checkuser= await http.post(Uri.parse('https://nearlikes.com/v1/api/client/check'),headers: {"Content-Type": "application/json"},
      body: json.encode(body),);
    print('===> ${checkuser.body}');
    if(checkuser.body=='2'){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await  prefs.clear();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()),ModalRoute.withName("/Home"));
    }

  }


  @override
  Widget build(BuildContext context) {
    return
      WillPopScope( onWillPop: (){
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => PageGuide()),ModalRoute.withName("/Home"));
      },
      child: Scaffold(
        // appBar: AppBar(
        //
        //   elevation: 0,
        //  backgroundColor: Colors.white,
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left:40,right:40,top: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.value==true? Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back,color: kPrimaryOrange,size: 30,)),
                ):Container(height: 0,),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: GestureDetector(
                //       onTap: (){
                //         Navigator.pop(context);
                //       },
                //       child: Icon(Icons.arrow_back,color: kPrimaryOrange,size: 30,)),
                // ),
                SizedBox(height: 0,),
                Image.asset('assets/logo.png',width:46.31,height:60),
                SizedBox(height: 25,),
                Center(
                  child: Text("SELECT A BRAND",style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kFontColor,
                  ),),
                ),
                SizedBox(height: 20,),
                StreamBuilder(
                  // future: getAvailableCampaigns(
                  //     followers: 500, location: "kolkata", age: 40),
                    stream: _selectBrand.stream,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        print(snapshot.data);
                        return Center(child: CircularProgressIndicator());
                      }
                      print(snapshot.data);
                      return _getCampaigns.campaigns.length == 0?Padding(
                          padding: EdgeInsets.only(top: 180),
                          child: Text(
                            'No Brands available at your location for now,\nThank you!',
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          )): Container(
                          child:  GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 3/ 4,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                              itemCount: _getCampaigns.campaigns.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>BrandStories(brand:_getCampaigns.campaigns[index].brand,id:_getCampaigns.campaigns[index].ownerId,campaignId:_getCampaigns.campaigns[index].id ,brandMoto: _getCampaigns.campaigns[index].text,brandTag: _getCampaigns.campaigns[index].username,)));
                                    },
                                    //child: Image.asset('assets/brands.png'));
                                    child: ShaderMask(
                                      shaderCallback: (bounds){
                                        return LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [Colors.transparent,Colors.black]
                                        ).createShader(bounds);
                                      },
                                      blendMode: BlendMode.color,
                                      child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                // image: AssetImage('assets/scratch_card.png'),
                                                  image: NetworkImage(
                                                      '${_getCampaigns.campaigns[index].logo}'
                                                  ),
                                                  fit: BoxFit.cover
                                              ),
                                              color: Color(0xffaaaaaa),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(5))),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration:BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.white.withOpacity(0.0),
                                                        Colors.black.withOpacity(0.9)
                                                      ],
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                    )
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top:8.0,bottom: 15),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        "${_getCampaigns.campaigns[index].brand}",
                                                        style: GoogleFonts.montserrat(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.white
                                                        ),),
                                                      SizedBox(height: 8,),
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
                                    ));
                              }));

                      //return Container();
                    }),
                // Container(
                //   height: 500,
                //   child:FutureBuilder(
                //       future: getAvailableCampaigns(
                //           followers: 500, location: "kolkata", age: 40),
                //       builder: (context, AsyncSnapshot snapshot) {
                //         if (!snapshot.hasData) {
                //           print(snapshot.data);
                //           return Center(child: CircularProgressIndicator());
                //         }
                //         print(snapshot.data);
                //         return Container(
                //             child:  GridView.builder(
                //                 gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                //                     maxCrossAxisExtent: 200,
                //                     childAspectRatio: 3/ 4,
                //                     crossAxisSpacing: 20,
                //                     mainAxisSpacing: 20),
                //                 itemCount: _getCampaigns.campaigns.length,
                //                 itemBuilder: (BuildContext ctx, index) {
                //                   return GestureDetector(
                //                       onTap: () {
                //                         Navigator.push(
                //                             context,
                //                             MaterialPageRoute(
                //                                 builder: (context) =>BrandStories(brand:_getCampaigns.campaigns[index].brand,id:_getCampaigns.campaigns[index].ownerId,campaign_id:_getCampaigns.campaigns[index].id ,)));
                //                       },
                //                       //child: Image.asset('assets/brands.png'));
                //                       child: ShaderMask(
                //                         shaderCallback: (bounds){
                //                           return LinearGradient(
                //                               begin: Alignment.topCenter,
                //                               end: Alignment.bottomCenter,
                //                               colors: [Colors.transparent,Colors.black]
                //                           ).createShader(bounds);
                //                         },
                //                         blendMode: BlendMode.color,
                //                         child: Container(
                //                             decoration: BoxDecoration(
                //                                 image: DecorationImage(
                //                                   // image: AssetImage('assets/scratch_card.png'),
                //                                     image: NetworkImage(
                //                                         '${_getCampaigns.campaigns[index].logo}'
                //                                     ),
                //                                     fit: BoxFit.cover
                //                                 ),
                //                                 color: Color(0xffaaaaaa),
                //                                 borderRadius:
                //                                 BorderRadius.all(Radius.circular(5))),
                //                             child: Stack(
                //                               children: [
                //                                 Container(
                //                                   decoration:BoxDecoration(
                //                                       gradient: LinearGradient(
                //                                         colors: [
                //                                           Colors.white.withOpacity(0.0),
                //                                           Colors.black.withOpacity(0.9)
                //                                         ],
                //                                         begin: Alignment.topCenter,
                //                                         end: Alignment.bottomCenter,
                //                                       )
                //                                   ),
                //                                 ),
                //                                 Center(
                //                                   child: Padding(
                //                                     padding: const EdgeInsets.only(top:8.0,bottom: 15),
                //                                     child: Column(
                //                                       mainAxisAlignment: MainAxisAlignment.end,
                //                                       children: [
                //                                         Text(
                //                                           "${_getCampaigns.campaigns[index].brand}",
                //                                           style: GoogleFonts.montserrat(
                //                                               fontSize: 16,
                //                                               fontWeight: FontWeight.w500,
                //                                               color: Colors.white
                //                                           ),),
                //                                         SizedBox(height: 8,),
                //                                         // Text(
                //                                         //   "${_getCampaigns.campaigns[index].text}",
                //                                         //   style: GoogleFonts.montserrat(
                //                                         //     fontSize: 14,
                //                                         //     fontWeight: FontWeight.w400,
                //                                         //     color: Colors.white,
                //                                         //   ),),
                //                                         // Text(
                //                                         //   "${readTimestamp(_getCampaigns.campaigns[index].start)}",style: GoogleFonts.montserrat(
                //                                         //     fontSize: 11,
                //                                         //     fontWeight: FontWeight.w500,
                //                                         //     color:Colors.white
                //                                         // ),),
                //                                         // Text(
                //                                         //   "to ${readTimestamp(_getCampaigns.campaigns[index].end)}",style: GoogleFonts.montserrat(
                //                                         //     fontSize: 11,
                //                                         //     fontWeight: FontWeight.w500,
                //                                         //     color: Colors.white
                //                                         // ),),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 ),
                //
                //                               ],
                //                             )),
                //                       ));
                //                 }));
                //
                //         //return Container();
                //       }),
                // ),

              ],
            ),
          ),
        ),
      ),
      );
  }
}

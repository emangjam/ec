import 'dart:convert';
import 'package:ec/fire_r.dart';
import 'package:ec/night_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
List posts=[];
var region;
var country;
var localtime;
var temp_c;
var stateWeather;
var wind_mph;
var cloud;
var humidity;
List disList = [
  {'dis': "الكاميرا", 'img': "assets/1.png"},
  {'dis': "الطقس", 'img': "assets/icon.png"},
  {'dis': "الحرائق", 'img': "assets/2.png"},
  {'dis': "الحرائط", 'img': "assets/oip.jpeg"},
  {'dis': " GPS", 'img': "assets/tl.webp"},
  {'dis': "الحساب", 'img': "assets/4.webp"},
];
// ----------------- varibol
String p = '';
bool stat = false;
  int selectedTab = 0; // 0: Rides, 1: Eats


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 176, 246),
      appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 6, 139, 197),

        title: Text("drone",style: TextStyle(color: Colors.white,fontSize: (30)),),

      ),
      drawer: Drawer(),
    
      // backgroundColor: Colors.white,
      body: SafeArea(
        
        child:  Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/5.jpg"),
                  fit: BoxFit.fill)
            // image: AssetImage("assets/backgraoundimg.jpg")
          ),
          child: Column(
            children: [
              // Container(
              //   child: Image.asset(
              //    // "assets/clear.png",
              //     fit: BoxFit.fill,
              //   ),
              //   // width: double.infinity,
              //   height: 250,
              //   // color: Color.fromARGB(255, 47, 255, 220),
              // ),
              SizedBox(
                height: 20,
              ),
//               Container(
//                 width: double.infinity,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: Color.fromARGB(134, 255, 255, 255),
//                   borderRadius: BorderRadius.all(Radius.circular(12)),
//                   // border: Border.all(
//                   //     color: Color.fromARGB(255, 15, 216, 193), width: 1)
//                 ),
              //   child: Text(
              //     "اختر من القائمة",
              //     style: TextStyle(
              //       fontSize: 26, color: Colors.black,
              //       // backgroundColor:Color.fromARGB(255, 163, 160, 160)
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
                 Expanded(
            child: GridView.builder(
              itemCount: disList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عدد الأعمدة
                crossAxisSpacing: 20, // مسافة أفقية بين العناصر
                mainAxisSpacing: 20,  // مسافة عمودية بين العناصر
              ),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      p = disList[i]['dis'];
                      cheack_disList(p);
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        disList[i]['img'],
                        width: 60, // حجم الأيقونة
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 8), // مسافة بين الصورة والنص
                      Text(
                        disList[i]['dis'],
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
          ),
        ),
      ),




        // Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     // الخريطة مع زر القائمة
        //   Container(
        //       margin: EdgeInsets.all(10),
        //          decoration: BoxDecoration(
        //            color: Color.fromARGB(255, 10, 75, 128),
        //
        //           borderRadius: BorderRadius.circular(22),
        //                 // border: Border.all(color: Colors.blue[300]!),
        //               ),
        //     child:Column(
        //       children: [
        //   SizedBox(height: 16),
        //     // رسالة ترحيب
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 24.0),
        //       child: Align(
        //         alignment: Alignment.centerLeft,
        //         child: Text(
        //           "$localtime",
        //           style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold),
        //         ),
        //       ),
        //     ),
        //     SizedBox(height: 12),
        //     // مربع البحث
        //     Column(
        //       children: [
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //              Icon(Icons.sunny,color: Colors.yellow,size: 60,),
        //             Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(12),
        //                 // border: Border.all(color: Colors.blue[300]!),
        //               ),
        //               child:Column(
        //                 children: [
        //                   Text("$temp_c",style: TextStyle(fontSize: 67,fontWeight: FontWeight.bold,color: Colors.white),),
        //                    Text("$stateWeather",style: TextStyle(fontSize: 23,color: Colors.white),),
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //     //SizedBox(height: 8),
        //     // Container(
        //     //   // color: const Color.fromARGB(255, 14, 96, 164),
        //     //   child: Row(mainAxisAlignment: MainAxisAlignment.center,
        //     //     children: [
        //     //     Card(color: const Color.fromARGB(255, 8, 52, 88),child: Text("العظمى:28ه",style: TextStyle(fontSize: 20, color: Colors.white,),),),Card(color: const Color.fromARGB(255, 8, 52, 88),child: Text("الصغرى:18ه",style: TextStyle(fontSize: 20, color: Colors.white,)),)
        //     //   ],),
        //     // ),
        //       SizedBox(height: 8),
        //
        //       Container(
        //         margin: EdgeInsets.all(10),
        //          decoration: BoxDecoration(
        //            color: const Color.fromARGB(255, 8, 52, 88),
        //
        //           borderRadius: BorderRadius.circular(22),
        //                 // border: Border.all(color: Colors.blue[300]!),
        //               ),
        //         height: 90,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //
        //
        //         children: [
        //         Text("$wind_mph |",style: TextStyle(fontSize: 20,color: Colors.white)),
        //         SizedBox(width: 15,),
        //                         Text("سرعة الرياح |",style: TextStyle(fontSize: 20, color: Colors.white,)),
        //                                         SizedBox(width: 15,),
        //
        //         // Text("24%",style: TextStyle(fontSize: 20, color: Colors.white,))
        //
        //       ],),
        //     ),
        //   ],) ,),
        //   Row(
        //      mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //
        //     Container(
        //        margin: EdgeInsets.all(10),
        //              decoration: BoxDecoration(
        //            color: Color.fromARGB(255, 52, 156, 241),
        //
        //               borderRadius: BorderRadius.circular(22),
        //                     // border: Border.all(color: Colors.blue[300]!),
        //                   ),
        //                   height: 70,
        //                  // width:50,
        //       child: Column(
        //         children: [
        //           Text("نسبة الغيوم",style: TextStyle(color: Colors.white),),
        //           Icon(Icons.cloud,color: Colors.white,),
        //           // Image.asset("images/cloud.png",width: 40,height: 50,),
        //                     Text("$cloud%",style: TextStyle(color: Colors.white))
        //         ],
        //       ),
        //     ),
        //      Container(
        //        margin: EdgeInsets.all(10),
        //              decoration: BoxDecoration(
        //            color: Color.fromARGB(255, 52, 156, 241),
        //
        //               borderRadius: BorderRadius.circular(22),
        //                     // border: Border.all(color: Colors.blue[300]!),
        //                   ),
        //                   height: 70,
        //                  // width:50,
        //       child: Column(
        //         children: [
        //           Text("نسبة الرطوبة",style: TextStyle(color: Colors.white),),
        //           Icon(Icons.cloud,color: Colors.white,),
        //           // Image.asset("images/cloud.png",width: 40,height: 50,),
        //                     Text("$humidity%",style: TextStyle(color: Colors.white))
        //         ],
        //       ),
        //     ),
        //
        //
        //
        //   ],),
        //   Container(
        //        margin: EdgeInsets.all(10),
        //          decoration: BoxDecoration(
        //            color: Colors.white,
        //
        //           borderRadius: BorderRadius.circular(22),
        //                 // border: Border.all(color: Colors.blue[300]!),
        //               ),
        //               //height: 70,
        //               width: double.infinity,
        //     child: Column(
        //     children: [
        //       Icon(Icons.sunny),
        //       Text("$country- درجة الحرارة",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.black),)
        //     ],
        //   ),),
        //
        //
        //   ],
        // ),
        //
      // ),
      // شريط سفلي

      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {

          } else if (index == 1) {
             Navigator.of(context)
                 .pushReplacement(MaterialPageRoute(builder: (con) => weatherscreen()));
          }
          else if (index == 2) {
            showDialog(
                context: context,
                builder: (con) {
                  return AlertDialog(
                    content: Text(
                      " هل تريد الخروج من التطبيق؟",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 20),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "لا",
                          style: TextStyle(fontSize: 19),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 22, 193, 205),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                        child: Text(
                          "نعم",
                          style: TextStyle(fontSize: 19),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromARGB(255, 22, 193, 205),
                        ),
                      ),
                    ],

                    //  children: [Container(child: Text('ok'),),Container(child: Text('no'),)],
                  );
                });
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.phone,
                color: Color.fromARGB(255, 22, 193, 205),
              ),
              label: 'الهاتف'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Color.fromARGB(255, 22, 193, 205),
              ),
              label: 'الرئيسية'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.exit_to_app,
                color: Color.fromARGB(255, 22, 193, 205),
              ),
              label: 'خروج')
        ],
      ),

    );
  }

  void cheack_disList(String dis) async {
    String name = dis;
    print(name);
    if (name == "الكاميرا") {
      // print("$dis ----------");

    } else if (name == "الطقس") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (c) =>weatherscreen())
      );

      // print("غير متوفر");
    } else if (name == "الحرائق") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (c) => FireAlarm()));
    } else if (name == "الخرائط") {


      //print("غير متوفر");
    } else if (name == "GPS") {

    } else if (name == "الحساب") {

    }
  }
}


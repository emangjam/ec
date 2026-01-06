import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ec/service/api.dart';
import 'package:ec/service/weather_db.dart';

class weatherscreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _weatherscreen();
}

class _weatherscreen extends State<weatherscreen> {
  weather sql = new weather();
  Api api = Api();
  List posts = [];

  // تهيئة المتغيرات بقيم افتراضية
  var region = 'ليبيا';
  var country = '';
  var localtime = 'جاري التحميل...';
  var temp_c = '--';
  var stateWeather = 'جاري التحميل...';
  var wind_mph = '--';
  var cloud = '--';
  var humidity = '--';

  bool _isConnected = true;
  bool _isLoading = true;

  Future<void> _checkInternet() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      setState(() {
        _isConnected = response.statusCode == 200;
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  Future<void> read_data_weather() async {
    try {
      api.getdata();
      List<Map> res = await sql.read_wheather(
          "select temperature_c,condition_text,humidity,wind_kph,pressure_mb,datetime from CurrentWeather order by id desc limit 1");

      if (res.isEmpty) {
        print('is empty - setting default values');
        // تعيين قيم افتراضية إذا كانت البيانات فارغة
        setState(() {
          temp_c = '--';
          stateWeather = 'لا توجد بيانات';
          humidity = '--';
          wind_mph = '--';
          cloud = '--';
          localtime = 'لا توجد بيانات';
          _isLoading = false;
        });
      } else {
        print('is not empty');
        // تحويل القيم إلى String مع استخدام قيم افتراضية إذا كانت null
        setState(() {
          temp_c = res[0]['temperature_c']?.toString() ?? '--';
          stateWeather = res[0]['condition_text']?.toString() ?? 'غير معروف';
          humidity = res[0]['humidity']?.toString() ?? '--';
          wind_mph = res[0]['wind_kph']?.toString() ?? '--';
          cloud = res[0]['pressure_mb']?.toString() ?? '--';
          localtime = res[0]['datetime']?.toString() ?? '--';
          _isLoading = false;
        });
        print(temp_c);
      }
    } catch (e) {
      print('Error reading weather data: $e');
      // في حالة حدوث خطأ، ضع قيم افتراضية
      setState(() {
        temp_c = '--';
        stateWeather = 'خطأ في التحميل';
        humidity = '--';
        wind_mph = '--';
        cloud = '--';
        localtime = 'خطأ';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await read_data_weather();
  }

  @override
  Widget build(BuildContext context) {
    // التحقق من أن localtime ليست null قبل استخدامها
    String displayLocaltime = localtime ?? 'لا توجد بيانات';

    TextEditingController date_controller = TextEditingController();
    date_controller.text = displayLocaltime;

    // إذا كان التطبيق لا يزال يحمل البيانات، عرض مؤشر تحميل
    if (_isLoading) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/backgraoundimg.jpg"),
                  fit: BoxFit.fill
              )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 20),
                Text(
                  "جاري تحميل بيانات الطقس...",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/day.jpg"),
                fit: BoxFit.fill
            )
        ),
        child: Column(
          children: [
            SizedBox(height: 60),
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new, size: 30),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                textAlign: TextAlign.center,
                controller: date_controller,
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(134, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  hintText: 'لا توجد بيانات',
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              region, // ليبيا
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),
            ),
            Text(
              "حالة الجو: ${stateWeather ?? 'غير متوفر'}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            Container(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    temp_c ?? '--',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 90,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  // Positioned(
                  //   top: -30,
                  //   child: Image.asset(
                  //     "assets/light_cloud.png",
                  //     width: 150,
                  //     height: 150,
                  //   ),
                  // ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 3, color: Colors.white)
                      ),
                      child: Icon(
                        Icons.chalet_rounded,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                    Text(
                      "الرطوبة",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    Text(
                      "${humidity ?? '--'}%",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 3, color: Colors.white)
                      ),
                      child: Icon(
                        Icons.cloud_sharp,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                    Text(
                      "الغيوم",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    Text(
                      "${cloud ?? '--'}%",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 3, color: Colors.white)
                      ),
                      child: Icon(
                        Icons.storm_sharp,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                    Text(
                      "الرياح",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    Text(
                      "${wind_mph ?? '--'}%",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 3, color: Colors.white)
                      ),
                      child: Icon(
                        Icons.back_hand_rounded,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                    Text(
                      "المحسوسة",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    Text(
                      "${temp_c ?? '--'}%",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await _checkInternet();
                print(_isConnected);

                if (_isConnected) {
                  setState(() {
                    _isLoading = true;
                  });

                 setState(() {
                    read_data_weather();
                 });

                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(
                            "تم التحديث بنجاح",
                            textDirection: TextDirection.rtl,
                          ),
                        );
                      }
                  );
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.info, color: Colors.amber),
                              SizedBox(width: 10),
                              Text(
                                "تنبيه",
                                style: TextStyle(color: Colors.black, fontSize: 24),
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                          content: Text(
                            "تحقق من الاتصال بالإنترنت",
                            textDirection: TextDirection.rtl,
                          ),
                        );
                      }
                  );
                }
              },
              child: Text(
                "تحديث",
                style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                elevation: 10,
                backgroundColor: Colors.purpleAccent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
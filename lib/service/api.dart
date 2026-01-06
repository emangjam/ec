import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ec/service/weather_db.dart';
import 'package:ec/service/weather_db.dart';

class Api{
  weather sql = new weather();
    Future getdata() async {
    var respons = await http.get(Uri.parse(
        "https://api.weatherapi.com/v1/current.json?key=80ee18d8305948c8aa6180529252011&q=Libya&aqi=no"));
    var responsbody = jsonDecode(respons.body);

    try {
    
      int res = await sql.insert_wheather(
          """insert into CurrentWeather(temperature_c,condition_text,humidity,wind_kph,pressure_mb,datetime)
      values('${responsbody["current"]["temp_c"].toString()}','${responsbody['current']['condition']['text']}','${responsbody['current']['humidity'].toString()}','${responsbody["current"]["wind_mph"].toString()}','${responsbody['current']['cloud'].toString()}','${responsbody['location']['localtime']}')""");
      print(res);
      print("********** succeefuly insert ***********");
    } catch (e) {
      print("$e");
    }
  }
}
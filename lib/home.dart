import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/cityPage.dart';
import 'package:weather_app/data.dart';
import 'package:weather_app/search.dart';
import 'data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController cityName = new TextEditingController();

  late Position _currentPosition;
  var _currentAddress;
  late String lat;
  late String long;

  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var name;
  var icon;
  // String cityval = 'Nashik';

  _getCurrentLocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      setState(() {
        //_currentPosition = position;
        lat = position.latitude.toString();
        long = position.longitude.toString();
      });
      //PLEASE USE WEATHER API FROM https://openweathermap.org/api
      http.Response response = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${long}&units=metric&appid="ENTER_YOUR_APIKEY""));
      var results = jsonDecode(response.body);

      setState(() {
        this.temp = results['main']['temp'];
        this.description = results['weather'][0]['description'];
        this.currently = results['weather'][0]['main'];
        this.humidity = results['main']['humidity'];
        this.windSpeed = results['wind']['speed'];
        this.name = results['name'];
        this.icon = results['weather'][0]['main'];
      });
      print(lat);
    }).catchError((e) {
      print(e);
    });
  }
  // Future getWeather() async {
  //   http.Response response = await http.get(Uri.parse(
  //       'https://api.openweathermap.org/data/2.5/weather?q=$cityval&units=metric&appid=96c36b136a3f753d1d3c409f38e33ae1'));
  //   var result = jsonDecode(response.body);
  //   setState(() {
  //     this.temp = result['main']['temp'];
  //     this.description = result['weather'][0]['description'];
  //     this.currently = result['weather'][0]['main'];
  //     this.humidity = result['main']['humidity'];
  //     this.windSpeed = result['wind']['speed'];
  //     this.name = result['name'];
  //     this.icon = result['weather'][0]['main'];
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.getWeather();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      if ((currently.toString()) == "Wind" ||
          (currently.toString()) == "Clouds") {
        return Color(0xFF71f2eb);
      } else if ((currently.toString()) == "Rain") {
        return Color(0xFF5ad3fc);
      } else if ((currently.toString()) == "Sun") {
        return Color(0xFFfec48f);
      }else if ((currently.toString()) == "Clear") {
        return Color(0xffc1a964);
      } else if ((currently.toString()) == "Wind") {
        return Color(0xff7ee7fa);
      }else if ((currently.toString()) == "Haze") {
        return Color(0xff92999c);
      }else {
        return Color(0xFFc1f2f5);
      }
    }
    // cityName == "" ? cityval : cityName;
    // print(cityName.text);

    return SafeArea(
      child: Scaffold(
        backgroundColor: getColor(),
        appBar: AppBar(
          backgroundColor: getColor(),
          elevation: 0,
          title: Center(child: Text("Weather App")),
        ),
        body: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            child: Icon(Icons.search),
                            margin: EdgeInsets.fromLTRB(2, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          controller: cityName,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter City Name"),
                          onEditingComplete: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CityPage(text: cityName.text,)),
                            );
                            // cityName.clear();
                          },
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              color: getColor(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 170,
                    child: Image.asset('images/$icon.png'),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: getColor().withGreen(150),
                          blurRadius: 50.0, // soften the shadow
                          spreadRadius: 7.0, //extend the shadow
                          offset: Offset(
                            15.0, // Move to right 10  horizontally
                            15.0,
                          ))
                    ]),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      name != null
                          ? "Currently in " + name.toString()
                          : "Loading...",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    temp != null ? temp.toString() + "\u00B0" : "Loading...",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      currently != null ? currently.toString() : "Loading...",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.thermometer),
                        title: Text("Temperature"),
                        trailing: Text(temp != null
                            ? temp.toString() + "\u00B0"
                            : "Loading..."),
                        tileColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white30),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      Divider(
                        height: 4,
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.cloud),
                        title: Text("Weather"),
                        trailing: Text(description != null
                            ? description.toString()
                            : "Loading..."),
                        tileColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white30),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      Divider(
                        height: 4,
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.sun),
                        title: Text("Humidity"),
                        trailing: Text(humidity != null
                            ? humidity.toString()
                            : "Loading..."),
                        tileColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white30),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      Divider(
                        height: 4,
                      ),
                      ListTile(
                        leading: FaIcon(FontAwesomeIcons.wind),
                        title: Text("Wind Speed"),
                        trailing: Text(windSpeed != null
                            ? windSpeed.toString()
                            : "Loading..."),
                        tileColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white30),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

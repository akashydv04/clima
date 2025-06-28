import 'dart:convert';

import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:clima/screens/screen2.dart';
import 'package:clima/util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../services/location.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  var cityName = "Delhi";
  var searchCityName = "Delhi";
  var temperature = 30.05;
  var apiKey = "796c98215062c6848b9af748e5fa0d23";
  var weather = "Sunny";
  var weatherId = 220;
  var icon = "images/cloudy_sun.png";
  var isLoading = true;

  void getLocation() async {
    bool isConnected = await isInternetAvailable();
    if (isConnected) {
      isLoading = true;
      Location location = Location();
      await location.getCurrentLocation();
      if (kDebugMode) {
        print(location.latitude);
      }
      var url = Uri.https('api.openweathermap.org', '/data/2.5/weather', {
        'lat': '${location.latitude}',
        'lon': '${location.longitude}',
        'appid': apiKey
      });
      var response = await http.get(url);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      final Map<String, dynamic> data = jsonDecode(response.body);
      getTempInCelsius(data['main']['temp']);
      setState(() {
        cityName = "${data['name']}";
        weather = "${data['weather'][0]['main']}";
        weatherId = data['weather'][0]['id'];
        icon = getWeatherIcon(weatherId);
        isLoading = false;
      });

      showToast("Location: ${location.latitude}");
    } else {
      showToast("No Internet Connection");
    }
  }

  void getLocationFromCityName() async {
    bool isConnected = await isInternetAvailable();
    if (isConnected) {
      isLoading = true;
      var url = Uri.https('api.openweathermap.org', '/data/2.5/weather',
          {'q': searchCityName, 'appid': apiKey});
      var response = await http.get(url);
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['cod'] != '200' && data['message'] != null) {
        showToast(data['message']);
      }
      getTempInCelsius(data['main']['temp']);
      setState(() {
        cityName = "${data['name']}";
        weather = "${data['weather'][0]['main']}";
        weatherId = data['weather'][0]['id'];
        icon = getWeatherIcon(weatherId);
        isLoading = false;
      });
    } else {
      showToast("No Internet Connection");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
      gravity: ToastGravity.BOTTOM, // TOP, CENTER, BOTTOM
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void getTempInCelsius(var temperatureInKelvin) {
    setState(() {
      temperature = (temperatureInKelvin - 273.15).roundToDouble();
    });
  }

  @override
  void initState() {
    if (mounted) {
      getLocation();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      blurEffectIntensity: 4,
      progressIndicator: SpinKitFadingCircle(
        color: Colors.purple[800],
        size: 90.0,
      ),
      dismissible: false,
      opacity: 0.4,
      color: Colors.black87,
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/screen1.jpeg"), fit: BoxFit.fill)),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          getLocation();
                        },
                        icon: Icon(CupertinoIcons.location_fill),
                        color: Colors.white),
                    IconButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Screen2()));

                          if (result != null) {
                            searchCityName = result;
                            getLocationFromCityName();
                          }
                        },
                        icon: Icon(CupertinoIcons.location_solid),
                        color: Colors.white)
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(cityName,
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                Center(
                  child: Text("$temperature°C",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage(icon), width: 50, height: 50),
                    Text(weather,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getWeatherIcon(int weatherId) {
    if (weatherId >= 200 && weatherId <= 232) {
      return "images/thunderstorm.png";
    } else if (weatherId >= 300 && weatherId <= 321) {
      return "images/drizzle.png";
    } else if (weatherId >= 500 && weatherId <= 531) {
      return "images/rain.png";
    } else if (weatherId >= 600 && weatherId <= 622) {
      return "images/snow.png";
    } else if (weatherId >= 701 && weatherId <= 781) {
      return "images/atmosphere.png";
    } else if (weatherId == 800) {
      return "images/clear.png";
    } else if (weatherId >= 801 && weatherId <= 804) {
      return "images/cloudy.png";
    } else {
      return "images/cloudy_sun.png";
    }
  }
}

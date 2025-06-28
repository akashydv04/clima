import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  var cityName = "";
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("images/screen2.jpeg"))),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(5),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: TextEditingController(
                    text: cityName,
                  ),
                  onChanged: (value) => {cityName = value},
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'City name',
                    hintText: 'Enter city name',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, cityName);
                },
                child: Text("Search"))
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'constraints.dart'as k;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isLoaded=false;
  num? temp;
  num? pressure;
  num? humidity;
  num? cover;

String cityname='';
//TextEditingController controller =TextEditingController();

@override
  void initState(){
  super.initState();
  getCurrentLocation();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/nature weather image.webp'),
                fit: BoxFit.cover)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                cityname,
                style: const TextStyle(fontSize: 30,color: Colors.black),
              ),
              const Text(
                'Monday',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 65,
              ),
              Center(
                child: Text(
                  '${temp?.toStringAsFixed(1)}°C',
                  style: const TextStyle(fontSize: 60),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 300.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.cloud,
                      color: Colors.blue,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Humidity: $humidity%',
                      style: const TextStyle(fontSize: 20,color: Colors.white),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.cloud,
                    color: Colors.blue,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Pressure: $pressure hPa',
                    style: const TextStyle(fontSize: 20,color: Colors.white),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  getCurrentLocation()async{
    var position=await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
      forceAndroidLocationManager: true,
    );
    if(position!=null){
      print('lat:${position.latitude},long:${position.longitude}');
      getCurrentCityWeather(position);

    }else{
      print('Data unavailable');
    }
  }


  getCurrentCityWeather(Position pos)async{
    var url='${k.domain}lat=${pos.latitude}&lon=${pos.longitude}&appid=${k.apiKey}';
   // var uri=Uri.parse(url);
    var response=await http.get(Uri.parse(url));
    if(response.statusCode==200){
      var data =response.body;
      var decodeData=jsonDecode(data);
      print(data);
      updateUI(decodeData);
      setState(() {
        isLoaded=true;
      });
    }else{
      print(response.statusCode);
    }
  }

  updateUI(var decodeData){
    setState(() {
      if(decodeData==null){
        temp=0;
        pressure=0;
        humidity=0;
        cover=0;
        cityname='Not available';
      }else{
        temp=decodeData['main']['temp']-273;
        pressure=decodeData['main']['pressure'];
        humidity=decodeData['main']['humidity'];
        cover=decodeData['clouds']['all'];
        cityname=decodeData['name'];

      }
    });
  }

//   getCityWeather(String cityname)async{
//     var client = http.Client();
//     var uri = '${k.domain}q=$cityname&appid=${k.apiKey}';
//     var url = Uri.parse(uri);
//     var response = await client.get(url);
//     if(response.statusCode == 200){
//       var data = response.body;
//       var decodedData = jsonDecode(data);
//       print(data);
//       updateUI(decodedData);
//
//       setState(() {
//         isLoaded=true;
//       });
//     }else{
//       print(response.statusCode);
//     }
//   }
//   void dispose(){
//     //TODO: implement dispose
//     controller.dispose();
//     super.dispose();
//   }
}

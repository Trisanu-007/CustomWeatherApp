import 'package:flutter/material.dart';
import 'package:weather_app/apiKey.dart';
import 'package:weather_app/shared_resouces/custom_weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomWeather extends StatelessWidget {
  final Weather weather;
  CustomWeather({this.weather});
  final String tempkey =apiKey;

  Future<CurrentWeather> getWeatherDetails() async {

    http.Response response = await http.get(
      Uri.encodeFull("https://api.openweathermap.org/data/2.5/weather?q=${weather.city}," +  "&appid=" + tempkey + "&units=metric" ),
    );
    var parsedJson = json.decode(response.body);
    print(parsedJson);
    if(parsedJson["cod"] == 200) {
      return CurrentWeather(
        weather_main: parsedJson["weather"][0]["main"],
        weather_description: parsedJson["weather"][0]["description"],
        icon_url: "http://openweathermap.org/img/wn/" +
            parsedJson["weather"][0]["icon"] + "@2x.png",
        temp: parsedJson["main"]["temp"],
        feels_like: parsedJson["main"]["feels_like"],
        temp_min: parsedJson["main"]["temp_min"],
        temp_max: parsedJson["main"]["temp_max"],
        pressure: parsedJson["main"]["pressure"],
        humidity: parsedJson["main"]["humidity"],
        wind_speed: parsedJson["wind"]["speed"],
        cod: parsedJson["cod"],
      );
    }
    if(parsedJson["cod"] != 200){
      return CurrentWeather(
        cod: parsedJson["cod"],
        error_message: parsedJson["message"],
      );
    }
  }

  Widget _newScaffold(AsyncSnapshot<CurrentWeather> snapshot){
    return new Scaffold(
      appBar:AppBar(
        title: Text("${weather.city},${weather.state}",
          style:TextStyle(
            fontSize: 30.0,
          ), ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("${snapshot.data.icon_url}"),
                  radius: 30.0,
                ),
                contentPadding: EdgeInsets.all(20.0),
                title: Text("Weather Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Text("Main Details: ",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${snapshot.data.weather_main} on the mind"),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Secondary Details: ",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${snapshot.data.weather_description}"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("https://static.bhphotovideo.com/explora/sites/default/files/styles/top_shot/public/Color-Temperature.jpg?itok=yHYqoXAf"),
                  radius: 30.0,
                ),
                contentPadding: EdgeInsets.all(20.0),
                title: Text("Temperature Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Text("Real-Time: ",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${snapshot.data.temp}°C"),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Feels Like: ",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${snapshot.data.feels_like}°C"),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Max Temperature: ",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${snapshot.data.temp_max}°C"),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Min temperature: ",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${snapshot.data.temp_min}°C"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-QjX7oadAU5LX8eCN_vO4Fsk0lO1nB1kg4g&usqp=CAU"),
                  radius: 30.0,
                ),
                contentPadding: EdgeInsets.all(20.0),
                title: Text("Pressure, Humidity and Wind Speed",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Text("Pressure: ",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${snapshot.data.pressure} Pa"),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Humidity: ",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${snapshot.data.humidity}"),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Wind Speed: ",style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("${snapshot.data.wind_speed} m/s"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorPage(AsyncSnapshot<CurrentWeather> snapshot){
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.red,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 0.0,
      ),
      body: Center(
        child: Container(
          color: Colors.red,
          child:Center(
            child: Column(
              children: [
                SizedBox(height: 200.0,),
                  Container(
                    child: Text(
                      "${snapshot.data.cod}",
                      style: TextStyle(
                        fontSize: 50.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(height: 20.0,),
                Container(
                  color: Colors.white,
                  child: Text(
                    "${snapshot.data.error_message.toUpperCase()}",
                    style:TextStyle(
                    fontSize: 30.0,
                    color: Colors.red,
                  ),
                 ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getWeatherDetails(),
        builder: (context, AsyncSnapshot<CurrentWeather> snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data.cod == 200)
              return _newScaffold(snapshot);
            else
              return _errorPage(snapshot);
          }else{
            return Container(
              color: Colors.blue,
                child: Center(child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),),
            );
          }
        }
    );
  }
}

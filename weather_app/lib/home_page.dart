import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/shared_resouces/authentication.dart';
import 'package:weather_app/shared_resouces/custom_weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'apiKey.dart';
import 'find_location.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _latitude;
  var _longitude;
  final String tempkey = apiKey;
  final Authenticate authenticate = Authenticate();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  CurrentWeather _currentWeather;
  LoadStatus mode;
  Widget _loading =
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.blue,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );

  Future<CurrentWeather> getWeatherDetails() async {
    if(_longitude!=null &&_latitude!=null) {
      http.Response response = await http.get(
        Uri.encodeFull("https://api.openweathermap.org/data/2.5/weather?lat=$_latitude&lon=$_longitude&appid=$tempkey" + "&units=metric" ),
      );
      var parsedJson = json.decode(response.body);
      print(parsedJson);
      print(parsedJson["weather"][0]["main"].trim());
      if (parsedJson["cod"] == 200) {
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
          name: parsedJson["name"],
        );
      }
      if (parsedJson["cod"] != 200) {
        return CurrentWeather(
          cod: parsedJson["cod"],
          error_message: parsedJson["message"],
        );
      }
    }
    else
      return null;
  }

  Future _getCurrentPosition() async {
    final position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
    print(_latitude);
    print(_longitude);
  }

  void _onRefresh() async {
      await Future.delayed(Duration(seconds: 5)).then((_) {
        setState(() {
          _loading = Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: SmartRefresher(
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              header: WaterDropMaterialHeader(),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 100.0),
                child: Column(
                  children: [
                    Center(child: Icon(Icons.signal_wifi_off, color: Colors.red,
                      size: 40.0,)),
                    SizedBox(height: 20.0,),
                    Center(child: Text("Something went wrong, please try later",
                      style: TextStyle(color: Colors.grey),)),
                  ],
                ),
              ),
            ),
          );
        });
      });
    await _getCurrentPosition();
    CurrentWeather _now;
    _now = await getWeatherDetails();
    setState(() {
      _currentWeather = _now;
    });
    _refreshController.refreshCompleted();
    }


  void _onLoading() async {
    await Future.delayed(Duration(seconds: 5)).then((_){
      setState(() {
        _loading = Scaffold(
          appBar:AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: SmartRefresher(
            enablePullDown: true,
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            //header: WaterDropMaterialHeader(),
            header: WaterDropMaterialHeader(),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 100.0),
              child: Column(
                children: [
                  Center(child: Icon(Icons.signal_wifi_off,color: Colors.red,size: 40.0,)),
                  SizedBox(height: 20.0,),
                  Center(child: Text("Something went wrong, please try later",style: TextStyle(color: Colors.grey),)),
                ],
              ),
            ),
          ),
        );
      });
    });
    _currentWeather = await getWeatherDetails();
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  Widget _card1(CurrentWeather _currentWeather){
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage("${_currentWeather.icon_url}"),
            radius: 30.0,
          ),
          contentPadding: EdgeInsets.all(20.0),
          title: Text("Weather Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Text("Main Details: ",style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("${_currentWeather.weather_main} on the mind"),
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Text("Secondary Details: ",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("${_currentWeather.weather_description}"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _card2(CurrentWeather _currentWeather){
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage("https://static.bhphotovideo.com/explora/sites/default/files/styles/top_shot/public/Color-Temperature.jpg?itok=yHYqoXAf"),
            radius: 30.0,
          ),
          contentPadding: EdgeInsets.all(20.0),
          title: Text("Temperature Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Text("Real-Time: ",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("${_currentWeather.temp}°C"),
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Text("Feels Like: ",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("${_currentWeather.feels_like}°C"),
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Text("Max Temperature: ",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("${_currentWeather.temp_max}°C"),
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  Text("Min temperature: ",style: TextStyle(fontWeight: FontWeight.bold),),
                  Text("${_currentWeather.temp_min}°C"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card3(CurrentWeather _currentWeather){
  return Container(
    margin: EdgeInsets.all(10.0),
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ-QjX7oadAU5LX8eCN_vO4Fsk0lO1nB1kg4g&usqp=CAU"),
          radius: 30.0,
        ),
        contentPadding: EdgeInsets.all(20.0),
        title: Text("Pressure, Humidity and Wind Speed",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              direction: Axis.horizontal,
              children: [
                Text("Pressure: ",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("${_currentWeather.pressure} Pa"),
              ],
            ),
            Wrap(
              direction: Axis.horizontal,
              children: [
                Text("Humidity: ",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("${_currentWeather.humidity}"),
              ],
            ),
            Wrap(
              direction: Axis.horizontal,
              children: [
                Text("Wind Speed: ",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("${_currentWeather.wind_speed} m/s"),
              ],
            ),
          ],
        ),
      ),
    ),
   );
  }

  Widget _drawer(BuildContext context){
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
              child: Text("Hi",style: TextStyle(color: Colors.white,fontSize: 40.0),),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),),
          ListTile(
            title: Text("Check out details of your favourite place"),
            trailing: Icon(Icons.navigate_next) ,
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FillData()));
            },
          ),
          ListTile(
            title: Text("Sign Out"),
            trailing: Icon(Icons.keyboard_tab),
            onTap: () async{
              await authenticate.signOut();
            },
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return _currentWeather == null? _loading: MaterialApp(
      title: "Home Page",
      home: Scaffold(
        drawer: _drawer(context),
//        appBar: AppBar(
//          backgroundColor: Colors.white,
//          elevation: 0.0,
//          iconTheme: IconThemeData(color: Colors.blue),
//        ),
        body: Container(
          color: Colors.blue,
          child: SmartRefresher(
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
                header: WaterDropMaterialHeader(),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      expandedHeight: 300,
                      flexibleSpace: FlexibleSpaceBar(
                          title: Text("${_currentWeather.name}",style: TextStyle(color: Colors.white,fontSize: 30.0),),
                          centerTitle: true,
                        background: Image(
                          image: AssetImage("${icon_urls["${_currentWeather.weather_main.trimLeft()}"]}") ?? AssetImage("assets/default.jpg"),
                          fit: BoxFit.cover,
                        ),),
                   shape: ContinuousRectangleBorder(
                     borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100))),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          _card1(_currentWeather),
                          _card2(_currentWeather),
                          _card3(_currentWeather),
                        ]
                      ),
                    ),
                  ],
                ),
            ),
        ),
      ),
    );
  }
}

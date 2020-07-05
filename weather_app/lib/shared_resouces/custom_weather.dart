import 'package:pull_to_refresh/pull_to_refresh.dart';

class Weather {
  String city;
  String state;
  Weather({this.city,this.state});
}

class CurrentWeather{
  String weather_main;
  String weather_description;
  String icon_url;
  String name;
  var temp;
  var feels_like;
  var temp_min;
  var temp_max;
  var pressure;
  var humidity;
  var wind_speed;
  var cod;
  var error_message;

  CurrentWeather({this.weather_main,this.name,
  this.weather_description,this.icon_url,this.temp,this.temp_min,this.temp_max,this.feels_like,this.pressure,this.humidity,this.wind_speed,this.cod,this.error_message});
}


var icon_urls = {
  "Thunderstorm":"assets/thunderstorm.jpg",
  "Drizzle":"assets/drizzling.jpg",
  "Rain":"assets/rain.jpg",
  "Snow":"assets/snow.jpg",
  "Clear":"assets/clear_sky.jpg",
  "Clouds":"assets/clouds.jpg",
};
import 'package:flutter/material.dart';
import 'package:weather_app/custom_location.dart';
import 'package:weather_app/shared_resouces/custom_weather.dart';


class FillData extends StatefulWidget {
  @override
  _FillDataState createState() => _FillDataState();
}

class _FillDataState extends State<FillData> {

  var weather = Weather();
  bool isEnabled = false;
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();


  Widget _findWeatherwithCity(){
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: "Name of City"),
        validator: (String val) {
          if(val.isEmpty){
            return "Type in the city";
          }
        },
        onChanged: (String val){
          if(val.isNotEmpty) {
            setState(() {
              isEnabled = true;
            });
          }
        },
        onSaved: (String val){
          weather.city = val;
        },
      ),
    );
  }

  Widget _findWeatherwithState(){
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: "Name of State"),
        validator: (String val) {
          if(val.isEmpty){
            return "Type in the state";
          }
        },
        onChanged: (String val){
          if(val.isNotEmpty) {
            setState(() {
              isEnabled = true;
            });
          }
        },
        onSaved: (String val){
          weather.state = val;
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter details for Weather Condition"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _findWeatherwithCity(),
              _findWeatherwithState(),
              RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                elevation: 10,
                child: Text("Find Weather"),
                onPressed: isEnabled ? (){
                  if(!_formKey.currentState.validate())
                    return;

                  _formKey.currentState.save();
                  //print(city);
                  
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=>CustomWeather(weather:weather))
                  );
                } : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_dust/bloc/air_bloc.dart';
import 'package:flutter_dust/models/air_result.dart';

void main() => runApp(MyApp());

final airBloc = AirBloc();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<AirResult>(
          stream: airBloc.airResult,
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return buildPadding(snapshot.data);
            } else {
              return CircularProgressIndicator();
            }
          }
        ),
      ),
    );
  }

  Widget buildPadding(AirResult _result) {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '현재 위치 미세먼지',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 16.0,
              ),
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.network('https://www.airvisual.com/images/${_result.data.current.weather.ic}.png',
                          width: 30.0 , height: 30.0,),
                          Text(
                            '${_result.data.current.pollution.aqius}',
                            style: TextStyle(fontSize: 40),
                          ),
                          Text(
                            getString(_result),
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      color: getColor(_result),
                      padding: EdgeInsets.all(8.0),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                      Image.network('https://www.airvisual.com/images/${_result.data.current.weather.ic}.png',
                        width: 30.0 , height: 30.0,),
                              SizedBox(
                                width: 16,
                              ),
                              Text('${_result.data.current.weather.tp}', style: TextStyle(fontSize: 16))
                            ],

                          ),
                          Text('습도 ${_result.data.current.weather.hu} %'),
                          Text('풍속 ${_result.data.current.weather.ws} m/s'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                  color: Colors.orange,
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //refresh
                    airBloc.refresh();
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }

  Color getColor(AirResult result) {
    if(result.data.current.pollution.aqius <= 50 ){
      return Colors.greenAccent;
    } else if(result.data.current.pollution.aqius <= 100){
      return Colors.yellow;

    } else if(result.data.current.pollution.aqius <= 150){
      return Colors.orange;

    }else{
      return Colors.red;

    }
  }

  String getString(AirResult result) {
    if(result.data.current.pollution.aqius <= 50 ){
      return '좋음!';
    } else if(result.data.current.pollution.aqius <= 100){
      return '보통!';

    } else if(result.data.current.pollution.aqius <= 150){
      return '나쁨!';

    }else{
      return '매우나쁨!';

    }
  }
}

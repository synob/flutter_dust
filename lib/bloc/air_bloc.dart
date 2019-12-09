import 'package:flutter_dust/models/air_result.dart' ;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

class AirBloc {

  final _airSubject = BehaviorSubject<AirResult>();

  Future<AirResult> fetchData() async{
    var response = await http.get('https://api.airvisual.com/v2/nearest_city?key=3f5a44f5-5651-4f57-84c6-8d342ece9a4e');

    AirResult result = AirResult.fromJson(json.decode(response.body));

    return result;
  }

  void fetch() async {
    var airResult = await fetchData();
    _airSubject.add(airResult);
  }

  void refresh() {
    print('refresh');
    fetch();
  }

  Stream<AirResult> get airResult => _airSubject.stream;

  AirBloc(){
    fetch();
  }



}
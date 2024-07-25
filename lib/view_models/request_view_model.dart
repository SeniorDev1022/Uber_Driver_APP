import 'package:kenorider_driver/services/useDio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/request_model.dart'; // Adjust the import path as needed
import 'package:localstorage/localstorage.dart';
class RequestViewModel extends ChangeNotifier {

  final RequestModel _request = RequestModel();
  RequestModel get request => _request;

  String _status = '';
  String get status => _status;
  void setStatus(String value){
    _status = value;
    notifyListeners();
  }
  Map<String, dynamic> _data = {};

  Map<String, dynamic> get data => _data;


  void updateFromData(Map<String, dynamic> newData) {
    if (newData.containsKey('period')) {
      setPeriod(newData['period'].toString());
    }
    if (newData.containsKey('riderName')) {
      setRiderName(newData['riderName'].toString());
    }  
    if (newData.containsKey('end_location')) {
      setEnd(newData['end_location'].toString());
    }
    if (newData.containsKey('start_location')) {
      setStart(newData['start_location'].toString());
    }
    if (newData.containsKey('orderID')) {
      setOrderID(int.parse(newData['orderID']));
    }
    if (newData.containsKey('cost')) {
      setCost(newData['cost'].toString());
    }
      if (newData.containsKey('rating')) {
      setRating(double.parse(newData['rating'].toString()));
    }
    if (newData.containsKey('riderID')) {
      setRiderID(int.parse(newData['riderID']));
    }
    if(newData.containsKey('route_distance')){
      setDistance(newData['route_distance'].toString());
    }
    if(newData.containsKey('status')){
      setStatus(newData['status'].toString());
    }
    // Add other fields as needed
    notifyListeners();
  }
  void setData(Map<String, dynamic> newData) {
    _data = newData;
    notifyListeners();
    updateFromData(newData);
  }
  void setLongitude(double longitude){
    _request.longitude = longitude;
    notifyListeners();
  }
  void setLangitude(double latitude){
    _request.latitude = latitude;
  }
  void setRiderID(int riderID){
    _request.riderID = riderID;
    notifyListeners();
  }
  void setDistance(String distance){
    _request.distance = distance;
    notifyListeners();
  }
  void setCost(String cost){
    _request.cost = cost;
    notifyListeners();
  }
  void setRiderName(String name){
    _request.riderName = name;
    notifyListeners();
  }
  void setOrderID(int id){
    _request.orderID = id;
    notifyListeners();
  }
  void setRiderToken(String token){
    _request.riderToken = token;
    notifyListeners();
  }
  void setRating(double rating){
    _request.rating = rating;
    notifyListeners();
  }
  void setStart(String start){
    _request.startLocation = start;
    notifyListeners();
  }
  void setEnd(String end){
    _request.endLocation = end;
    notifyListeners();
  }
  void setPeriod(String period){
    _request.period = period;
    notifyListeners();
  }
  Future<int> acceptRequest() async{
  final DioService dioService = DioService();
  final data = {
    'riderID': request.riderID,
    'driverID': int.parse(localStorage.getItem('driverID')!),
    "latitude": request.latitude,
    "longitude": request.longitude,
    "orderID": request.orderID
  };
  print(data);
    try {
      final response =
          await dioService.postRequest('/accept', data: data);
      if (response.statusCode == 200) {
          return 200;
      } else {
        // Handle error response
        return 200;
      }
    } catch (e) {
      return 200;
    }
  }
  Future<int> arrivedRequest() async{
  final DioService dioService = DioService();
  final data = {
    'riderID': request.riderID,
    'driverID': int.parse(localStorage.getItem('driverID')!),
  };
    try {
      final response =
          await dioService.postRequest('/arrived', data: data);
      if (response.statusCode == 200) {
          return 200;
      } else {
        // Handle error response
        return 404;
      }
    } catch (e) {
      return 501;
    }
  }
  Future<int> finishRequest() async{
  final DioService dioService = DioService();
  final data = {
    'riderID': request.riderID,
    'driverID': int.parse(localStorage.getItem('driverID')!),
  };
    try {
      final response =
          await dioService.postRequest('/finish', data: data);
      if (response.statusCode == 200) {
          return 200;
      } else {
        // Handle error response
        return 404;
      }
    } catch (e) {
      return 501;
    }
  }
  Future<int> tripRequest() async{
  final DioService dioService = DioService();
  final data = {
    'riderID': request.riderID,
    'driverID': int.parse(localStorage.getItem('driverID')!),
  };
    try {
      final response =
          await dioService.postRequest('/trip', data: data);
      if (response.statusCode == 200) {
          return 200;
      } else {
        // Handle error response
        return 404;
      }
    } catch (e) {
      return 501;
    }
  }
}


class RequestModel {
  String? riderName;
  String? distance;
  double? rating;
  String? riderToken;
  String? startLocation;
  String? endLocation;
  String? period;
  String? currentPostion;
  int? riderID;
  int? orderID;
  String? cost;
  double? latitude;
  double? longitude;


  RequestModel({this.startLocation,this.orderID,this.longitude, this.latitude, this.currentPostion, this.riderToken, this.riderID, this.distance, this.riderName, this.rating, this.endLocation, this.period, this.cost});

  RequestModel.fromJson(Map<String, dynamic> json) {
    startLocation = json['start_location'];
    riderID = json['riderID'];
    orderID = int.parse(json['orderID']);
    endLocation = json['end_location'];
    riderToken = json['riderToken'];
    period = json['period'];
    cost = json['cost'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    riderName = json['riderName'];
    distance = json['route_distance'];
    riderID = json['riderId'];
  }
}
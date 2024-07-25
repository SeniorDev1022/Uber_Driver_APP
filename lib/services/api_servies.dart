import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kenorider_driver/common/Global_variable.dart';
import '../models/driver_model.dart';
import 'package:localstorage/localstorage.dart';
class ApiService {
  final String baseUrl =
      "http://54.173.7.68/api/"; // Replace with your actual base URL

  // ignore: prefer_typing_uninitialized_variables
  var token;
  Future<Map<String, dynamic>> registerDriver(DriverModel driver) async {
    final response = await http.post(
      Uri.parse("http://54.173.7.68/api/registerDriver"),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'full_name': driver.fullName,
        'email': driver.email,
        'phone_number': driver.phoneNumber,
        'password': driver.password,
        'city': driver.city,
        'car_type': driver.carType,
        'car_color': driver.carColor,
        'car_number': driver.carNumber,
        'rating': driver.rating,
        'driver_token': driver.driverToken,
        "license_verification":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/wcAAgAB6iFzLsIAAAAASUVORK5CYII=",
        "driver_photo":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/wcAAgAB6iFzLsIAAAAASUVORK5CYII=",
        "car_photo":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/wcAAgAB6iFzLsIAAAAASUVORK5CYII=",
        'license_number': driver.licenseNo
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register driver');
    }
  }
  static Future<void> logout() async {
    localStorage.removeItem("user");
  }
  static Future<int> loginDriver(
      String email, String password, String method) async {
        print("=========>${GlobalVariables.deviceToken}");
    final String flag = method == 'email'
        ? 'email'
        : 'phone_number'; // Determine the flag based on the method
    final url = Uri.parse('http://54.173.7.68/api/loginDriver');
    final headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({'method': flag, flag: email, 'password': password, 'driverToken':GlobalVariables.deviceToken});
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      // ignore: non_constant_identifier_names
      String ID = responseBody['driverID'].toString();
      String rating = responseBody['rating'].toString();
      String credit = responseBody['credit'].toString();
      await initLocalStorage();
      localStorage.setItem('driverID',ID);
      localStorage.setItem('driverName', responseBody['driverName']);
      localStorage.setItem('access_token', responseBody['access_token']);
      localStorage.setItem('rating', rating);
      localStorage.setItem('creditCard',  credit);
      return response.statusCode;
    } else {
      throw Exception('Failed to login');
    }
  }
}

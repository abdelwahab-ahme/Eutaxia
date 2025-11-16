import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<bool> sendOtp(String phone) async {
    final url = Uri.parse("\$baseUrl/send-otp");
    final res = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"phone": phone}));
    return res.statusCode == 200;
  }

  static Future<bool> verifyOtp(String phone, String code) async {
    final url = Uri.parse("\$baseUrl/verify-otp");
    final res = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"phone": phone, "code": code}));
    return res.statusCode == 200;
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final url = Uri.parse("\$baseUrl/register");
    final res = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data));
    return json.decode(res.body);
  }

  static Future<Map<String, dynamic>> login(String phone) async {
    final url = Uri.parse("\$baseUrl/login");
    final res = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"phone": phone}));
    return json.decode(res.body);
  }

  static Future<Map<String, dynamic>> createTrip(Map<String, dynamic> data) async {
    final url = Uri.parse("\$baseUrl/trips");
    final res = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(data));
    return json.decode(res.body);
  }

  static Future<List<dynamic>> getPendingTrips() async {
    final url = Uri.parse("\$baseUrl/trips/pending");
    final res = await http.get(url);
    return json.decode(res.body)["trips"];
  }

  static Future<bool> updateDriverLocation(int driverId, double lat, double lng) async {
    final url = Uri.parse("\$baseUrl/drivers/\$driverId/location");
    final res = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"driver_id": driverId, "lat": lat, "lng": lng}));
    return res.statusCode == 200;
  }

  static WebSocketChannel connectAsClient(int userId) {
    return WebSocketChannel.connect(Uri.parse("ws://10.0.2.2:8000/ws/client/\$userId"));
  }

  static WebSocketChannel connectAsDriver(int driverId) {
    return WebSocketChannel.connect(Uri.parse("ws://10.0.2.2:8000/ws/driver/\$driverId"));
  }
}
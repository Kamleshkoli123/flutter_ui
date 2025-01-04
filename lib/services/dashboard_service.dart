import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import '../models/dashboard_item.dart';

class DashboardService {
  static const String baseUrl = "http://10.0.2.2:9001";

  static Future<List<DashboardItem>> getServices(String path) async {
    final token = await AuthService.getToken();

    final uri = Uri.parse("$baseUrl/dashboard/getService").replace(queryParameters: {
      "path": path,
    });

    final response = await http.get(
      uri,
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => DashboardItem.fromJson(item)).toList();
    } else {
      throw Exception("Failed to fetch services: ${response.body}");
    }
  }
}

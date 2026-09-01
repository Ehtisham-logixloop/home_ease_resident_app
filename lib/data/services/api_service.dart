
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/services/local_storage_service.dart';

class ApiService {
  Future<Map<String, dynamic>> postRequest(
    String url,
    Map<String, dynamic> data, {
    bool requireAuth = false,
  }) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (requireAuth) {
        final token = await LocalStorageService.getToken();
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }
      }

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to connect: $e');
    }
  }

  Future<Map<String, dynamic>> putRequest(
    String url,
    Map<String, dynamic> data, {
    bool requireAuth = false,
  }) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (requireAuth) {
        final token = await LocalStorageService.getToken();
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }
      }

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to connect: $e');
    }
  }

  Future<Map<String, dynamic>> getRequest(
    String url, {
    bool requireAuth = false,
  }) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (requireAuth) {
        final token = await LocalStorageService.getToken();
        if (token != null) {
          headers['Authorization'] = 'Bearer $token';
        }
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to connect: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {'success': true, 'data': data};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Request failed',
      };
    }
  }
}


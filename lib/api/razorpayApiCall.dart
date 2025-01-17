import 'dart:convert';
import 'package:foodex/models/razorpayclasses.dart';
import 'package:http/http.dart' as http;

class RazorpayApiService {
  final String keyId;
  final String keySecret;
  final String baseUrl = 'https://api.razorpay.com/v2';

  RazorpayApiService({required this.keyId, required this.keySecret});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$keyId:$keySecret'))}',
      };

  Future<Map<String, dynamic>> createAccount(AccountCreateRequest request) async {
    try {
      print("create function started");
      final response = await http.post(
        Uri.parse('$baseUrl/accounts'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );
      print(response.body);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createStakeholder(
      String accountId, StakeholderRequest request) async {
    try {print("stake holder started");
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/$accountId/stakeholders'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );
      print(response.body);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createProduct(
      String accountId, ProductRequest request) async {
    try {
      print("create product started");
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/$accountId/products'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );
      print(response.body);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateProduct(
      String accountId, String productId, ProductUpdateRequest request) async {
    try {
      print("update product started");
      final response = await http.patch(
        Uri.parse('$baseUrl/accounts/$accountId/products/$productId'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );
      print(response.body);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['error']?['description'] ?? 'An error occurred');
    }
  }

  Exception _handleError(dynamic error) {
    if (error is http.ClientException) {
      return Exception('Network error occurred');
    }
    return error;
  }
}

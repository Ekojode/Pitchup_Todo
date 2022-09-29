import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/exceptions.dart';

class Auth with ChangeNotifier {
  String _token = "";
  late String _userId;

  final baseUrl = "https://identitytoolkit.googleapis.com/v1/accounts:";
  final apiKey = "AIzaSyCmNyKP9tGDPKcPjM7VrT_evnQDOrwGPbk";
  String get token {
    //  if (_token != null) {
    return _token;
    // }
    // return null;
  }

  String get userId {
    //  if (_userId != null) {
    return _userId;
    // }
    // return null;
  }

  bool get isNotAuth {
    return token == "";
  }

  Future<void> authenticate(
      String email, String password, String status) async {
    final url = Uri.parse("$baseUrl$status?key=$apiKey");
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {"email": email, "password": password, "returnSecureToken": true},
        ),
      );
      final responseData = jsonDecode(response.body);
      if (responseData["error"] != null) {
        throw HttpExceptions(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) {
    return authenticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) {
    return authenticate(email, password, "signInWithPassword");
  }

  Future<void> logOut() async {
    _token = "";
    _userId = "";
    notifyListeners();
  }

  Future<void> requestPasswordRecovery(String email) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$apiKey");
    final response = await http.post(
      url,
      body: jsonEncode(
        {"requestType": "PASSWORD_RESET", "email": email},
      ),
    );
    final responseData = jsonDecode(response.body);
    if (responseData["error"] != null) {
      throw HttpExceptions(responseData["error"]["message"]);
    }
  }

  Future<void> verifyPRCode(String pwCode, String newPassword) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:resetPassword?key=$apiKey");
    final response = await http.post(
      url,
      body: jsonEncode(
        {"oobCode": pwCode, "newPassword": newPassword},
      ),
    );
    final responseData = jsonDecode(response.body);
    if (responseData["error"] != null) {
      throw HttpExceptions(responseData["error"]["message"]);
    }
  }
}

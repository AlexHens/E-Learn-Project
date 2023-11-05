import 'dart:convert';

import 'package:e_learn_app/data/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class AuthService extends ChangeNotifier {

  final String _baseUrlAuth = ''; // Url para servicios de autenticación
  final String _baseUrlDB = ''; // Url para API Rest de base de datos en tiempo real
  final String _firebaseToken = ''; // Token para usar servicios de autenticación

  Future<String?> crearUsuario(Usuario user, String password) async {

    String dni = user.dni;

    final Map<String, dynamic> authData = {
      'email': user.email,
      'password': password
    };

    final url_auth = Uri.https(_baseUrlAuth, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final resp2 = await http.post(url_auth, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp2.body);

    if(decodeResp.containsKey('idToken')){

      final url_db = Uri.https(_baseUrlDB, 'Usuarios/$dni.json');
      final resp1 = await http.post(url_db, body: user.toJson());

      return null;
    } else {
      return decodeResp['error']['message'];
    }

  }

  Future<Usuario?> login(String email, String password) async {

    GlobalData? data = GlobalData.getInstance();

    data!.dni = password;

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password
    };

    final url_auth = Uri.https(_baseUrlAuth, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final resp2 = await http.post(url_auth, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp2.body);

    if(decodeResp.containsKey('idToken')){

      final url_db = Uri.https(_baseUrlDB, 'Usuarios/$password.json');
      final resp1 = await http.get(url_db);

      if(resp1.body != 'null') {
        final Map<String, dynamic> decodeResp2 = json.decode(resp1.body);

        Usuario user_resp = Usuario.fromMap(decodeResp2);

        return user_resp;
      } else {
        return null;
      }
    } else {
      Usuario user_void = new Usuario(apellidos: 'aaaaa', dni: 'aaaaa', direccion: 'aaaaa', email: 'aaaaa', foto: 'aaaaa', nombre: 'aaaaa', rol: 'aaaaa', telefono: 1234);
      return null;
    }

  }

}
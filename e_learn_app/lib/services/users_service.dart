import 'dart:convert';
import 'dart:io';

import 'package:e_learn_app/models/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminUsersService extends ChangeNotifier {

  final String _baseUrlUsers = '';  // Url para API Rest de firebase para base de datos en tiempo real
  final String _baseUrlAuth = ''; // Url para servicios de autenticación
  final String _firebaseToken = ''; // Token de firebase para servicios de autenticación
  List<Usuario> users = [];

  Future<List<Usuario>> loadUsers() async {

    final url = Uri.https(_baseUrlUsers, 'Usuarios.json');
    final resp = await http.get(url);

    Map<String, dynamic> jsonMapDecode = json.decode(resp.body);

    for(final user in jsonMapDecode.keys) {

      final url2 = Uri.https(_baseUrlUsers, 'Usuarios/$user.json');
      final resp2 = await http.get(url2);

      final Map<String, dynamic> decodeResp = json.decode(resp2.body);
      Usuario currentUser = Usuario.fromMap(decodeResp);
      users.add(currentUser);

    }

    return this.users;
  }

  Future<Usuario> getUserByID(String userID) async {

    final url = Uri.https(_baseUrlUsers, 'Usuarios/$userID.json');
    final resp = await http.get(url);

    Map<String, dynamic> jsonMapDecode = json.decode(resp.body);

    Usuario user = Usuario.fromMap(jsonMapDecode);

    return user;
  }

  Future<void> addUser(File image, String name, String lastName, String dni, String email, String location, String phone, String rol) async {

    try{

      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference firebaseStorageReference = FirebaseStorage.instance.ref().child('E-Learn/usuarios/$dni/$fileName.png');

      UploadTask uploadTask = firebaseStorageReference.putFile(image);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      Map<String, dynamic> bodyUser = {
        'Apellidos': lastName,
        'DNI': dni,
        'Direccion': location,
        'Email': email,
        'Foto': downloadUrl,
        'Nombre': name,
        'Rol': rol,
        'Telefono': int.parse(phone)
      };

      final url = Uri.https(_baseUrlUsers, 'Usuarios/$dni.json');
      final resp = await http.patch(url, body: json.encode(bodyUser));

      final Map<String, dynamic> authData = {
        'email': email,
        'password': dni
      };

      final url_auth = Uri.https(_baseUrlAuth, '/v1/accounts:signUp', {
        'key': _firebaseToken
      });

      final resp2 = await http.post(url_auth, body: json.encode(authData));
      final Map<String, dynamic> decodeResp = json.decode(resp2.body);

    } catch (e) {
      print('Error al añadir al usuario: $e');
    }

  }

  Future<void> deleteUser(String userID, String email) async {

    final Reference _firebaseStorageReference = FirebaseStorage.instance.ref().child('E-Learn/usuarios/$userID');

    try{

      final ListResult result = await _firebaseStorageReference.listAll();

      for(final Reference image in result.items) {
        await image.delete();
      }

    } catch(e) {
      print('Error al eliminar las imágenes: $e');
    }

    final url = Uri.https(_baseUrlUsers, 'Usuarios/$userID.json');
    final resp = await http.delete(url);

  }

  Future<String> editUserImage(File newImage, String dni) async {

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference firebaseStorageReference = FirebaseStorage.instance.ref().child('E-Learn/usuarios/$dni/$fileName.png');

    UploadTask uploadTask = firebaseStorageReference.putFile(newImage);

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<void> changeLogin(String email, String dni) async {

    final Map<String, dynamic> authData = {
      'email': email,
      'password': dni
    };

    final url_auth = Uri.https(_baseUrlAuth, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final resp2 = await http.post(url_auth, body: json.encode(authData));
    final Map<String, dynamic> decodeResp = json.decode(resp2.body);

  }

  Future<void> editUser(String urlImage, String name, String lastName, String dni, String email, String location, String phone, String rol) async {

    Map<String, dynamic> bodyUser = {
        'Apellidos': lastName,
        'DNI': dni,
        'Direccion': location,
        'Email': email,
        'Foto': urlImage,
        'Nombre': name,
        'Rol': rol,
        'Telefono': int.parse(phone)
      };

      final url = Uri.https(_baseUrlUsers, 'Usuarios/$dni.json');
      final resp = await http.patch(url, body: json.encode(bodyUser));

  }

}
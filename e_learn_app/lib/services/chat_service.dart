import 'dart:convert';

import 'package:e_learn_app/models/models.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class AdminChatService extends ChangeNotifier {

  final String _baseUrlUsers = '';  // Url para API Rest de la base de datos en tiempo real
  final String _baseUrlAuth = ''; // Url para servicios de autenticación
  final String _firebaseToken = ''; // Token de firebase para autenticación
  List<Usuario> users = [];
  List<Mensaje> messages = [];
  DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  void loadReferenceToChat(String reference) {
    _databaseReference = _databaseReference.child('Chats/$reference');
  }

  Stream<DatabaseEvent> get messagesStream => _databaseReference.onValue;

  Future<List<Usuario>> loadUsers() async {

    final url = Uri.https(_baseUrlUsers, 'Usuarios.json');
    final resp = await http.get(url);

    Map<String, dynamic> jsonMapDecode = json.decode(resp.body);

    for(final user in jsonMapDecode.keys) {

      final url2 = Uri.https(_baseUrlUsers, 'Usuarios/$user.json');
      final resp2 = await http.get(url2);

      print(resp2.body);

      final Map<String, dynamic> decodeResp = json.decode(resp2.body);
      Usuario currentUser = Usuario.fromMap(decodeResp);
      users.add(currentUser);

    }

    return this.users;
  }

  Future<String> searchDBReference(String userID1, String userID2) async {
    String reference = '$userID1 - $userID2';

    final url = Uri.https(_baseUrlUsers, 'Chats.json');
    final resp = await http.get(url);

    Map<String, dynamic> chats = json.decode(resp.body);

    if(chats.containsKey('$userID1 - $userID2')) {
      reference = '$userID1 - $userID2';
    } else if(chats.containsKey('$userID2 - $userID1')) {
      reference = '$userID2 - $userID1';
    }

    return reference;
  }

  void sendMessage(Mensaje mensaje) {
    _databaseReference.child(mensaje.fechaEnvio.toString()).set(mensaje.toMap());
  }

  void deleteMessage(String messageID) {
    _databaseReference.child(messageID).remove();
  }

}
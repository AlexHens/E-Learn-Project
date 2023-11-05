
import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AlumnContentTaskService extends ChangeNotifier {

  final String _baseUrlTasks = '';  // Url para API Rest de firebase para base de datos en tiempo real
  Map<String, dynamic> contentTaskList = {};
  Map<String, dynamic> contentSolutionList = {};

  AlumnContentTaskService();

  Future<Map<String, dynamic>> loadTaskFiles(String idTask) async {

    final url = Uri.https(_baseUrlTasks, 'ContenidoTarea/$idTask.json');
    final resp = await http.get(url);

    if(resp.body != 'null') {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if(decodeResp != null) {
        contentTaskList = decodeResp;
      }

    }

    return this.contentTaskList;
  }

  Future<Map<String, dynamic>> loadTaskSolutions(String idTask) async {

    final url = Uri.https(_baseUrlTasks, 'SolucionesTarea/$idTask.json');
    final resp = await http.get(url);

    if(resp.body != 'null') {
      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if(decodeResp != null) {
        contentSolutionList = decodeResp;
      }

    }

    return this.contentSolutionList;
  }

  Future<void> loadFileContent(String idTask, String file_name, String file_path) async {

    var url;

    if(file_path == '') {

      final url2 = Uri.https(_baseUrlTasks, 'SolucionesTarea/$idTask/$file_name.json');
      final resp = await http.get(url2);

      if(resp.statusCode == 200) {
        print(resp.body);
        String path = json.decode(resp.body);

        print(path);

        url = Uri.parse(path);

        if(!await launchUrl(url)) throw 'Could not launch $url';
      }

    } else {

      url = Uri.parse(file_path);

      if(!await launchUrl(url)) throw 'Could not launch $url';

    }


  }

  Future<void> addFileToSolution(String idTask, String fileName, File file) async {
    
    String url_file = 'void';

    Reference firebaseStorageReference = FirebaseStorage.instance.ref().child('E-Learn/solucion tareas/$idTask/$fileName.pdf');

    UploadTask task = firebaseStorageReference.putFile(file);

    await task.whenComplete(() async {

      String download_url = await firebaseStorageReference.getDownloadURL();

      await Future.delayed(Duration(seconds: 2));

      final url = Uri.https(_baseUrlTasks, 'SolucionesTarea/$idTask.json');
      Map<String, dynamic> url_body = {
        fileName: download_url
      };

      final resp = await http.patch(url, body: json.encode(url_body));

      if(resp.statusCode != 200) {
        print('Error');
      }

    });

  }

  Future<String?> getDownloadURLFromFile(String idTask, String fileName) async {

    final url = Uri.https(_baseUrlTasks, 'SolucionesTarea/$idTask/$fileName.json');
    final resp = await http.get(url);

    if(resp.statusCode == 200) {
      return json.decode(resp.body);
    }

    return null;

  }

  Future<void> deleteFile(String idTask, String fileName) async {
    
    Reference firebaseStorageReference = FirebaseStorage.instance.ref().child('E-Learn/solucion tareas/$idTask/$fileName.pdf');

    await firebaseStorageReference.delete();

    final url = Uri.https(_baseUrlTasks, 'SolucionesTarea/$idTask/$fileName.json');
    final resp = await http.delete(url);

    if(resp.statusCode == 200) {
      print('Archivo borrado de la BD con éxito');
    }

  }

  Future<int> getCalification(String taskID) async {

    int calification = 0;

    final url = Uri.https(_baseUrlTasks, 'Tareas/$taskID/calificacion.json');
    final resp = await http.get(url);

    if(resp.body != 'null') {
      calification = json.decode(resp.body);
    }

    return calification;

  }

}

class TeacherContentTaskService extends ChangeNotifier {

  final String _baseUrlTasks = 'e-learn-86f7e-default-rtdb.europe-west1.firebasedatabase.app';
  Map<String, dynamic> contentTaskList = {};
  Map<String, dynamic> contentSolutionList = {};

  TeacherContentTaskService();

  Future<Map<String, dynamic>> loadTaskFiles(String idTask) async {

    final url = Uri.https(_baseUrlTasks, 'ContenidoTarea/$idTask.json');
    final resp = await http.get(url);

    if(resp.body != 'null') {

      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if(decodeResp != null) {
        contentTaskList = decodeResp;
      }

    }

    return this.contentTaskList;
  }

  Future<Map<String, dynamic>> loadTaskSolutions(String idTask) async {

    final url = Uri.https(_baseUrlTasks, 'SolucionesTarea/$idTask.json');
    final resp = await http.get(url);

    if(resp.body != 'null') {
      Map<String, dynamic> decodeResp = json.decode(resp.body);

      if(decodeResp != null) {
        contentSolutionList = decodeResp;
      }

    }

    return this.contentSolutionList;
  }

  Future<void> loadFileContent(String idTask, String file_name, String file_path) async {

    var url;

    if(file_path == '') {

      final url2 = Uri.https(_baseUrlTasks, 'SolucionesTarea/$idTask/$file_name.json');
      final resp = await http.get(url2);

      if(resp.statusCode == 200) {
        print(resp.body);
        String path = json.decode(resp.body);

        print(path);

        url = Uri.parse(path);

        if(!await launchUrl(url)) throw 'Could not launch $url';
      }

    } else {

      url = Uri.parse(file_path);

      if(!await launchUrl(url)) throw 'Could not launch $url';

    }


  }

  Future<int> getCalification(String taskID) async {

    int calification = 0;

    final url = Uri.https(_baseUrlTasks, 'Tareas/$taskID/calificacion.json');
    final resp = await http.get(url);

    if(resp.body != 'null') {
      calification = json.decode(resp.body);
    }

    return calification;

  }

  Future<void> setCalificatio(String taskID, int calification) async {

    final url = Uri.https(_baseUrlTasks, 'Tareas/$taskID.json');
    Map<String, int> url_body = {
      'calificacion': calification
    };
    final resp = await http.patch(url, body: json.encode(url_body));

    if(resp.statusCode != 200) {
      print('Error');
    }

  }

}
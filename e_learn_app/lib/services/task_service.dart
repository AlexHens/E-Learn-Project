import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:e_learn_app/models/models.dart';
import 'package:http/http.dart' as http;

import '../data/GlobalData.dart';


class AlumnTaskService extends ChangeNotifier{

  final String _baseUrlTasks = '';  // Url para API Rest de firebase para base de datos en tiempo real
  List<Tarea> alumnTasks = [];

  Future<List<Tarea>> getAlumnTasks(String alumnId) async {

    final url = Uri.https(_baseUrlTasks, 'AlumnoRealizaTarea/$alumnId.json');
    final resp = await http.get(url);

    Map<String, dynamic> jsonMapDecode = json.decode(resp.body);

    for(final taskId in jsonMapDecode.keys) {
      final url2 = Uri.https(_baseUrlTasks, 'Tareas/$taskId.json');
      final resp2 = await http.get(url2);
      
      final Map<String, dynamic> decodeResp = json.decode(resp2.body);
      Tarea alumTask = Tarea.fromMap(decodeResp);
      alumnTasks.add(alumTask);
    }

    return this.alumnTasks;

  }

  Future<Tarea?> getTaskByID(String taskID) async {

    final url = Uri.https(_baseUrlTasks, 'Tareas/$taskID.json');
    final resp = await http.get(url);

    final Map<String, dynamic> decodeResp = json.decode(resp.body);
    Tarea alumnTask = Tarea.fromMap(decodeResp);

    return alumnTask;

  }

}

class TeacherTaskService extends ChangeNotifier{

  final String _baseUrlTasks = 'e-learn-86f7e-default-rtdb.europe-west1.firebasedatabase.app';
  List<Tarea> teacherTasks = [];
  GlobalData? dataTeacher = GlobalData.getInstance();

  Future<List<Tarea>> getTeacherTasks(String teacherId) async {

    final url = Uri.https(_baseUrlTasks, 'ProfesorCreaTarea/$teacherId.json');
    final resp = await http.get(url);

    Map<String, dynamic> jsonMapDecode = json.decode(resp.body);

    for(final taskId in jsonMapDecode.keys) {
      final url2 = Uri.https(_baseUrlTasks, 'Tareas/$taskId.json');
      final resp2 = await http.get(url2);
      
      final Map<String, dynamic> decodeResp = json.decode(resp2.body);
      Tarea alumTask = Tarea.fromMap(decodeResp);
      teacherTasks.add(alumTask);
    }

    return this.teacherTasks;

  }

  Future<Tarea?> searchTask(String taskId) async {
    
    final url = Uri.https(_baseUrlTasks, 'Tareas/$taskId.json');
    final resp = await http.get(url);

    if(json.decode(resp.body) != null) {

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      Tarea task_resp = Tarea.fromMap(decodeResp);

      return task_resp;
    } else {
      return null;
    }

  }

  Future<Usuario?> searchAlumn(String alumnId) async {

    final url = Uri.https(_baseUrlTasks, 'Usuarios/$alumnId.json');
    final resp = await http.get(url);

    if(json.decode(resp.body) != null) {

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      Usuario user_resp = Usuario.fromMap(decodeResp);

      if(user_resp.rol == 'Alumno') {
        return user_resp;
      } else {
        return null;
      }
    } else {
      return null;
    }

  }

  Future<String?> addTask(String taskID, String nameTask, String nameSubject, String description, Map<String, File> fileList, List<String> alumnList) async {

    for(final item in fileList.entries) {

      String fileName = item.key;

      Reference firebaseStorageReference = FirebaseStorage.instance.ref().child('E-Learn/contenido tareas/$taskID/$fileName.pdf');

      UploadTask task = firebaseStorageReference.putFile(item.value);

      await task.whenComplete(() async {

        String download_url = await firebaseStorageReference.getDownloadURL();

        await Future.delayed(Duration(seconds: 2));

        final url = Uri.https(_baseUrlTasks, 'ContenidoTarea/$taskID.json');
        Map<String, dynamic> url_body = {
          fileName: download_url
        };

        final resp = await http.patch(url, body: json.encode(url_body));

        if(resp.statusCode != 200) {
          print('Error');
        }

      });
    }

    if(fileList.length == 0) {
      final url4 = Uri.https(_baseUrlTasks, 'ContenidoTarea.json');
      Map<String, dynamic> url4_body = {
        taskID: ""
      };

      final resp4 = await http.patch(url4, body: json.encode(url4_body));
    }

    for(final alumn in alumnList)  {

      final url2 = Uri.https(_baseUrlTasks, 'AlumnoRealizaTarea/$alumn.json');
      Map<String, dynamic> url2_body = {
        taskID: nameTask
      };

      final resp = await http.patch(url2, body: json.encode(url2_body));

    }

    String teacherId = dataTeacher!.dni;

    final url5 = Uri.https(_baseUrlTasks, 'ProfesorCreaTarea/$teacherId.json');
    Map<String, dynamic> url5_body = {
      taskID: nameTask
    };

    final resp5 = await http.patch(url5, body: json.encode(url5_body));

    final url3 = Uri.https(_baseUrlTasks, 'Tareas/$taskID.json');

    Map<String, dynamic> url3_body = {
      "Descripcion": description,
      "ID": taskID,
      "Nombre": nameTask,
      "Nombre Asignatura": nameSubject
    };

    final resp = await http.patch(url3, body: json.encode(url3_body));

    if(resp.statusCode == 200) {
      return taskID;
    } 

    return null;

  }

  Future<void> deleteTaskContent(Reference firebaseStorageReference) async {

    try{

      final ListResult listResult = await firebaseStorageReference.listAll();

      for(final item in listResult.items) {
        await item.delete();
      }

    } catch (e) {
      print('Error al eliminar los elementos: $e');
    }

  }

  Future<void> deleteTask(String taskID) async {

    Reference firebaseStorageReference1 = FirebaseStorage.instance.ref().child('E-Learn/contenido tareas/$taskID');
    Reference firebaseStorageReference2 = FirebaseStorage.instance.ref().child('E-Learn/solucion tareas/$taskID');

    await deleteTaskContent(firebaseStorageReference1);
    await deleteTaskContent(firebaseStorageReference2);

    final url = Uri.https(_baseUrlTasks, 'ContenidoTarea/$taskID.json');
    final resp = await http.delete(url);

    final url2 = Uri.https(_baseUrlTasks, 'SolucionesTarea/$taskID.json');
    final resp2 = await http.delete(url2);

    final url3 = Uri.https(_baseUrlTasks, 'ProfesorCreaTarea.json');
    final resp3 = await http.get(url3);

    final Map<String, dynamic> teachersId = json.decode(resp3.body);

    for(String teacherID in teachersId.keys) {

      final Map<String, dynamic> taskList = teachersId[teacherID];

      if(taskList.containsKey(taskID)) {

        final url4 = Uri.https(_baseUrlTasks, 'ProfesorCreaTarea/$teacherID/$taskID.json');
        final resp4 = await http.delete(url4);

      }

    }

    final url5 = Uri.https(_baseUrlTasks, 'AlumnoRealizaTarea.json');
    final resp5 = await http.get(url5);

    final Map<String, dynamic> alumnsId = json.decode(resp3.body);

    for(String alumnID in alumnsId.keys) {

      final Map<String, dynamic> taskList = alumnsId[alumnID];

      if(taskList.containsKey(taskID)) {

        final url6 = Uri.https(_baseUrlTasks, 'AlumnoRealizaTarea/$alumnID/$taskID.json');
        final resp6 = await http.delete(url6);

      }

    }

    final url7 = Uri.https(_baseUrlTasks, 'Tareas/$taskID.json');
    final resp7 = await http.delete(url7);

  }

  Future<Tarea?> getTaskByID(String taskID) async {

    final url = Uri.https(_baseUrlTasks, 'Tareas/$taskID.json');
    final resp = await http.get(url);

    final Map<String, dynamic> decodeResp = json.decode(resp.body);
    Tarea alumnTask = Tarea.fromMap(decodeResp);

    return alumnTask;

  }

}
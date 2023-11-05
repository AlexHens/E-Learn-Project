
import 'dart:convert';

import 'package:e_learn_app/models/models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeacherSubjectService extends ChangeNotifier {

  final String _baseUrlSubjects = ''; // Url para API Rest de firebase para base de datos en tiempo real
  Map<String, dynamic> teacherSubjects = {};
  bool isLoading = true;
  late Asignatura selectedSubject;

  TeacherSubjectService(String dni) {
    this.loadTeacherSubjects(dni);
  }

  Future<Map<String, dynamic>> loadTeacherSubjects(String id) async {

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrlSubjects, 'ProfesorImparteAsignatura/$id.json');

    final resp = await http.get(url);

    if(resp.body != 'null'){
      final Map<String, dynamic> subjectsMap = json.decode(resp.body);
      teacherSubjects = subjectsMap;
    }

    this.isLoading = false;
    notifyListeners();

    return this.teacherSubjects;
        
  }

  Future<Asignatura> getSubjectByID(String id) async {

    final url = Uri.https(_baseUrlSubjects, 'Asignaturas/$id.json');
    final resp = await http.get(url);

    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    print(decodeResp);

    Asignatura subject = Asignatura.fromMap(decodeResp);

    return subject;
  }


}

class AlumnSubjectService extends ChangeNotifier {

  final String _baseUrlSubjects = 'e-learn-86f7e-default-rtdb.europe-west1.firebasedatabase.app';
  Map<String, dynamic> alumnSubjects = {};
  bool isLoading = true;
  late Asignatura selectedSubject;

  AlumnSubjectService(String dni) {
    this.loadAlumnSubjects(dni);
  }

  Future<Map<String, dynamic>> loadAlumnSubjects(String id) async {

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrlSubjects, 'AlumnoMatriculaAsignatura/$id.json');

    final resp = await http.get(url);

    if(resp.body != 'null'){
      final Map<String, dynamic> subjectsMap = json.decode(resp.body);

      alumnSubjects = subjectsMap;
    }

    this.isLoading = false;
    notifyListeners();

    return this.alumnSubjects;
        
  }

  Future<Asignatura> getSubjectByID(String id) async {

    final url = Uri.https(_baseUrlSubjects, 'Asignaturas/$id.json');
    final resp = await http.get(url);

    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    print(decodeResp);

    Asignatura subject = Asignatura.fromMap(decodeResp);

    return subject;
  }


}

class AdminSubjectService extends ChangeNotifier {

  final String _baseUrlSubjects = 'e-learn-86f7e-default-rtdb.europe-west1.firebasedatabase.app';
  Map<String, dynamic> adminSubjects = {};
  bool isLoading = true;
  late Asignatura selectedSubject;

  AdminSubjectService() {
    this.loadAdminSubjects();
  }

  Future<Map<String, dynamic>> loadAdminSubjects() async {

    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrlSubjects, 'Asignaturas.json');

    final resp = await http.get(url);

    if(resp.body != 'null') {
      final Map<String, dynamic> subjectsMap = json.decode(resp.body);

      subjectsMap.forEach((key, value) {
        this.adminSubjects[key] = value['Nombre'];
      });
    }

    this.isLoading = false;
    notifyListeners();

    return this.adminSubjects;
        
  }

  Future<Asignatura> getSubjectByID(String id) async {

    final url = Uri.https(_baseUrlSubjects, 'Asignaturas/$id.json');
    final resp = await http.get(url);

    final Map<String, dynamic> decodeResp = json.decode(resp.body);

    print(decodeResp);

    Asignatura subject = Asignatura.fromMap(decodeResp);

    return subject;
  }

  Future<Usuario?> searchTeacher(String teacherId) async {

    final url = Uri.https(_baseUrlSubjects, 'Usuarios/$teacherId.json');
    final resp = await http.get(url);

    if(json.decode(resp.body) != null) {

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      Usuario user_resp = Usuario.fromMap(decodeResp);

      if(user_resp.rol == 'Profesor') {
        return user_resp;
      } else {
        return null;
      }
    } else {
      return null;
    }

  }

  Future<Usuario?> searchAlumn(String alumnId) async {

    final url = Uri.https(_baseUrlSubjects, 'Usuarios/$alumnId.json');
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

  Future<Asignatura?> searchSubject(String subjectId) async {

    final url = Uri.https(_baseUrlSubjects, 'Asignaturas/$subjectId.json');
    final resp = await http.get(url);

    if(json.decode(resp.body) != null) {

      final Map<String, dynamic> decodeResp = json.decode(resp.body);

      Asignatura subject_resp = Asignatura.fromMap(decodeResp);
      
      return subject_resp;
    } else {
      return null;
    }

  }

  Future<String?> addSubject(String subjectId, String subjectName, String subjectDescription, String gradeSubject, List<String> listTeachers, List<String> listAlumns) async {

    final url = Uri.https(_baseUrlSubjects, 'Asignaturas/$subjectId.json');

    Map<String, dynamic> json_body = {
      'Curso': gradeSubject,
      'Descripción': subjectDescription,
      'ID': subjectId,
      'Nombre': subjectName
    };

    final resp = await http.patch(url, body: json.encode(json_body));

    for(String idTeacher in listTeachers) {

      final url2 = Uri.https(_baseUrlSubjects, 'ProfesorImparteAsignatura/$idTeacher.json');
      
      Map<String, dynamic> json_body2 = {
        subjectId: subjectName
      };

      final resp2 = await http.patch(url2, body: json.encode(json_body2));

    }

    for(String idAlumn in listAlumns) {

      final url3 = Uri.https(_baseUrlSubjects, 'AlumnoMatriculaAsignatura/$idAlumn.json');
      
      Map<String, dynamic> json_body3 = {
        subjectId: subjectName
      };

      final resp3 = await http.patch(url3, body: json.encode(json_body3));

    }

    if(resp.statusCode == 200) {
      return subjectId;
    } else {
      return null;
    }

  }

  Future<void> deleteFolderContent(Reference directoryReference) async {

    try {

      final ListResult listResult = await directoryReference.listAll();

      for(final item in listResult.items) {
        await item.delete();
      }

      for(final prefix in listResult.prefixes) {
        await deleteFolderContent(prefix);
      }
    } catch (e) {
      print('Error al eliminar los elementos del directorio: $e');
    }

  }

  Future<void> deleteSubject(String subjectId) async {

    Reference firebaseStorageReference = FirebaseStorage.instance.ref().child('E-Learn/contenido asignaturas/$subjectId');

    await deleteFolderContent(firebaseStorageReference);

    final url = Uri.https(_baseUrlSubjects, 'Asignaturas/$subjectId.json');
    final resp = await http.delete(url);

    if(resp.statusCode != 200) {
      print('Error');
    }

    final url2 = Uri.https(_baseUrlSubjects, 'ProfesorImparteAsignatura.json');
    final resp2 = await http.get(url2);

    final Map<String, dynamic> teachersId = json.decode(resp2.body);

    for(String teacherID in teachersId.keys) {

      final Map<String, dynamic> subjectList = teachersId[teacherID];

      if(subjectList.containsKey(subjectId)){

        final url3 = Uri.https(_baseUrlSubjects, 'ProfesorImparteAsignatura/$teacherID/$subjectId.json');
        final resp3 = await http.delete(url3);

        if(resp3.statusCode != 200) {
          print('Error');
        }

      }
    }

    final url4 = Uri.https(_baseUrlSubjects, 'AlumnoMatriculaAsignatura.json');
    final resp4 = await http.get(url4);

    final Map<String, dynamic> alumnsId = json.decode(resp4.body);

    for(String alumnID in alumnsId.keys) {

      final Map<String, dynamic> subjectList = alumnsId[alumnID];

      if(subjectList.containsKey(subjectId)){

        final url5 = Uri.https(_baseUrlSubjects, 'AlumnoMatriculaAsignatura/$alumnID/$subjectId.json');
        final resp5 = await http.delete(url5);

        if(resp5.statusCode != 200) {
          print('Error');
        }

      }
    }

    final url5 = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$subjectId.json');
    final resp5 = await http.delete(url5);

    adminSubjects.remove(subjectId);

    notifyListeners();

  }

}
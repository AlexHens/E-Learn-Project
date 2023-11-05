import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_learn_app/models/models.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';



class AlumnContentService extends ChangeNotifier {

  final String _baseUrlSubjects = ''; // Url para API Rest de firebase para base de datos en tiempo real
  Map<String, dynamic> contentSubjectList = {};

  AlumnContentService();

  Future<Map<String, dynamic>> loadContentSubject(String idSubject) async {

    final url = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$idSubject.json');
    final resp = await http.get(url);

    if(resp.statusCode != 200) {
      print('Error');
    }

    if(json.decode(resp.body) != null) {
      this.contentSubjectList = json.decode(resp.body);
    }


    return this.contentSubjectList;

  }

  Future<void> loadFileContent(String file_name, String file_path) async {

    final url = Uri.parse(file_path);

    if(!await launchUrl(url)) throw 'Could not launch $url';

  }

}

class TeacherContentService extends ChangeNotifier {

  final String _baseUrlSubjects = 'e-learn-86f7e-default-rtdb.europe-west1.firebasedatabase.app';
  Map<String, dynamic> contentSubjectList = {};

  TeacherContentService();

  Future<Map<String, dynamic>> loadContentSubject(String idSubject) async {

    final url = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$idSubject.json');
    final resp = await http.get(url);

    if(resp.statusCode != 200) {
      print('Error');
    }

    if(json.decode(resp.body) != null) {
      this.contentSubjectList = json.decode(resp.body);
    }


    return this.contentSubjectList;

  }

  Future<void> loadFileContent(String subjectID, String sectionName, String file_name, String file_path) async {

    var url;


    if(file_path == '') {
      final url2 = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$subjectID/$sectionName/$file_name.json');
      final resp = await http.get(url2);

      if(resp.statusCode == 200) {
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

  Future<void> addSection(String subjectId, String section_name) async {

    final url = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$subjectId.json');
    Map<String, dynamic> json_body = {
      section_name: ""
    };
    final resp = await http.patch(url, body: json.encode(json_body));

    if(resp.statusCode != 200) {
      print('Error');
    }

  }

  Future<void> deleteSection(String subjectId, String section_name) async {

    final url = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$subjectId/$section_name.json');
    final resp = await http.get(url);

    if(json.decode(resp.body) != '') {

      Map<String, dynamic> sectionContent = json.decode(resp.body);

      for(final fileName in sectionContent.keys) {
        Reference firebaseStorageReference = FirebaseStorage.instance.ref().child('E-Learn/contenido asignaturas/$subjectId/$section_name/$fileName.pdf');

        print(firebaseStorageReference.fullPath); 

        await firebaseStorageReference.delete();
    }

    }

    final resp2 = await http.delete(url);

    if(resp2.statusCode != 200) {
      print('Error');
    }

  }

  Future<void> editSection(String subjectId, String oldSectionName, String newSectionName) async {

    final url1 = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$subjectId/$oldSectionName.json');
    final resp1 = await http.get(url1);

    if(resp1.statusCode == 200) {
      final section_body = json.decode(resp1.body);

      final url2 = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$subjectId/$oldSectionName.json');
      final resp2 = await http.delete(url2);

      if(section_body == "") {

        final url3 = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$subjectId.json');
        Map<String, dynamic> json_body = {
          newSectionName: ""
        };
        final resp3 = await http.patch(url3, body: json.encode(json_body));

      } else {

        final url3 = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$subjectId/$newSectionName.json');
        final resp3 = await http.patch(url3, body: json.encode(section_body));

      }

    } 

  }

  Future<void> addFileToSection(String subjectId, String sectionName, String fileName, File file) async {

    String url_file = 'void';

    Reference firebaseStorageReference = FirebaseStorage.instance.ref().child('E-Learn/contenido asignaturas/$subjectId/$sectionName/$fileName.pdf');

    UploadTask task = firebaseStorageReference.putFile(file);

    await task.whenComplete(() async {

      String download_url = await firebaseStorageReference.getDownloadURL();

      print('Primero completado');

      await Future.delayed(Duration(seconds: 2));

      final url = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$subjectId/$sectionName.json');
      Map<String, dynamic> url_body = {
        fileName: download_url
      };

      print('Segundo completado');

      final resp = await http.patch(url, body: json.encode(url_body));

      if(resp.statusCode != 200) {
        print('Error');
      }

    });

  }

  Future<String?> getDownloadURLFromFile(String subjectID, String sectionName, String fileName) async {

    final url = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$subjectID/$sectionName/$fileName.json');
    final resp = await http.get(url);

    if(resp.statusCode == 200) {
      return json.decode(resp.body);
    }

    return null;

  }

  Future<void> deleteFile(String subjectID, String sectionName, String fileName) async {

    Reference firebaseStorageReference = FirebaseStorage.instance.ref().child('E-Learn/contenido asignaturas/$subjectID/$sectionName/$fileName.pdf');

    await firebaseStorageReference.delete();

    print('Archivo borrado de Storage');

    final url = Uri.https(_baseUrlSubjects, 'ContenidoAsignatura/$subjectID/$sectionName/$fileName.json');
    final resp = await http.delete(url);

    if(resp.statusCode == 200) {
      print('Archivo borrado de la BD con éxito');
    }

  }

}

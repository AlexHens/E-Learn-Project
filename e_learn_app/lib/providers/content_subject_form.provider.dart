import 'package:flutter/material.dart';

class ContentSubjectFormProvider {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String? isValidForm(String sectionName, Map<String, dynamic> listContent) {
    
    if(sectionName.isEmpty) {
      return 'Por favor, introduzca un nombre válido';
    } else if(listContent.containsKey(sectionName)) {
      return 'Esta sección ya se encuentra añadida';
    }

    return null;
  }

  String? isValidFileForm(String fileName, String sectionName, Map<String, dynamic> listContent) {

    

    if(fileName.isEmpty) {
      return 'Por favor, introduzca un nombre válido';
    } else if(listContent[sectionName] != '' && listContent[sectionName].containsKey(fileName)) {
      return 'Este archivo ya se encuentra añadido';
    }

    return null;

  }

}
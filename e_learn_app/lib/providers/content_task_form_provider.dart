import 'package:flutter/material.dart';

class ContentTaskFormProvider {

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String? isValidFileForm(String fileName, Map<String, dynamic> listSolutions) {

    if(fileName.isEmpty) {
      return 'Por favor, introduzca un nombre válido';
    } else if(listSolutions.containsKey(fileName)) {
      return 'Este archivo ya se encuentra añadido';
    }

    return null;

  }

}
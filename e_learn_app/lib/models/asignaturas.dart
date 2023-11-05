// To parse this JSON data, do
//
//     final usuario = usuarioFromMap(jsonString);

import 'dart:convert';

class Asignatura {
    Asignatura({
        required this.curso,
        required this.descripcion,
        required this.id,
        required this.nombre,
    });

    String curso;
    String descripcion;
    String id;
    String nombre;

    factory Asignatura.fromJson(String str) => Asignatura.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Asignatura.fromMap(Map<String, dynamic> json) => Asignatura(
        curso: json["Curso"],
        descripcion: json["Descripcion"],
        id: json["ID"],
        nombre: json["Nombre"],
    );

    Map<String, dynamic> toMap() => {
        "Curso": curso,
        "Descripcion": descripcion,
        "ID": id,
        "Nombre": nombre,
    };

    Asignatura copy() => Asignatura(
      curso: this.curso,
      descripcion: this.descripcion,
      id: this.id,
      nombre: this.nombre,
    );
}
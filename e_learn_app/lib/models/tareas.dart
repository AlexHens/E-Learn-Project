// To parse this JSON data, do
//
//     final usuario = usuarioFromMap(jsonString);

import 'dart:convert';

class Tarea {
    Tarea({
        required this.descripcion,
        required this.id,
        required this.nombre,
        required this.nombre_asignatura,
    });

    String descripcion;
    String id;
    String nombre;
    String nombre_asignatura;

    factory Tarea.fromJson(String str) => Tarea.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Tarea.fromMap(Map<String, dynamic> json) => Tarea(
        descripcion: json["Descripcion"],
        id: json["ID"],
        nombre: json["Nombre"],
        nombre_asignatura: json['Nombre Asignatura'],
    );

    Map<String, dynamic> toMap() => {
        "Descripcion": descripcion,
        "ID": id,
        "Nombre": nombre,
        "Nombre Asignatura": nombre_asignatura,
    };

    Tarea copy() => Tarea(
      descripcion: this.descripcion,
      id: this.id,
      nombre: this.nombre,
      nombre_asignatura: this.nombre_asignatura,
    );
}
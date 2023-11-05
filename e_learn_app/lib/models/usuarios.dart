// To parse this JSON data, do
//
//     final usuario = usuarioFromMap(jsonString);

import 'dart:convert';

class Usuario {
    Usuario({
        required this.apellidos,
        required this.dni,
        required this.direccion,
        required this.email,
        required this.foto,
        required this.nombre,
        required this.rol,
        required this.telefono,
    });

    String apellidos;
    String dni;
    String direccion;
    String email;
    String foto;
    String nombre;
    String rol;
    double telefono;

    factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        apellidos: json["Apellidos"],
        dni: json["DNI"],
        direccion: json["Direccion"],
        email: json["Email"],
        foto: json["Foto"],
        nombre: json["Nombre"],
        rol: json["Rol"],
        telefono: json["Telefono"].toDouble(),
    );

    Map<String, dynamic> toMap() => {
        "Apellidos": apellidos,
        "DNI": dni,
        "Direccion": direccion,
        "Email": email,
        "Foto": foto,
        "Nombre": nombre,
        "Rol": rol,
        "Telefono": telefono,
    };

    Usuario copy() => Usuario(
      apellidos: this.apellidos,
      dni: this.dni,
      direccion: this.direccion,
      email: this.email,
      foto: this.foto,
      nombre: this.nombre,
      rol: this.rol,
      telefono: this.telefono
    );
}
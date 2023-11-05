// To parse this JSON data, do
//
//     final usuario = usuarioFromMap(jsonString);

import 'dart:convert';

class Mensaje {
    Mensaje({
        required this.emisorID,
        required this.receptorID,
        required this.fechaEnvio,
        required this.contenidoMensaje,
    });

    String emisorID;
    String receptorID;
    int fechaEnvio;
    String contenidoMensaje;

    factory Mensaje.fromJson(String str) => Mensaje.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Mensaje.fromMap(Map<dynamic, dynamic> json) => Mensaje(
        emisorID: json["DNI Emisor"],
        receptorID: json["DNI Receptor"],
        fechaEnvio: json["Fecha Envio"],
        contenidoMensaje: json['Contenido'],
    );

    Map<String, dynamic> toMap() => {
        "DNI Emisor": emisorID,
        "DNI Receptor": receptorID,
        "Fecha Envio": fechaEnvio,
        "Contenido": contenidoMensaje,
    };

    Mensaje copy() => Mensaje(
      emisorID: this.emisorID,
      receptorID: this.receptorID,
      fechaEnvio: this.fechaEnvio,
      contenidoMensaje: this.contenidoMensaje,
    );
}
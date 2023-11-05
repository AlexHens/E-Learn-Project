import 'package:e_learn_app/models/mensajes.dart';
import 'package:e_learn_app/services/chat_service.dart';
import 'package:flutter/material.dart';

import '../data/GlobalData.dart';

class AlumnChatScreen extends StatefulWidget {

  String idEmisor;
  String idReceptor;
  String reference;
  String nombreReceptor;
  String apellidosReceptor;
   
  AlumnChatScreen({Key? key, required this.idEmisor, required this.idReceptor, required this.reference, required this.nombreReceptor, required this.apellidosReceptor}) : super(key: key);

  @override
  State<AlumnChatScreen> createState() => _AlumnChatScreenState();
}

class _AlumnChatScreenState extends State<AlumnChatScreen> {

  TextEditingController _messageController = TextEditingController();
  AdminChatService _adminChatService = AdminChatService();
  GlobalData? dataAdmin = GlobalData.getInstance();

  @override
  void initState() {
    super.initState();
    _adminChatService.loadReferenceToChat(widget.reference);
    _adminChatService.messagesStream.listen((event) {
      final messageData = event.snapshot.value;
      print(messageData);
      if(messageData is Map<dynamic, dynamic>) {
        final sortedMessages = messageData.entries.toList()..sort((a, b) {
          final date1 = a.value['Fecha Envio'] as int;
          final date2 = b.value['Fecha Envio'] as int;
          return date1.compareTo(date2);
        });

        setState(() {
          _adminChatService.messages = sortedMessages.map((entry) {
            return Mensaje.fromMap(entry.value);
          }).toList();
        });
      }
    });
  }

  void _sendMessage() {
    final messageContent = _messageController.text;
    final currentDate = DateTime.now().millisecondsSinceEpoch;
    Mensaje message = Mensaje(emisorID: widget.idEmisor, receptorID: widget.idReceptor, fechaEnvio: currentDate, contenidoMensaje: messageContent);

    _adminChatService.sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        toolbarHeight: 100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 40,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(widget.nombreReceptor + " " + widget.apellidosReceptor, style: TextStyle(fontSize: 30,), textAlign: TextAlign.center, softWrap: true,)
        ),
        actions: [
          
          Padding(  
            padding: EdgeInsets.only(right: 8.0),
            child: Image.asset(
              'assets/E-Learn_logotipo-removebg-preview.png', 
              fit: BoxFit.cover, 
              height: 80.0, 
              width: 80.0,
            ),
          ),

        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: _adminChatService.messages.length,
              itemBuilder: (context, index) {
                final message = _adminChatService.messages[index];

                return GestureDetector(
                  child: Padding(
                    padding: message.emisorID == dataAdmin!.dni ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 70.0) : EdgeInsets.only(top: 8.0, bottom: 8.0, left: 70.0, right: 15.0),
                    child: Align(
                      alignment: message.emisorID == dataAdmin!.dni ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: message.emisorID == dataAdmin!.dni ? Color.fromRGBO(63, 63, 156, 1) : Color.fromRGBO(215, 112, 206, 1),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text(message.contenidoMensaje, style: TextStyle(color: Colors.white, fontSize: 15.0),),
                      ),
                    ),
                  ),
                  onLongPress: () {
                    if(message.emisorID == dataAdmin!.dni) {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Eliminar mensaje'),
                            content: Text('¿Deseas eliminar este mensaje?'),
                            actions: [

                              TextButton(
                                child: Text('Aceptar'),
                                onPressed: () {
                                  _adminChatService.deleteMessage(message.fechaEnvio.toString());
                                  Navigator.of(context).pop();
                                },
                              ),

                              TextButton(
                                child: Text('Cancelar'),
                                onPressed: () {
                                  
                                  Navigator.of(context).pop();
                                },
                              ),

                            ],
                          );
                        }
                      );
                    }
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [

                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Color.fromRGBO(63, 63, 156, 1),
                        width: 2.0
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.0),
                      child: TextField(
                        maxLines: null,
                        controller: _messageController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Escribe un mensaje...'
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10.0,),

                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(63, 63, 156, 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: IconButton(
                      icon: Icon(Icons.send_rounded, color: Colors.white,),
                      onPressed: () {
                        _sendMessage();
                        setState(() {
                          _messageController.clear();
                        });
                      },
                    ),
                  ),
                ),

              ],
            ),
          )

        ],
      )
    );
  }
}
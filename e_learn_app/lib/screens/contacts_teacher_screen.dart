import 'package:e_learn_app/screens/screens.dart';
import 'package:e_learn_app/services/services.dart';
import 'package:flutter/material.dart';

import '../data/GlobalData.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class ContactsTeacherScreen extends StatefulWidget {
   
  const ContactsTeacherScreen({Key? key}) : super(key: key);

  @override
  State<ContactsTeacherScreen> createState() => _ContactsTeacherScreenState();
}

class _ContactsTeacherScreenState extends State<ContactsTeacherScreen> {

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  GlobalData? dataAdmin = GlobalData.getInstance();
  List<Usuario> users = [];
  AdminChatService _adminChatService = AdminChatService();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    print('Se ha iniciado la pantalla');
  }

  Future<void> _fetchUsers() async {

    try {

      final users_aux = await _adminChatService.loadUsers();

      for(final user in users_aux) {
      print(user.nombre);
    }

      setState(() {
        users = users_aux;
      });

    } catch (e) {
      print('Error al obtener los usuarios: $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        toolbarHeight: 60,
        leading: IconButton(
          icon: Icon(Icons.menu_rounded, size: 40,),
          onPressed: () {
            _scaffoldState.currentState?.openDrawer();
          },
        ),
        title: Center(
          child: Text("Contactos", style: TextStyle(fontSize: 30),)
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
      drawer: MenuExpandibleTeacher(),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          if(users.length > 0) {

            print('Users');

            print(users[index].dni);
            print(dataAdmin!.dni);

            if(users[index].dni != dataAdmin!.dni){

              print('Entra');

              final nombre = users[index].nombre;
              final dni = users[index].dni;
              final apellidos = users[index].apellidos;
              final email = users[index].email;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(90, 70, 178, 1),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 3)),
                  ],
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.only(left: 16.0),
                  title: Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 10.0,),
              
                        Text(nombre + " " + apellidos, style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),

                        SizedBox(height: 5.0,),
              
                      ],
                    ),
                  ),
                  onTap: () async {
                    String referenceChatDatabase = await _adminChatService.searchDBReference(dataAdmin!.dni, dni);

                    Navigator.push(context, MaterialPageRoute(builder: (context) => TeacherChatScreen(idEmisor: dataAdmin!.dni, idReceptor: dni, reference: referenceChatDatabase, nombreReceptor: nombre, apellidosReceptor: apellidos,)));

                  },
                )
              );
            } else {
              return Container();
            }

          } 
        },
      ),
    );
  }
}
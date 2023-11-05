import 'package:e_learn_app/models/models.dart';
import 'package:e_learn_app/screens/screens.dart';
import 'package:e_learn_app/services/services.dart';
import 'package:e_learn_app/widgets/expandable_menu.dart';
import 'package:flutter/material.dart';

import '../data/GlobalData.dart';

class UsersAdminScreen extends StatefulWidget {
   
  const UsersAdminScreen({Key? key}) : super(key: key);

  @override
  State<UsersAdminScreen> createState() => _UsersAdminScreenState();
}

class _UsersAdminScreenState extends State<UsersAdminScreen> {

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  GlobalData? dataAlumn = GlobalData.getInstance();
  List<Usuario> users = [];
  AdminUsersService _adminUsersService = AdminUsersService();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    print('Se ha iniciado la pantalla');
  }

  Future<void> _fetchUsers() async {

    try {

      final users_aux = await _adminUsersService.loadUsers();

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
          child: Text("Usuarios", style: TextStyle(fontSize: 30),)
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
      drawer: MenuExpandibleAdmin(),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          if(users.length > 0) {

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
          
                    Text(dni, style: TextStyle(fontSize: 15, color: Colors.white),),

                    SizedBox(height: 5.0,),
          
                  ],
                ),
              ),
              onTap: () async {
                Usuario selectedUser = await _adminUsersService.getUserByID(dni);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewUserInfoAdminScreen(user_info: selectedUser)));
              },
              trailing: Padding(
                padding: EdgeInsets.only(right: 20.0, top: 5.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                    children: [
                
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.white, size: 30.0,),
                        onPressed: () async {
                          Usuario selectedUser = await _adminUsersService.getUserByID(dni);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditUserAdminScreen(user_info: selectedUser)));
                        },
                      ),

                      IconButton(
                        icon: Icon(Icons.delete_forever, color: Colors.white, size: 30.0,),
                        onPressed: () {
                          _adminUsersService.deleteUser(dni, email);

                          setState(() {
                            users.removeAt(index);
                          });
                        },
                      ),
                
                    ],
                  ),
              ),
              ),
            );

          }
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 18.0, right: 15.0),
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddUserAdminScreen()));
            },
            child: Icon(Icons.add, size: 50,),
            backgroundColor: Color.fromRGBO(90, 70, 178, 1),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
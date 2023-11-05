import 'package:e_learn_app/data/GlobalData.dart';
import 'package:e_learn_app/models/models.dart';
import 'package:e_learn_app/screens/screens.dart';
import 'package:e_learn_app/services/services.dart';
import 'package:flutter/material.dart';


class MenuExpandibleAdmin extends StatelessWidget {

  GlobalData? data = GlobalData.getInstance();
  AdminUsersService _adminUserService = AdminUsersService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/E-Learn_logotipo-removebg-preview.png',
              fit: BoxFit.cover, 
              height: 80.0, 
              width: 80.0,
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(63, 63, 156, 1),
            ),
          ),

          SizedBox(height: 15,),

          ListTile(
            title: Text('Asignaturas', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'home_page_admin');
            },
          ),

          SizedBox(height: 15,),

          ListTile(
            title: Text('Usuarios', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'users_admin_screen');
            },
          ),

          SizedBox(height: 15,),

          ListTile(
            title: Text('Contactos', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'contacts_admin_screen');
            },
          ),

          SizedBox(height: 15,),
         
          ListTile(
            title: Text('Perfil', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () async {
              Usuario user = await _adminUserService.getUserByID(data!.dni);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAdminScreen(user_info: user)));
            },
          ),

          SizedBox(height: 30,),
         
          ListTile(
            leading: Icon(Icons.logout_outlined, size: 40, color: Color.fromRGBO(63, 63, 156, 1),),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),

        ],
      ),
    );
  }
}

class MenuExpandibleAlumn extends StatelessWidget {

  GlobalData? data = GlobalData.getInstance();
  AdminUsersService _adminUserService = AdminUsersService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/E-Learn_logotipo-removebg-preview.png',
              fit: BoxFit.cover, 
              height: 80.0, 
              width: 80.0,
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(63, 63, 156, 1),
            ),
          ),

          SizedBox(height: 15,),

          ListTile(
            title: Text('Asignaturas', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'home_page_alumn');
            },
          ),

          SizedBox(height: 15,),

          ListTile(
            title: Text('Tareas', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'task_screen_alumn');
            },
          ),

          SizedBox(height: 15,),

          ListTile(
            title: Text('Contactos', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'contacts_teacher_screen');
            },
          ),

          SizedBox(height: 15,),
         
          ListTile(
            title: Text('Perfil', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () async {
              Usuario user = await _adminUserService.getUserByID(data!.dni);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileAdminScreen(user_info: user)));
            },
          ),

          SizedBox(height: 30,),
         
          ListTile(
            leading: Icon(Icons.logout_outlined, size: 40, color: Color.fromRGBO(63, 63, 156, 1),),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),

        ],
      ),
    );
  }
}

class MenuExpandibleTeacher extends StatelessWidget {

  GlobalData? data = GlobalData.getInstance();
   AdminUsersService _adminUserService = AdminUsersService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/E-Learn_logotipo-removebg-preview.png',
              fit: BoxFit.cover, 
              height: 80.0, 
              width: 80.0,
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(63, 63, 156, 1),
            ),
          ),

          SizedBox(height: 15,),

          ListTile(
            title: Text('Asignaturas', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'home_page_teacher');
            },
          ),

          SizedBox(height: 15,),

          ListTile(
            title: Text('Tareas', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'task_screen_teacher');
            },
          ),

          SizedBox(height: 15,),

          ListTile(
            title: Text('Contactos', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'contacts_teacher_screen');
            },
          ),

          SizedBox(height: 15,),
         
          ListTile(
            title: Text('Perfil', style: TextStyle(fontSize: 25, color: Color.fromRGBO(63, 63, 156, 1))),
            onTap: () async {
              Usuario user = await _adminUserService.getUserByID(data!.dni);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileTeacherScreen(user_info: user)));
            },
          ),

          SizedBox(height: 30,),
         
          ListTile(
            leading: Icon(Icons.logout_outlined, size: 40, color: Color.fromRGBO(63, 63, 156, 1),),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),

        ],
      ),
    );
  }
}

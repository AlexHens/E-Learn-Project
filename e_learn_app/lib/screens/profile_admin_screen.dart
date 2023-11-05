import 'package:flutter/material.dart';

import '../models/models.dart';
import '../widgets/expandable_menu.dart';

class ProfileAdminScreen extends StatefulWidget {

  Usuario user_info;
   
  ProfileAdminScreen({Key? key, required this.user_info}) : super(key: key);

  @override
  State<ProfileAdminScreen> createState() => _ProfileAdminScreenState();
}

class _ProfileAdminScreenState extends State<ProfileAdminScreen> {

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

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
          child: Text("Perfil", style: TextStyle(fontSize: 30),)
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            SizedBox(height: 40.0,),

            Center(
              child: CircleAvatar(
                radius: 80.0,
                backgroundImage: NetworkImage(widget.user_info.foto),
                backgroundColor: Colors.white,
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 50.0),
              child: Container(
                child: Row(
                  children: [
            
                    Text("Nombre: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Color.fromRGBO(63, 63, 156, 1),),),

                    Expanded(child: Text(widget.user_info.nombre, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0,),))
            
                  ],
                ),
              ),
            ),

            Column(
              children: [
                Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 25, endIndent: 16,),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 30.0),
              child: Container(
                child: Row(
                  children: [
            
                    Text("Apellidos: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Color.fromRGBO(63, 63, 156, 1),),),

                    Expanded(child: Text(widget.user_info.apellidos, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0,),))
            
                  ],
                ),
              ),
            ),

            Column(
              children: [
                Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 25, endIndent: 18,),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 30.0),
              child: Container(
                child: Row(
                  children: [
            
                    Text("DNI: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Color.fromRGBO(63, 63, 156, 1),),),

                    Expanded(child: Text(widget.user_info.dni, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0,),))
            
                  ],
                ),
              ),
            ),

            Column(
              children: [
                Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 25, endIndent: 16,),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 30.0),
              child: Container(
                child: Row(
                  children: [
            
                    Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Color.fromRGBO(63, 63, 156, 1),),),

                    Expanded(child: Text(widget.user_info.email, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0,),))
            
                  ],
                ),
              ),
            ),

            Column(
              children: [
                Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 25, endIndent: 16,),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 30.0),
              child: Container(
                child: Row(
                  children: [
            
                    Text("Dirección: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Color.fromRGBO(63, 63, 156, 1),),),

                    Expanded(child: Text(widget.user_info.direccion, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0,),))
            
                  ],
                ),
              ),
            ),

            Column(
              children: [
                Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 25, endIndent: 16,),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 30.0),
              child: Container(
                child: Row(
                  children: [
            
                    Text("Teléfono: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Color.fromRGBO(63, 63, 156, 1),),),

                    Expanded(child: Text(widget.user_info.telefono.toString().split(".")[0], style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0,),))
            
                  ],
                ),
              ),
            ),

            Column(
              children: [
                Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 25, endIndent: 16,),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 30.0, top: 30.0),
              child: Container(
                child: Row(
                  children: [
            
                    Text("Rol: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Color.fromRGBO(63, 63, 156, 1),),),

                    Expanded(child: Text(widget.user_info.rol, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20.0,),))
            
                  ],
                ),
              ),
            ),

            Column(
              children: [
                Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 25, endIndent: 16,),
              ],
            ),

            SizedBox(height: 40.0,),

          ],
        ),
      )
    );
  }
}
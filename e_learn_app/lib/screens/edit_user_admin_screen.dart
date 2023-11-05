import 'dart:io';

import 'package:e_learn_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/models.dart';
import '../ui/input_decorations.dart';

class EditUserAdminScreen extends StatefulWidget {

  Usuario user_info;
   
  EditUserAdminScreen({Key? key, required this.user_info}) : super(key: key);

  @override
  State<EditUserAdminScreen> createState() => _EditUserAdminScreenState();
}

class _EditUserAdminScreenState extends State<EditUserAdminScreen> {

  String userName = '';
  String userLastName = '';
  String dni = '';
  String email = '';
  String direccion = '';
  String telefono = '';
  String? rol = 'Rol';
  File? _selectedImage = null;

  AdminUsersService _adminUsersService = AdminUsersService();

  Future<void> _pickImage(ImageSource source) async {

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if(pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }

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
          child: Text('Editar Usuario', style: TextStyle(fontSize: 30,), textAlign: TextAlign.center, softWrap: true,)
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
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          color: Color.fromARGB(255, 235, 234, 234),
          child: ListView(
            children: [

              SizedBox(height: 30.0,),

              Center(
                child: Text("Datos del usuario", style: TextStyle(color: Color.fromRGBO(90, 70, 178, 1), fontSize: 30.0, fontWeight: FontWeight.bold)),
                
              ),

              Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 16, endIndent: 16,),
      
              SizedBox(height: 20,),

              CircleAvatar(
                backgroundColor: Colors.white60,
                radius: 70.0,
                child: ClipOval(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: _selectedImage != null
                                ? Image.file(_selectedImage!).image
                                : NetworkImage(widget.user_info.foto),
                        fit: BoxFit.cover
                      )
                    ),
                  )
                ),
              ),

              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    }, 
                    child: Icon(Icons.camera_alt, size: 30.0,),
                    style: ElevatedButton.styleFrom(shape: CircleBorder(), primary: Color.fromRGBO(90, 70, 178, 1), padding: EdgeInsets.all(20.0)),
                  ),

                  SizedBox(width: 20,),

                  ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    }, 
                    child: Icon(Icons.image, size: 30.0,),
                    style: ElevatedButton.styleFrom(shape: CircleBorder(), primary: Color.fromRGBO(90, 70, 178, 1), padding: EdgeInsets.all(20.0)),
                  ),

                ],
              ),
              
              SizedBox(height: 20,),

              Container(
                height: 65,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Color.fromRGBO(90, 70, 178, 1)),
                  boxShadow: [
                  BoxShadow(color: Colors.white60.withOpacity(0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 3))
                ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.subjectInputDecoration(
                      hintText: '', 
                      labelText: widget.user_info.nombre, 
                      prefixIcon: Icons.person_2_rounded,
                    ),
                    onChanged: (value) => userName = value,
                    validator: (value) {
                      return (value != '') ? null : '\t\tEl nombre debe estar completo';
                    },
                  ),
                ),
              ),

              Container(
                height: 65,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Color.fromRGBO(90, 70, 178, 1)),
                  boxShadow: [
                  BoxShadow(color: Colors.white60.withOpacity(0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 3))
                ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.subjectInputDecoration(
                      hintText: '', 
                      labelText: widget.user_info.apellidos, 
                      prefixIcon: Icons.person_2_rounded,
                    ),
                    onChanged: (value) => userLastName = value,
                    validator: (value) {
                      return (value != '') ? null : '\t\tEl apellido debe estar completo';
                    },
                  ),
                ),
              ),

              Container(
                height: 65,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Color.fromRGBO(90, 70, 178, 1)),
                  boxShadow: [
                  BoxShadow(color: Colors.white60.withOpacity(0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 3))
                ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    autocorrect: false,
                    enabled: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.subjectInputDecoration(
                      hintText: '', 
                      labelText: widget.user_info.dni, 
                      prefixIcon: Icons.person_2_rounded,
                    ),
                    onChanged: (value) => dni = value,
                    validator: (value) {
                      return (value != '') ? null : '\t\tEl DNI debe estar completo';
                    },
                  ),
                ),
              ),

              Container(
                height: 65,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Color.fromRGBO(90, 70, 178, 1)),
                  boxShadow: [
                  BoxShadow(color: Colors.white60.withOpacity(0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 3))
                ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.subjectInputDecoration(
                      hintText: '', 
                      labelText: widget.user_info.email, 
                      prefixIcon: Icons.person_2_rounded,
                    ),
                    onChanged: (value) => email = value,
                    validator: (value) {
                      return (value != '') ? null : '\t\tEl email debe estar completo';
                    },
                  ),
                ),
              ),

              Container(
                height: 65,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Color.fromRGBO(90, 70, 178, 1)),
                  boxShadow: [
                  BoxShadow(color: Colors.white60.withOpacity(0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 3))
                ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.subjectInputDecoration(
                      hintText: '', 
                      labelText: widget.user_info.direccion, 
                      prefixIcon: Icons.person_2_rounded,
                    ),
                    onChanged: (value) => direccion = value,
                    validator: (value) {
                      return (value != '') ? null : '\t\tLa dirección debe estar completa';
                    },
                  ),
                ),
              ),

              Container(
                height: 65,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Color.fromRGBO(90, 70, 178, 1)),
                  boxShadow: [
                  BoxShadow(color: Colors.white60.withOpacity(0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 3))
                ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecorations.subjectInputDecoration(
                      hintText: '', 
                      labelText: widget.user_info.telefono.toString().split('.')[0], 
                      prefixIcon: Icons.person_2_rounded,
                    ),
                    onChanged: (value) => telefono = value,
                    validator: (value) {
                      return (value != '') ? null : '\t\tEl teléfono debe estar completo';
                    },
                  ),
                ),
              ),

              Container(
                height: 65,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Color.fromRGBO(90, 70, 178, 1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white60.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 3)
                    )
                  ]
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 30.0, top: 5.0),
                  child: DropdownButton(
                    value: widget.user_info.rol,
                    onChanged: (String? newValue) {
                      setState(() {
                        rol = newValue;
                      });
                    },
                    items: <String>['Rol', 'Profesor', 'Alumno', 'Administrador']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value, style: TextStyle(color: Colors.grey[500]),)
                      );
                    }).toList(), 
                  ),
                ),
              ),

              SizedBox(height: 30,),

              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
              
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20)
                      ),
                      child: Text('Cancelar', style: TextStyle(fontSize: 15),),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
              
                    SizedBox(width: 30.0,),
              
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20)
                      ),
                      child: Text('Editar', style: TextStyle(fontSize: 15),),
                      onPressed: () async {

                        String downloadUrl = widget.user_info.foto;

                        if(_selectedImage != null) {
                          downloadUrl = await _adminUsersService.editUserImage(_selectedImage!, widget.user_info.dni);
                        }

                        if(userName == '') {
                          userName = widget.user_info.nombre;
                        }

                        if(userLastName == '') {
                          userLastName = widget.user_info.apellidos;
                        }

                        if(dni == '') {
                          dni = widget.user_info.dni;
                        }

                        if(email != '') {

                          await _adminUsersService.changeLogin(email, widget.user_info.dni);

                        } else {
                          email = widget.user_info.email;
                        }

                        if(direccion == '') {
                          direccion = widget.user_info.direccion;
                        }

                        if(telefono == '') {
                          telefono = widget.user_info.telefono.toString().split('.')[0];
                        }

                        if(rol == 'Rol') {
                          rol = widget.user_info.rol;
                        }

                        await _adminUsersService.editUser(downloadUrl, userName, userLastName, dni, email, direccion, telefono, rol!);

                        Navigator.pushReplacementNamed(context, 'users_admin_screen');
                        
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30,),

            ],
          ),
        ),
      ),
    );
  }
}
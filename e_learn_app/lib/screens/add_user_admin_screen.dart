import 'dart:io';

import 'package:e_learn_app/main.dart';
import 'package:e_learn_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../ui/input_decorations.dart';

class AddUserAdminScreen extends StatefulWidget {
   
  const AddUserAdminScreen({Key? key}) : super(key: key);

  @override
  State<AddUserAdminScreen> createState() => _AddUserAdminScreenState();
}

class _AddUserAdminScreenState extends State<AddUserAdminScreen> {

  String userName = '';
  String userLastName = '';
  String dni = '';
  String email = '';
  String direccion = '';
  String telefono = '';
  String? rol = 'Rol';
  File? selectedImage = null;

  AdminUsersService _adminUsersService = AdminUsersService();

  Future<void> _pickImage(ImageSource source) async {

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if(pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
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
          child: Text('Añadir Usuario', style: TextStyle(fontSize: 30,), textAlign: TextAlign.center, softWrap: true,)
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
                        image: selectedImage != null
                                ? Image.file(selectedImage!).image
                                : AssetImage('assets/avatar-placeholder.png'),
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
                      labelText: 'Nombre del usuario', 
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
                      labelText: 'Apellidos del usuario', 
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
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.subjectInputDecoration(
                      hintText: '', 
                      labelText: 'DNI del usuario', 
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
                      labelText: 'Email del usuario', 
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
                      labelText: 'Dirección del usuario', 
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
                      labelText: 'Teléfono del usuario', 
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
                    value: rol,
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
                      child: Text('Añadir', style: TextStyle(fontSize: 15),),
                      onPressed: () async {

                        if(selectedImage != null && userName != '' && userLastName != '' && dni != '' && direccion != '' && telefono != '' && rol != 'Rol') {
                           await _adminUsersService.addUser(selectedImage!, userName, userLastName, dni, email, direccion, telefono, rol!);

                          // await Future.delayed(Duration(seconds: 5));

                          Navigator.pushReplacementNamed(context, 'users_admin_screen');
                        }
                        
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
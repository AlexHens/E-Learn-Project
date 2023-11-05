import 'package:e_learn_app/models/asignaturas.dart';
import 'package:e_learn_app/screens/screens.dart';
import 'package:flutter/material.dart';

import '../services/services.dart';
import '../ui/input_decorations.dart';

class AddSubjectScreen extends StatelessWidget {
   
  AddSubjectScreen({Key? key}) : super(key: key);

  String idSubject = '';
  String nameSubject = '';
  String descriptionSubject = '';
  String gradeSubject = '';
  AdminSubjectService _adminSubjectService = AdminSubjectService();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        toolbarHeight: 60,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 40,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text("Añadir Asignatura", style: TextStyle(fontSize: 25),)
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
              SizedBox(height: 30,),
      
              Padding(
                padding: EdgeInsets.only(left: 100.0),
                child: Text("Datos de la asignatura", style: TextStyle(color: Color.fromRGBO(90, 70, 178, 1), fontSize: 30.0, fontWeight: FontWeight.bold)),
              ),
              
              Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 16, endIndent: 16,),
      
              SizedBox(height: 40,),
          
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
                      labelText: 'Nombre de la asignatura', 
                      prefixIcon: Icons.menu_book_sharp,
                    ),
                    onChanged: (value) => nameSubject = value,
                    validator: (value) {
                      return (value != '') ? null : '\t\tEl nombre debe estar completo';
                    },
                  ),
                ),
              ),
        
              SizedBox(height: 10,),
          
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
                      labelText: 'Identificador de la asignatura', 
                      prefixIcon: Icons.info_outlined,
                    ),
                    onChanged: (value) => idSubject = value,
                    validator: (value) {
                      return (value != '') ? null : '\t\tEl identificador debe estar completo';
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
                      labelText: 'Curso de la asignatura', 
                      prefixIcon: Icons.format_list_numbered_rounded,
                    ),
                    onChanged: (value) => gradeSubject = value,
                    validator: (value) {
                      return (value != '') ? null : '\t\tEl curso debe estar completo';
                    },
                  ),
                ),
              ),

              SizedBox(height: 10,),
          
              Container(
                height: 300,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Color.fromRGBO(90, 70, 178, 1)),
                  boxShadow: [
                  BoxShadow(color: Colors.white.withOpacity(0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 3))
                ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecorations.subjectInputDecoration(
                      hintText: '', 
                      labelText: 'Descripción de la asignatura', 
                      prefixIcon: Icons.description_rounded,
                    ),
                    onChanged: (value) => descriptionSubject = value,
                    validator: (value) {
                      return (value != '') ? null : '\t\tLa descripción debe estar completa';
                    },
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
                      child: Text('Siguiente', style: TextStyle(fontSize: 15),),
                      onPressed: () async {
                        print(idSubject);
                        print(nameSubject);
                        print(descriptionSubject);

                        if(idSubject != '' && nameSubject != '' && descriptionSubject != '' && gradeSubject != '') {

                          Asignatura? subject = await _adminSubjectService.searchSubject(idSubject);

                          if(subject == null) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AsignTeacherToSubjectScreen(id: idSubject, name: nameSubject, description: descriptionSubject, grade: gradeSubject)));
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Asignatura ya existente'),
                                  content: Text('La asignatura con ID $idSubject ya ha sido registrada'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Aceptar'),
                                    )
                                  ],
                                );
                              }
                            );
                          }
                          
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

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
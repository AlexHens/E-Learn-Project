import 'dart:io';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/services.dart';
import '../ui/input_decorations.dart';

class AsignAlumnTaskScreen extends StatefulWidget {
  
  String taskName = '';
  String name = '';
  String idTask = '';
  String grade = '';
  String description = '';
  Map<String, File> fileList = {};
  List<String> alumnList = [];
  
  TextEditingController _textController = TextEditingController();
  TeacherTaskService _teacherTaskService = TeacherTaskService();
   
  AsignAlumnTaskScreen({Key? key, required this.taskName, required this.name, required this.idTask, required this.grade, required this.description, required this.fileList}) : super(key: key);

  @override
  State<AsignAlumnTaskScreen> createState() => _AsignAlumnTaskScreenState();
}

class _AsignAlumnTaskScreenState extends State<AsignAlumnTaskScreen> {


  Future<void> onSearchButtonPressed(String alumnID) async {

    if(alumnID.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('DNI vacío'),
            content: Text('Por favor, introduzca un DNI en el buscador'),
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

      return;
    }

    Usuario? alumnIdResult = await widget._teacherTaskService.searchAlumn(alumnID);

    if(alumnIdResult != null && !alumnID.isEmpty) {
      if(widget.alumnList.contains(alumnIdResult)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alumno ya introducido'),
              content: Text('El alumno con ID $alumnID ya ha sido matriculado en esta asignatura'),
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
      } else {
        setState(() {
          widget.alumnList.add(alumnIdResult.dni);
        });
      }
      
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alumno no encontrado'),
            content: Text('El alumno con ID $alumnID no existe'),
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

  void unasignTeacher(int index) {
    setState(() {
      widget.alumnList.removeAt(index);
    });
  }

   @override
  void dispose(){
    widget._textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        toolbarHeight: 60,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 40,),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'task_screen_teacher');
          },
        ),
        title: Center(
          child: Text("Añadir Tarea", style: TextStyle(fontSize: 25),)
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [

            SizedBox(height: 30,),

            Center(child: Text("Asignar alumno a la tarea", style: TextStyle(color: Color.fromRGBO(90, 70, 178, 1), fontSize: 30.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),

            Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 16, endIndent: 16,),

            SizedBox(height: 40,),

            Row(
              children: [
                Expanded(
                  child: Container(
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
                    child: TextFormField(
                      controller: widget._textController,
                      decoration: InputDecorations.subjectInputDecoration(
                        hintText: '', 
                        labelText: 'DNI del alumno',
                        prefixIcon: Icons.person_pin_rounded
                      ),
                    ),
                  ),
                ),
                // SizedBox(width: 10.0,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Color.fromRGBO(90, 70, 178, 1),
                  ),
                  onPressed: () {
                    String alumnID = widget._textController.text;
                    print(alumnID);
                    onSearchButtonPressed(alumnID);
                  },
                  child: Icon(Icons.search_rounded,),
                ),
              ],
            ),

            Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 16, endIndent: 16,),
  
            SizedBox(height: 40,),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.alumnList.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(vertical:8.0, horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(90, 70, 178, 1),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0, 3))
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 3.0),
                          child: Text(widget.alumnList[index], style: TextStyle(fontSize: 25,color: Colors.white)),
                        ),

                        Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: IconButton(
                            icon: Icon(Icons.delete_rounded, size: 30.0, color: Colors.white,),
                            onPressed: () {
                              unasignTeacher(index);
                            },
                          ),
                        ),

                      ],
                    ),
                  );
                },
              )
            ),

            SizedBox(height: 20,),

            Center(
              child: Container(
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
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                      ),
                      child: Text('Cancelar', style: TextStyle(fontSize: 15),),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, 'task_screen_teacher');
                      },
                    ),
              
                    SizedBox(width: 40.0,),
                
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20)
                      ),
                      child: Text('Siguiente', style: TextStyle(fontSize: 15),),
                      onPressed: () async {
                        if(widget.alumnList.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Lista vacía'),
                                content: Text('Debes matricular al menos a un alumno en la asignatura'),
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
                        } else {

                          String? resp = await widget._teacherTaskService.addTask(widget.idTask, widget.taskName, widget.name, widget.description, widget.fileList, widget.alumnList);

                          if(resp == null) {
                            print('Error');
                          } else {
                            Navigator.pushReplacementNamed(context, 'task_screen_teacher');
                          }
              
                        }
                      },
                    ),
                
                  ],
                ),
              ),
            )

          ],
        ),
      )
    );
  }
}
import 'dart:io';

import 'package:e_learn_app/screens/screens.dart';
import 'package:e_learn_app/services/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../ui/input_decorations.dart';

class AddFileTaskScreen extends StatefulWidget {

  String taskName = '';
  String name = '';
  String idTask = '';
  String grade = '';
  String description = '';

  Map<String, File> fileList = {};
  TextEditingController _textController = TextEditingController();
  TeacherTaskService _teacherTaskService = TeacherTaskService();
   
  AddFileTaskScreen({Key? key, required this.taskName, required this.name, required this.idTask, required this.grade, required this.description}) : super(key: key);

  @override
  State<AddFileTaskScreen> createState() => _AddFileTaskScreenState();
}

class _AddFileTaskScreenState extends State<AddFileTaskScreen> {

  @override
  void dispose() {
    widget._textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    File? taskFile = null;
    String taskName = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        toolbarHeight: 60,
        leading: IconButton(
          icon: Icon(Icons.home_rounded, size: 40,),
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

            Center(child: Text("Añadir archivos a la tarea", style: TextStyle(color: Color.fromRGBO(90, 70, 178, 1), fontSize: 30.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),

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
                        labelText: 'Nombre del archivo asociado',
                        prefixIcon: Icons.task_rounded
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
                  onPressed: () async {

                    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

                    if(fileResult != null) {
                      taskFile = File(fileResult.files.single.path!);
                    }
                  },
                  child: Icon(Icons.file_present_rounded,),
                ),

              ],
            ),

            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 10.0, bottom: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    backgroundColor: Color.fromRGBO(90, 70, 178, 1),
                  ),
                  onPressed: () {

                    taskName = widget._textController.text;

                    if(taskName.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Nombre vacío'),
                            content: Text('Debes especificar un nombre para el archivo'),
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
                    } else if(taskFile == null) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Archivo vacío'),
                            content: Text('Debes seleccionar un archivo para subir'),
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
                        widget.fileList[taskName] = taskFile!;
                      });

                    }

                  },
                  child: Text('Añadir documento'),
                ),
              ),
            ),

            Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 16, endIndent: 16,),
    
            SizedBox(height: 40,),

            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.fileList.length,
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
                          child: Text(widget.fileList.entries.elementAt(index).key, style: TextStyle(fontSize: 25,color: Colors.white)),
                        ),
      
                        Padding(
                          padding: EdgeInsets.only(right: 15.0),
                          child: IconButton(
                            icon: Icon(Icons.delete_rounded, size: 30.0, color: Colors.white,),
                            onPressed: () {
                              
                              setState(() {
                                widget.fileList.remove(widget.fileList.entries.elementAt(index).key);
                              });

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
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AsignAlumnTaskScreen(taskName: widget.taskName, name: widget.name, idTask: widget.idTask, grade: widget.grade, description: widget.description, fileList: widget.fileList)));
                      },
                    ),
                
                  ],
                ),
              ),
            )
            
          ],
        ),
      ),
    );
  }
}
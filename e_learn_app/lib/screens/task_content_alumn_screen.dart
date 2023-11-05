import 'dart:io';

import 'package:e_learn_app/services/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../providers/content_subject_form.provider.dart';
import '../providers/content_task_form_provider.dart';
import '../ui/input_decorations.dart';

class TaskContentAlumnScreen extends StatefulWidget {

  Tarea task_info;
   
  TaskContentAlumnScreen({Key? key, required this.task_info}) : super(key: key);

  @override
  State<TaskContentAlumnScreen> createState() => _TaskContentAlumnScreenState();
}

class _TaskContentAlumnScreenState extends State<TaskContentAlumnScreen> {

  AlumnContentTaskService _alumnContentTaskService = AlumnContentTaskService();
  Map<String, dynamic> listFileTask = {};
  Map<String, dynamic> listSolutionTask = {};
  TextEditingController _textFieldController = TextEditingController(text: '');
  ContentTaskFormProvider _contentForm = ContentTaskFormProvider();
  int calification = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

    Map<String, dynamic> filesTask = await _alumnContentTaskService.loadTaskFiles(widget.task_info.id);
    Map<String, dynamic> solutionsTask = await _alumnContentTaskService.loadTaskSolutions(widget.task_info.id);
    int cal = await _alumnContentTaskService.getCalification(widget.task_info.id);

    setState(() {
      listFileTask = filesTask;
      listSolutionTask = solutionsTask;
      calification = cal;
    });

  }

  void addFileToSolutionUI(String idTask) {
    
    File? selectedFile = null;

    showDialog(
      context: context, 
      builder: (BuildContext context) {

        _textFieldController.text = '';

        return AlertDialog(
          title: Center(child: Text('Añadir un nuevo archivo a la solución de la tarea')),
          content: Form(
            key: _contentForm.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextFormField(
                  controller: _textFieldController,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: '', 
                    labelText: 'Nombre del archivo',
                  ),
                  validator: (value) => _contentForm.isValidFileForm(value!, listSolutionTask),
                ),

                SizedBox(height: 20.0,),

                ElevatedButton(
                  onPressed: () async {
                    
                    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

                    if(fileResult != null) {
                      selectedFile = File(fileResult.files.single.path!);
                    }

                  }, 
                  child: Text('Seleccionar archivo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(63, 63, 156, 1),
                  )
                ),

                SizedBox(height: 20.0,),

                Padding(
                  padding: EdgeInsets.only(left: 35.0),
                  child: Row(
                    children: [
                  
                      ElevatedButton(
                        onPressed: () async {
                          
                          if(_contentForm.formKey.currentState!.validate()) {

                            String fileName = _textFieldController.text;

                            if(selectedFile != null) {

                              _alumnContentTaskService.addFileToSolution(idTask, fileName, selectedFile!);
                              String? url_file = _alumnContentTaskService.getDownloadURLFromFile(idTask, fileName).toString();

                              if(url_file != null) {

                                setState(() {
                                  listSolutionTask[fileName] = '';
                                });

                              }

                            }

                            _textFieldController.text = '';
                            Navigator.of(context).pop();
                          }    
                          
                        }, 
                        child: Text('Aceptar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(63, 63, 156, 1),
                        ),
                      ),
                
                      SizedBox(width: 15.0,),
                  
                      ElevatedButton(
                        onPressed: () {
                          _textFieldController.text = '';
                          Navigator.of(context).pop();
                        }, 
                        child: Text('Cancelar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(63, 63, 156, 1),
                        ),
                      ),
              
                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      }
    );

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
          child: Text(widget.task_info.nombre, style: TextStyle(fontSize: 30,), textAlign: TextAlign.center, softWrap: true,)
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [

                SizedBox(height: 30,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Container(
                      child: Text(widget.task_info.nombre, style: TextStyle(color: Color.fromRGBO(90, 70, 178, 1), fontSize: 40.0, fontWeight: FontWeight.bold))
                    ),
                  ),
                ),

                Column(
                  children: [
                    Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2, indent: 16, endIndent: 16,),
                  ],
                ),

                SizedBox(height: 20,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      child: Text(
                        widget.task_info.nombre_asignatura,
                        style: TextStyle(fontSize: 25.0, color: Color.fromRGBO(90, 70, 178, 1), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),


                Column(
                  children: [
                    Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2.5, indent: 16, endIndent: 16,),
                  ],
                ),

                SizedBox(height: 20,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      child: Text(
                        widget.task_info.descripcion,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2.5, indent: 16, endIndent: 16,),
                  ],
                ),

                SizedBox(height: 20,),


              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {

                if(index < listFileTask.entries.length) {

                  final contentEntry = listFileTask.entries.elementAt(index);
                  final fileName = contentEntry.key;
                  final fileURL = contentEntry.value;

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
                        padding: EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.0,),
                            Text(fileName, style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.0,),
                          ],
                        ),
                      ),
                      onTap: () async { 
                        _alumnContentTaskService.loadFileContent(widget.task_info.id, fileName, fileURL);
                      },
                    ),
                  );
                }
              }
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [

                Column(
                  children: [
                    Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2.5, indent: 16, endIndent: 16,),
                  ],
                ),

                SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          child: Text(
                            'Solución',
                            style: TextStyle(fontSize: 25.0, color: Color.fromRGBO(90, 70, 178, 1), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        onPressed: () {
                          addFileToSolutionUI(widget.task_info.id);
                        }, 
                        icon: Icon(Icons.add_circle_outline_outlined, size: 30.0, color: Color.fromRGBO(90, 70, 178, 1),)
                      ),
                    )

                  ],
                ),

                Column(
                  children: [
                    Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2.5, indent: 16, endIndent: 16,),
                  ],
                ),

              ],
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {

                if(index < listSolutionTask.entries.length) {

                  final contentEntry = listSolutionTask.entries.elementAt(index);
                  final fileName = contentEntry.key;
                  final fileURL = contentEntry.value;

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
                        padding: EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.0,),
                            Text(fileName, style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.0,),
                          ],
                        ),
                      ),
                      onTap: () async { 
                        await Future.delayed(Duration(seconds: 3));
                        _alumnContentTaskService.loadFileContent(widget.task_info.id, fileName, fileURL);
                      },
                      trailing: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          onPressed: () {
                            _alumnContentTaskService.deleteFile(widget.task_info.id, fileName);
                            setState(() {
                              listSolutionTask.remove(fileName);
                            });
                          }, 
                          icon: Icon(Icons.delete_forever, color: Colors.white, size: 30.0,)
                        ),
                      ),
                    ),
                  );
                }
              }
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [

                Column(
                  children: [
                    Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2.5, indent: 16, endIndent: 16,),
                  ],
                ),

                SizedBox(height: 20,),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      child: Text(
                        'Calificación',
                        style: TextStyle(fontSize: 25.0, color: Color.fromRGBO(90, 70, 178, 1), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2.5, indent: 16, endIndent: 16,),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(90, 70, 178, 1),
                      ),
                      child: Center(child: Text(calification.toString() , style: TextStyle(fontSize: 30.0, color: Colors.white),)),
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
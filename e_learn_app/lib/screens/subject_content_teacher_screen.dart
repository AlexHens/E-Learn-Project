import 'dart:io';

import 'package:e_learn_app/providers/content_subject_form.provider.dart';
import 'package:e_learn_app/services/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../ui/input_decorations.dart';

class SubjectContentTeacherScreen extends StatefulWidget {

  Asignatura subject_info;
   
  SubjectContentTeacherScreen({Key? key, required this.subject_info}) : super(key: key);

  @override
  State<SubjectContentTeacherScreen> createState() => _SubjectContentTeacherScreenState();
}

class _SubjectContentTeacherScreenState extends State<SubjectContentTeacherScreen> {

  TeacherContentService _teacherContentService = TeacherContentService();
  TextEditingController _textFieldController = TextEditingController(text: '');
  ContentSubjectFormProvider _contentForm = ContentSubjectFormProvider();
  Map<String, dynamic> listContent = {};


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {

    Map<String, dynamic> data = await _teacherContentService.loadContentSubject(widget.subject_info.id);

    setState(() {
      listContent = data;
    });

  }

  void addSectionUI() {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añadir Sección'),
          content: Form(
            key: _contentForm.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextFormField(
                  controller: _textFieldController,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: '', 
                    labelText: 'Nombre de la sección',
                  ),
                  validator: (value) => _contentForm.isValidForm(value!, listContent),
                ),

                SizedBox(height: 20.0,),

                Padding(
                  padding: EdgeInsets.only(left: 35.0),
                  child: Row(
                    children: [
                  
                      ElevatedButton(
                        onPressed: () {
                          
                          if(_contentForm.formKey.currentState!.validate()) {

                            String nameSection = _textFieldController.text;

                            print(nameSection);

                            _teacherContentService.addSection(widget.subject_info.id, nameSection);

                            setState(() {
                              listContent[nameSection] = "";
                            });

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
    ).then((_) {
      _textFieldController.text = '';
    });
  }

  void editSectionUI(String oldName) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {

        _textFieldController.text = oldName;

        return AlertDialog(
          title: Text('Editar Sección'),
          content: Form(
            key: _contentForm.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextFormField(
                  controller: _textFieldController,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: '', 
                    labelText: 'Nombre de la sección',
                  ),
                  validator: (value) => _contentForm.isValidForm(value!, listContent),
                ),

                SizedBox(height: 20.0,),

                Padding(
                  padding: EdgeInsets.only(left: 35.0),
                  child: Row(
                    children: [
                  
                      ElevatedButton(
                        onPressed: () {
                          
                          if(_contentForm.formKey.currentState!.validate()) {

                            String nameSection = _textFieldController.text;

                            print(nameSection);

                            _teacherContentService.editSection(widget.subject_info.id, oldName, nameSection);

                            setState(() {
                              listContent[nameSection] = listContent[oldName];
                              listContent.remove(oldName);
                            });

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

  void addFileToSectionUI(String sectionName, String subjectID) {

    File? selectedFile = null;

    showDialog(
      context: context, 
      builder: (BuildContext context) {

        _textFieldController.text = '';

        return AlertDialog(
          title: Text('Añadir nuevo archivo a la sección'),
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
                  validator: (value) => _contentForm.isValidFileForm(value!, sectionName, listContent),
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

                              _teacherContentService.addFileToSection(subjectID, sectionName, fileName, selectedFile!).toString();
                              String? url_file = _teacherContentService.getDownloadURLFromFile(subjectID, sectionName, fileName).toString();

                              if(url_file != null) {

                                setState(() {
                                  if(listContent[sectionName] == '') {
                                    listContent[sectionName] = {};
                                  }
                                  listContent[sectionName][fileName] = '';
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
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 40,)
        ),
        title: Center(
          child: Text(widget.subject_info.nombre, style: TextStyle(fontSize: 30,), textAlign: TextAlign.center, softWrap: true,)
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
                      child: Text(widget.subject_info.nombre, style: TextStyle(color: Color.fromRGBO(90, 70, 178, 1), fontSize: 40.0, fontWeight: FontWeight.bold))
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
                        widget.subject_info.descripcion,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
            
                SizedBox(height: 20,),
            
                Column(
                  children: [
                    Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2.5, indent: 16, endIndent: 16,),
                  ],
                ),

              ],
            )
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext contex, int index) {
                final contentEntry = listContent.entries.elementAt(index);
                final sectionName = contentEntry.key;
                Map<dynamic, dynamic> sectionContent = {};

                if(contentEntry.value != ""){
                  print('Valor que quiero ver');
                  print(contentEntry.value);
                  sectionContent = contentEntry.value;
                }

                return Card(
                  child: Column(
                    children: [

                      SizedBox(height: 30,),

                      Row(
                        children: [

                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.0,),
                                child: Container(
                                  child: Text(
                                    sectionName,
                                    style: TextStyle(
                                      color: Color.fromRGBO(90, 70, 178, 1),
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          TextButton.icon(
                            onPressed: () {
                              addFileToSectionUI(sectionName, widget.subject_info.id);
                            }, 
                            icon: Icon(Icons.add, color: Color.fromRGBO(90, 70, 178, 1),),
                            label: Text(""),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              alignment: Alignment.center
                            ),
                          ),

                          TextButton.icon(
                            onPressed: () {
                              editSectionUI(sectionName);
                            }, 
                            icon: Icon(Icons.edit, color: Color.fromRGBO(90, 70, 178, 1),),
                            label: Text(""),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              alignment: Alignment.center
                            ),
                          ),

                          TextButton.icon(
                            onPressed: () {
                              _teacherContentService.deleteSection(widget.subject_info.id, sectionName);

                              setState(() {
                                listContent.remove(sectionName);
                              });
                            }, 
                            icon: Icon(Icons.delete, color: Color.fromRGBO(90, 70, 178, 1),),
                            label: Text(""),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              alignment: Alignment.center
                            ),
                          ),

                        ],
                      ),

                      Column(
                        children: [
                          Divider(color: Color.fromRGBO(90, 70, 178, 1), thickness: 2.5, indent: 16, endIndent: 16,),
                        ],
                      ),

                      SizedBox(height: 20,),

                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: sectionContent.entries.map((entry) {
                              return Container(
                                height: 65,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(90, 70, 178, 1),
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 4, offset: Offset(0,3))
                                  ]
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    GestureDetector(
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 16.0, top: 5.0, ),
                                        child: Text(entry.key, style: TextStyle(fontSize: 25, color: Colors.white),),
                                      ),
                                      onTap: () async {

                                        await Future.delayed(Duration(seconds: 3));

                                        _teacherContentService.loadFileContent(widget.subject_info.id, sectionName, entry.key, entry.value);
                                      },
                                    ),

                                    Padding(
                                      padding: EdgeInsets.only(right: 20.0, top: 5.0),
                                      child: IconButton(
                                        onPressed: () {
                                          _teacherContentService.deleteFile(widget.subject_info.id, sectionName, entry.key);
                                          setState(() {
                                            sectionContent.remove(entry.key);
                                          });
                                        }, 
                                        icon: Icon(Icons.delete, color: Colors.white, size: 28.0,),
                                      ),
                                    ),

                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )

                    ],
                  ),
                  
                );
              },
            childCount: listContent.length
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 120.0,),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 18.0, right: 15.0),
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            onPressed: () {
              addSectionUI();
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


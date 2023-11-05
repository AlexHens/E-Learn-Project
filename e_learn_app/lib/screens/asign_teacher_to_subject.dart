import 'package:e_learn_app/screens/screens.dart';
import 'package:e_learn_app/services/services.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../ui/input_decorations.dart';

class AsignTeacherToSubjectScreen extends StatelessWidget {

  String id = '';
  String name = '';
  String description = '';
  String grade = '';
   
  AsignTeacherToSubjectScreen({Key? key, required this.id, required this.name, required this.description, required this.grade}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(63, 63, 156, 1),
        toolbarHeight: 60,
        leading: IconButton(
          icon: Icon(Icons.home_rounded, size: 40,),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'home_page_admin');
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
      body: SearchAndListTeachers(id: this.id, name: this.name, description: this.description, grade: this.grade,),
    );
  }
}

class SearchAndListTeachers extends StatefulWidget {

  String id;
  String name;
  String description;
  String grade;

  SearchAndListTeachers({super.key, required this.id, required this.name, required this.description, required this.grade});


  @override
  _SearchAndListTeachersState createState() => _SearchAndListTeachersState();


}

class _SearchAndListTeachersState extends State<SearchAndListTeachers> {
  
  List<String> teachersList = [];
  TextEditingController _textController = TextEditingController();
  AdminSubjectService _adminSubjectService = AdminSubjectService();

  Future<void> onSearchButtonPressed(String teacherId) async {

    if(teacherId.isEmpty) {
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
    
    Usuario? teacherIdResult = await _adminSubjectService.searchTeacher(teacherId);

    if(teacherIdResult != null && !teacherId.isEmpty) {
      if(teachersList.contains(teacherIdResult.dni)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Profesor ya introducido'),
              content: Text('El profesor con ID $teacherId ya ha sido asignado a esta asignatura'),
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
          teachersList.add(teacherIdResult.dni);
        });
      }
      
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Profesor no encontrado'),
            content: Text('El profesor con ID $teacherId no existe'),
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
      teachersList.removeAt(index);
    });
  }

  @override
  void dispose(){
    _textController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
    
          SizedBox(height: 30,),
      
          Center(child: Text("Asignar Profesores a Asignatura", style: TextStyle(color: Color.fromRGBO(90, 70, 178, 1), fontSize: 30.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)),
          
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
                    controller: _textController,
                    decoration: InputDecorations.subjectInputDecoration(
                      hintText: '', 
                      labelText: 'DNI del profesor',
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
                  String teacherID = _textController.text;
                  print(teacherID);
                  onSearchButtonPressed(teacherID);
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
              itemCount: teachersList.length,
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
                        child: Text(teachersList[index], style: TextStyle(fontSize: 25,color: Colors.white)),
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
                      Navigator.pushReplacementNamed(context, 'home_page_admin');
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
            
                      if(teachersList.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Lista vacía'),
                              content: Text('Debes asignar al menos un profesor a la asignatura'),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AsignAlumnToSubjectScreen(id: widget.id, name: widget.name, description: widget.description, grade: widget.grade, teacherList: this.teachersList,)));
                      }
                      
                    },
                  ),
              
                ],
              ),
            ),
          )
    
        ],
      ),
    );

  }

}
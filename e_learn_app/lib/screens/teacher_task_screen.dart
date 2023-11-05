import 'package:flutter/material.dart';

import '../data/GlobalData.dart';
import '../models/models.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';
import 'screens.dart';

class TeacherTaskScreen extends StatefulWidget {
   
  const TeacherTaskScreen({Key? key}) : super(key: key);

  @override
  State<TeacherTaskScreen> createState() => _TeacherTaskScreenState();
}

class _TeacherTaskScreenState extends State<TeacherTaskScreen> {

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  GlobalData? dataTeacher = GlobalData.getInstance();
  List<Tarea> teacherTasks = [];
  TeacherTaskService _teacherTaskService = TeacherTaskService();

  @override
  void initState() {
    super.initState();
    _fetchTeacherTasks();
  }

  Future<void> _fetchTeacherTasks() async {

    try {
      final teacherTasks_aux = await _teacherTaskService.getTeacherTasks(dataTeacher!.dni);

      setState(() {
        teacherTasks = teacherTasks_aux;
      });

    } catch (e) {
      print('Error al obtener tareas del alumno: $e');
    }

  }

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
          child: Text("Tareas", style: TextStyle(fontSize: 30),)
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
      drawer: MenuExpandibleTeacher(),
      body: ListView.builder(
        itemCount: teacherTasks.length,
        itemBuilder: (context, index) {
          final nombre = teacherTasks[index].nombre;
          final nombre_asignatura = teacherTasks[index].nombre_asignatura;

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
          
                    Text(nombre, style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),),

                    SizedBox(height: 5.0,),
          
                    Text(nombre_asignatura, style: TextStyle(fontSize: 15, color: Colors.white),),

                    SizedBox(height: 5.0,),
          
                  ],
                ),
              ),
              trailing: Padding(
                padding: EdgeInsets.only(right: 20.0, top: 10.0),
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white, size: 30.0,),
                  onPressed: () {
                    _teacherTaskService.deleteTask(teacherTasks[index].id);
                    setState(() {
                      teacherTasks.removeAt(index);
                    });
                  },
                ),
              ),
              onTap: () async {
                
                String id_task = teacherTasks[index].id;

                Tarea? selectedTask = await _teacherTaskService.getTaskByID(id_task);

                if(selectedTask != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TaskContentTeacherScreen(task_info: selectedTask)));
                }

              },
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 18.0, right: 15.0),
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen()));
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
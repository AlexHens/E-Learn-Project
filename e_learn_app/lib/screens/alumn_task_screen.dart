import 'package:e_learn_app/data/GlobalData.dart';
import 'package:e_learn_app/screens/task_content_alumn_screen.dart';
import 'package:e_learn_app/services/task_service.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';

class AlumnTaskScreen extends StatefulWidget {


  AlumnTaskScreen({Key? key}) : super(key: key);

  @override
  State<AlumnTaskScreen> createState() => _AlumnTaskScreenState();
}

class _AlumnTaskScreenState extends State<AlumnTaskScreen> {
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  GlobalData? dataAlumn = GlobalData.getInstance();
  List<Tarea> alumnTasks = [];
  AlumnTaskService _alumnTaskService = AlumnTaskService();

  @override
  void initState() {
    super.initState();
    _fetchAlumnTasks();
  }

  Future<void> _fetchAlumnTasks() async {

    try {
      final alumnTasks_aux = await _alumnTaskService.getAlumnTasks(dataAlumn!.dni);

      setState(() {
        alumnTasks = alumnTasks_aux;
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
      drawer: MenuExpandibleAlumn(),
      body: ListView.builder(
        itemCount: alumnTasks.length,
        itemBuilder: (context, index) {
          final nombre = alumnTasks[index].nombre;
          final nombre_asignatura = alumnTasks[index].nombre_asignatura;

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
              onTap: () async {
                
                String id_task = alumnTasks[index].id;

                Tarea? selectedTask = await _alumnTaskService.getTaskByID(id_task);

                if(selectedTask != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TaskContentAlumnScreen(task_info: selectedTask)));
                }

              },
            ),
          );
        },
      ),
    );
  }
}
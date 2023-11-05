import 'package:e_learn_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:e_learn_app/data/GlobalData.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../widgets/widgets.dart';

class HomeScreenAdmin extends StatelessWidget {
   
  HomeScreenAdmin({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminSubjectService(),
      child: AdminSubjectsScreen(scaffoldState: _scaffoldState),
    );
  }
}

class AdminSubjectsScreen extends StatelessWidget {
  const AdminSubjectsScreen({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldState,
  }) : _scaffoldState = scaffoldState;

  final GlobalKey<ScaffoldState> _scaffoldState;

  @override
  Widget build(BuildContext context) {

    final adminSubjectService = Provider.of<AdminSubjectService>(context);

    if(adminSubjectService.isLoading) {
      return LoadingScreen();
    }

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
          child: Text("Asignaturas", style: TextStyle(fontSize: 30),)
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
      drawer: MenuExpandibleAdmin(),
      body: ListView.builder(
        itemCount: adminSubjectService.adminSubjects.length,
        itemBuilder: (BuildContext context, int index) {
          final subjectEntry = adminSubjectService.adminSubjects.entries.elementAt(index);
          final subjectName = subjectEntry.value;
          final subjectID = subjectEntry.key;

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
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 16.0),
              title: Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(subjectName, style: TextStyle(fontSize: 25,color: Colors.white)),
              ),
              trailing: Padding(
                padding: EdgeInsets.only(right: 15.0, top: 5.0),
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white, size: 35,),
                  onPressed: () {
                    adminSubjectService.deleteSubject(subjectID);
                  },
                ),
              ),
              onTap: () async {  },
            ),
          );
        }
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 18.0, right: 15.0),
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddSubjectScreen()));
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










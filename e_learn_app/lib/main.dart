// ignore_for_file: prefer_const_constructors

import 'package:e_learn_app/data/GlobalData.dart';
import 'package:e_learn_app/screens/screens.dart';
import 'package:e_learn_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Se debe añadir este archivo para tener servicios de firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppState());
} 

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginScreen(),
        'home_page_alumn': (_) => HomeScreenAlumn(),
        'home_page_teacher': (_) => HomeScreenTeacher(),
        'home_page_admin': (_) => HomeScreenAdmin(),
        'add_subject_admin': (_) => AddSubjectScreen(),
        'task_screen_alumn': (_) => AlumnTaskScreen(),
        'task_screen_teacher': (_) => TeacherTaskScreen(),
        'users_admin_screen': (_) => UsersAdminScreen(),
        'contacts_admin_screen': (_) => ContactsAdminScreen(),
        'contacts_teacher_screen': (_) => ContactsTeacherScreen(),
        'contacts_alumn_screen': (_) => ContactsAlumnScreen(),
      },
    );
  }
}
// ignore_for_file: prefer_const_constructors

import 'package:e_learn_app/models/models.dart';
import 'package:e_learn_app/providers/login_form_provider.dart';
import 'package:e_learn_app/services/services.dart';
import 'package:e_learn_app/ui/input_decorations.dart';
import 'package:e_learn_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
     
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: 350),

              CardContainer(
                child: Column(
                  children: [

                    SizedBox(height: 10,),
                    Text("Login", style: Theme.of(context).textTheme.headlineMedium,),
                    SizedBox(height: 30),

                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                    ),

                  ],
                ),
              )

            ],
          ),
        )
      )
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'xxxxxxxxxx@gmail.com', 
                labelText: 'Email - Correo electrónico', 
                prefixIcon: Icons.person
                ),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {

                  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp  = new RegExp(pattern);

                  return regExp.hasMatch(value ?? '') ? null : 'Esto no es un correo';

                },
            ),

            SizedBox(height: 30,),

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '12345678X',
                labelText: 'Contraseña - DNI',
                prefixIcon: Icons.lock
              ),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                if(value != null && value.length == 9) return null;
                return 'La contraseña debe ser de 9 caracteres';
              },
            ),

            SizedBox(height: 30,),

            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading 
                  ? 'Espere' : 'Entrar', 
                  style: TextStyle(color: Colors.white),
                ),
              ),

              onPressed: loginForm.isLoading ? null : () async {
                
                FocusScope.of(context).unfocus();
                final authService = Provider.of<AuthService>(context, listen: false);

                if(!loginForm.isValidForm()) return;

                loginForm.isLoading = true;

                final Usuario? resp = await authService.login(loginForm.email, loginForm.password);

                if(resp != null) {
                  if(resp.rol == 'Administrador'){
                    Navigator.pushReplacementNamed(context, 'home_page_admin');
                  }
                  else if(resp.rol == 'Alumno'){
                    Navigator.pushReplacementNamed(context, 'home_page_alumn');
                  }
                  else if(resp.rol == 'Profesor'){
                    Navigator.pushReplacementNamed(context, 'home_page_teacher');
                  }
                } else {
                  print('Error');
                  loginForm.isLoading = false;
                }

                await Future.delayed(Duration(seconds: 2));
              }
            )

          ],
        ),
      ),
    );
  }
}
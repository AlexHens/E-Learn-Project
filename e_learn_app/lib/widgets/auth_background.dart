import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 222, 221, 221),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [

          _PurpleBox(),

          _HeaderLogo(),

          this.child,
        ],
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height*0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(child: _Buble(), top: 90, left: -30,),
          Positioned(child: _Buble(), top: 50, right: 20,),
          Positioned(child: _Buble(), top: -10, left: 180,),
          Positioned(child: _Buble(), bottom: -30, left: 15,),
          Positioned(child: _Buble(), bottom: 60, right: -40,),
          Positioned(child: _Buble(), bottom: 160, right: 280,),
          Positioned(child: _Buble(), bottom: 30, right: 160,),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() => BoxDecoration(
    gradient: LinearGradient(colors: [
      Color.fromRGBO(63, 63, 156, 1),
      Color.fromRGBO(90, 70, 178, 1)
    ])
  );
}

class _HeaderLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Container(
        width: double.infinity,
        height: screenHeight*0.35,
        child: Image.asset('assets/E-Learn_logotipo-removebg-preview.png'),
      ),
    );
  }
}

class _Buble extends StatelessWidget {
  const _Buble({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );
  }
}
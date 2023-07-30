import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:week3/auth.dart';

const int _bluePrimaryValue = 0xFF2196F3;
const MaterialColor blue = const MaterialColor(
  _bluePrimaryValue,
  const <int, Color>{
    50: const Color(0xFFE3F2FD),
    100: const Color(0xFFBBDEFB),
    200: const Color(0xFF90CAF9),
    300: const Color(0xFF64B5F6),
    400: const Color(0xFF42A5F5),
    500: const Color(_bluePrimaryValue),
    600: const Color(0xFF1E88E5),
    700: const Color(0xFF1976D2),
    800: const Color(0xFF1565C0),
    900: const Color(0xFF0D47A1),
  },
);


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool _obscureText = true;

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUseerWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }
Widget _title() {
  return Container(
    width: double.infinity, 
    height: 60, 
    color: Colors.blue[900],
    child: Center(
      child: Text(
        'BUDGET TRACKER',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}


Widget _entryField(
  String title,
  TextEditingController controller,
) {
  return Column(
    children: [
      SizedBox(height: 20),
      Text(
        title,
        style: TextStyle(
          fontSize: 20, 
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ), 
      SizedBox(
        width: 280,
        child: TextField(
          controller: controller,
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center, 
          decoration: InputDecoration(
            border: InputBorder.none, 
            fillColor: Colors.grey[200],
            filled: true,
          ),
        ),
      ),
    ],
  );
}

Widget _passwordField(
  String title,
  TextEditingController _controllerPassword,
) {
  return Column(
    children: [
      SizedBox(height: 20),
      Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SizedBox(
        width: 260,
        child: TextField(
          controller: _controllerPassword,
          obscureText: _obscureText,
          style: TextStyle(color: Colors.black), 
          textAlign: TextAlign.center, 
          decoration: InputDecoration(
            border: InputBorder.none, 
            fillColor: Colors.grey[200],
            filled: true,
            suffixIcon: IconButton(
              onPressed: _toggleObscureText,
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            ),
          ),
        ),
      ),
    ],
  );
}


  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }
Widget _submitButton() {
  return Padding(
    padding: const EdgeInsets.all(0.0), 
    child: SizedBox(
      width: 100,
      height: 40,
      child: ElevatedButton(
        onPressed: isLogin ? signInWithEmailAndPassword : createUseerWithEmailAndPassword,
        child: Text(
        style: TextStyle(
          fontSize: 16,
        ),
          isLogin ? 'Login' : 'Register',
          ),
        style: ElevatedButton.styleFrom(
          primary: Colors.green[900],
        ),
      ),
    ),
  );
}

Widget _loginOrRegisterButton() {
  return Padding(
    padding: const EdgeInsets.all(16.0), 
    child: SizedBox(
      width: 150, 
      child: TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? 'Register instead' : 'Login instead'),
        style: TextButton.styleFrom(
          primary: Colors.red[900], 
        ),
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('Email', _controllerEmail),
            _passwordField('Password', _controllerPassword),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}

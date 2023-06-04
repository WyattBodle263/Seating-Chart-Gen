import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:t/shared_functions.dart';
import 'main.dart';


class FirebaseAuthState extends StatefulWidget {
  @override
  _FirebaseAuthStateState createState() => _FirebaseAuthStateState();
}

class _FirebaseAuthStateState extends State<FirebaseAuthState> {
  //Gets the handler for the textfields for username and password
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  /***
   *   Login will set the error message and then check the login credentials
   ***/
  void _login() {
    setState(() {
      errorMessage = '';
    });

    //Sets the username and password to the textifeld.text
    String username = _usernameController.text;
    String password = _passwordController.text;

    //Uses built in firebase method to sign in wuth an email and password
    FirebaseAuth.instance.signInWithEmailAndPassword(
      //Passes in the email and password
        email: username,
        password: password
    ).then((userCredential) { //If successful go to the program main
      print("Successfully Signed In the User!");
      userId = userCredential.user!.uid.toString();
      //Sets he username for getting and setting firebase data
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            title: 'Seating Chart Generator',
          ),
        ),
      );
    }).catchError((error) { //If error
      setState(() {
        errorMessage = 'Failed to sign in/up: ${error.toString()}';
      });
    });

  }
  /***
   *   Sign Up will create a new account for a user if has not already been made
   ***/
  void _signup() {
    setState(() {
      errorMessage = '';
    });

    String username = _usernameController.text;
    String password = _passwordController.text;

    FirebaseAuth.instance
        .createUserWithEmailAndPassword( //Method to create Username and Email
      email: username,
      password: password,
    ).then((userCredential) {
      print("Successfully Signed Up the User!");
      //Sets he username for getting and setting firebase data
      userId = userCredential.user!.uid.toString();
      Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MyHomePage(
              title: 'Seating Chart Generator',
            ),
          ),
      );
    }).catchError((error) { //If error
      setState(() {
        errorMessage = 'Failed to sign in/up: ${error.toString()}';
      });
    });

  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Login Page'),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Log In'),
                ),
                ElevatedButton(
                  onPressed: _signup,
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
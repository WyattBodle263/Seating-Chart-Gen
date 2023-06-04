/*

Copyright (c) 2023 Wyatt Bodle, Coding Minds Academy
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/


import 'package:flutter/material.dart';
import 'class_selected.dart';
import 'new_class.dart';
import 'shared_functions.dart';
import 'firebase_auth.dart';
//Firebase packages
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

/**
 * Main Function, sets up the firebase connection
 **/
 void main()  async{
   WidgetsFlutterBinding.ensureInitialized();

   await Firebase.initializeApp(
     name: 'Seating-Chart_Generator',
     options: DefaultFirebaseOptions.currentPlatform,
   );
  runApp(const MyApp());
}
/**
 * Creates a MyApp class which will run the build and set the start screen as an auth page
 */
class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(144, 255, 0, 0)),
        useMaterial3: true,
      ),
      //Sets the opening page to the firebaseAuthState
      home: FirebaseAuthState(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});
  //String field to hold the title for our app bar
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/**
 * MyHomePage is a page with a list of classes that are added by the user and can
 * be clicked to view class or add new class
 */
class _MyHomePageState extends State<MyHomePage> {
  Course? selectedCourse;
  //Overried the initial state to first pull our data from firebase
  @override
  void initState() {
    super.initState();
    listenToDataFromFirebase();
  }

  /*
  Function gets the data from firebase and populates lists and classes for later usage
   */
  //Sets an instance ref so we can use that as a shortcut when using firebase methods
  final DatabaseReference database = FirebaseDatabase.instance.ref();
  void listenToDataFromFirebase() async {
    //Begins to attempt retrieving the data
    print("Retrieving Data");
    /*
    Gets the data from this structure:

    -Users
      -UserID
        -Course
           -name
           -size
           -tableSize
           -students
              -student1
                -first
                -last

     */
    await database.child("Users").child(userId).onValue.listen((event) {
      //A snapshot is the data being pulled
      final snapshot = event.snapshot;
      //Cretes a map of dynamic type data which allows us to sort through the data easily
      Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
      //If the data is not empty we need to empty it in order to refill it with the correct data and not duplicating any data
      if (data != null) {
        courses.clear();
        //this goes through our data, it will get each course under courseName and all of its children under courseDetails
        data.forEach((courseName, courseDetails) {
          //Creates an empty list of student objects to fill later with pulled data
          List<Student> students = [];
          //Takes a color.toString and refactors it into a color object by spliting the data away from all string pieces
          String valueString = courseDetails['color'].split('(0x')[1].split(')')[0];
          //takes the string that is a color and converts it into an int that will later be converted to a color
          int value = int.parse(valueString, radix: 16);
          //Makes the color object out of the value
          Color thisColor = new Color(value);
          //Gets the data from each section
          String name = courseDetails['name']; //Class name
          int tableSize = int.parse(courseDetails['tableSize']);  //tableSize
          int size = int.parse(courseDetails['size']);  //Size of class
          // Access the student data within each course.  Does the same thing as before but instead dives into the students being the student name and studentdetails
          if (courseDetails.containsKey('students')) {
            Map<dynamic, dynamic> studentData = courseDetails['students'];

            // Iterate over the students
            studentData.forEach((studentName, studentDetails) {
              String firstName = studentDetails['first'];
              String lastName = studentDetails['last'];

              // Create a new Student object and add it to the list
              Student thisStudent = Student(
                  firstName: firstName, lastName: lastName);
              print("New Student: " + thisStudent.firstName);
              students.add(thisStudent);
            });
          }
          // Create a new Course object and add it to the list
          Course course = Course(name: name, color: thisColor, courseStudents: students, size: size, tableSize: tableSize);
          courses.add(course);

        });
        //Sets the state of our screen
        setState(() {});
      }//If an error print the error
    }, onError: (error) {
      print('Failed to retrieve data: $error');
    });
  }




  // Reload the view
  void reloadMainScreen() async {
    setState(() {
      //When screen is reloaded read the data
      listenToDataFromFirebase();
      selectedCourse = null;
      print(courses.length);
    });
  }

  /*
  Widget to build the screen UI
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /**
       * App bar at the top of the screen, set to a pinkish color, also sets the title
       */
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      /**
       * Create new class button, when clicked navigate to the new course page
       */
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NewCoursePage(
                title: 'New Class',
              ),
            ),
          ).then((value) {
            // Reload the main screen when returning from the NewCoursePage
            reloadMainScreen();
          });
        },
        child: const Icon(Icons.add),
      ),
      /**
       * GridView Builder allows for creating a dynamically changing UI that populates the screen based on how many objects I have
       */
      body: GridView.builder(
        //Sets the padding for the buttons
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: courses.length,  //Create as many objects as courses that we have
        itemBuilder: (context, index) {
          final thisCourse = courses[index];
          /**
           * When a class is clicked on navagate to the slected class file and pass in the class object that was picked
           */
          return ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => classSelected(
                    passedCourse: thisCourse, course: thisCourse,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              primary: thisCourse.color,
            ),
            child: Center( //Puts the name of the course in the center of the button
              child: Text(
                thisCourse.name,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}



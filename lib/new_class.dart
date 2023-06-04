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
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'shared_functions.dart';

class NewCoursePage extends StatefulWidget {
  const NewCoursePage({super.key, required this.title}); //Constructor

  final String title;

  @override
  State<NewCoursePage> createState() => _NewCoursePageState();
}

/**
 * This UI and class is used to create a new class, it allows for inputs for color, name, tableSize, size, and all the students names
 */
class _NewCoursePageState extends State<NewCoursePage> {

  //Text editing controllers
  TextEditingController classNameTextEditingController = TextEditingController(); //For class Name
  TextEditingController tableSizeTextEditingController = TextEditingController(); //For Table Size
  TextEditingController totalClassSizeTextEditingController = TextEditingController(); //For total class size

  //List to hold the students
  List<Student> students = [];

  //Holds the data for inputed class
  Color classColor = Colors.red; // Variable to store the class color
  String className = "";
  int classSize = 0;
  int tableSize = 0;

  //When the color picker is done being used it will update the class color
  void changeColor(Color color) {
    setState(() {
      classColor = color; // Update the class color
    });
  }

  //Adds and object to the student class list
  void addStudent(int input) {
    if (input > 0) { //If the student textfields are not empty
      setState(() {
        //For loop to add each student
        for (int i = 0; i <= input-1; i++) {
          students.add(Student(firstName: '', lastName: ''));
        }
      });
    }
  }

  /**
   * Saves the data to firebase
   */
  void saveData() async{ //Async function means we must wait till it finishes to move on
    print("Save Pressed...");
    //If the student fields are not empty continue
    if (students.isNotEmpty) {
      //Sets our variables from their text inputs
      className = classNameTextEditingController.text;
      //Parses the strings to get the ints
      int input = int.parse(totalClassSizeTextEditingController.text);
      classSize = input;
      int tableInput = int.parse(tableSizeTextEditingController.text);
      tableSize = tableInput;
      //Creates a new course object to help with writing to firebase
      Course newCourse = Course(
        name: className,
        color: classColor,
        size: classSize,
        tableSize: tableSize,
        courseStudents: students,
      );
      //database variable to make accessing functions better
      FirebaseDatabase database = FirebaseDatabase.instance;
      DatabaseReference ref = database.ref("Users").child(userId).child(className);

      await ref.set({ //Sends the data to firebase with key value pairs
        "name": className,
        "color" : classColor.toString(),
        "size" : classSize.toString(),
        "tableSize" : tableSize.toString(),
      }).then((value) { //If the upload is sucessful
        print("Successfully Uploaded!");
      }).catchError((error) { //If error
        setState(() {
          print('Failed to sign in/up: ${error.toString()}');
        });
      });

      //Saves the students to firebase
        students.forEach((thisStudent) async {
          print("Printing students: " + thisStudent.firstName);
          await ref.child("students").child(thisStudent.firstName + thisStudent.lastName).set({
            "first": thisStudent.firstName,
            "last": thisStudent.lastName,
          }).then((value) { //If upload was successful
            print("Successfully Uploaded!");
          }).catchError((error) { //If there is an error
            print('Failed to upload student: ${error.toString()}');
          });

        });
      if (mounted){ //If done with the async function return to previous navigation point
        Navigator.pop(context);
      }
    }
  }

    @override
    Widget build(BuildContext context) {
      FocusNode textFieldFocusNode = FocusNode();
      FocusNode tableTextFieldFocusNode = FocusNode();


      return Scaffold(
        /**
         * App Bar
         */
        appBar: AppBar(
          backgroundColor: classColor,
          title: Text(widget.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /**************
                Choose Color UI
             ***************/

            const Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Choose Color:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            /**
             * Data input UI
             */
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Select Class Color:'),
                          content: SingleChildScrollView(
                            child: ColorPicker(
                              pickerColor: classColor,
                              onColorChanged: changeColor,
                              showLabel: true,
                              pickerAreaHeightPercent: 0.8,
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                    Color>(Colors
                                    .transparent), // Set transparent background for the button
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.color_lens,
                    color: classColor,
                  ),
                ),
              ),
            ),

            /***********
                Class Name UI
             ************/

            const Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Class Name: *',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: classNameTextEditingController,
                onEditingComplete: () {
                  className = classNameTextEditingController.text;
                  textFieldFocusNode.unfocus(); // Dismiss the keyboard
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter name...',
                ),
              ),
            ),

            /************
                Class Size UI
             ************/

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Class Size',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100,
                        child: TextField(
                          focusNode: tableTextFieldFocusNode,
                          // Assign the FocusNode to the TextField
                          //When the texfeild is done being edited add that many students to the inputs
                          onEditingComplete: () {
                            int input = int.parse(
                                totalClassSizeTextEditingController.text);
                            classSize = input;
                            addStudent(input);
                            tableTextFieldFocusNode
                                .unfocus(); // Dismiss the keyboard
                          },
                          controller: totalClassSizeTextEditingController,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          maxLength: 2,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Size...',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /************
                Table Size UI
             ************/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Table Size',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100,
                        child: TextField(
                          focusNode: textFieldFocusNode,
                          // Assign the FocusNode to the TextField
                          controller: tableSizeTextEditingController,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                          maxLength: 2,
                          onEditingComplete: () {
                            int tableInput = int.parse(
                                totalClassSizeTextEditingController.text);
                            tableSize = tableInput;
                            textFieldFocusNode
                                .unfocus(); // Dismiss the keyboard
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Size...',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ),
            /************
                Students UI
             ************/
            const Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Students:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(students.length, (index) {
                    return ListTile(
                      title: Row(
                        children: [
                          Text(
                            '${index + 1}.',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'First Name',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  students[index].firstName = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Last Name',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  students[index].lastName = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),

          ],
        ),
        /************
            Save Button
         ************/
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            saveData();
          },
          child: Icon(Icons.done),
        ),
      );
    }
  }


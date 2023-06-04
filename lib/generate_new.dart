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
import 'shared_functions.dart';

class generateNewPage extends StatefulWidget {
  const generateNewPage({
    Key? key,
    required Course passedCourse,
    required this.course,
  }) : super(key: key);

  final Course course;

  @override
  State<generateNewPage> createState() => _generateNewPageState();
}

class _generateNewPageState extends State<generateNewPage> {
  //Variables
  String selectedOption = ''; //Selected class name
  int option = 1; //Radio button option

  /**
   * Updates the course based on selected option
   */
  void updateCourse(Course thisCourse) {
    /**
     * Randomize Option
     */
    if (option == 5) {
      // Randomize the student list and create a new list to update the class
      thisCourse.courseStudents.shuffle();
      /**
       * Sort Reverse Alphabetically by last name
       */
    } else if (option == 4){  //ZYX Last Name
      thisCourse.courseStudents.sort((a, b) {
        int result = b.lastName.toLowerCase().compareTo(a.lastName.toLowerCase());
        if (result == 0) {
          result = b.firstName.toLowerCase().compareTo(a.firstName.toLowerCase());
        }
        return result;
      });
      /**
       * Sort Alphabetically by last name
       */
    }else if (option == 3){ //ABC Last Name
      thisCourse.courseStudents.sort((a, b) {
        int result = a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
        if (result == 0) {
          result = a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
        }
        return result;
      });
      /**
       * Sort Reverse Alphabetically by first name
       */
    }else if (option == 2){ //ZYX (First Name)
      thisCourse.courseStudents.sort((a, b) {
        int result = b.firstName.toLowerCase().compareTo(a.firstName.toLowerCase());
        if (result == 0) {
          result = b.lastName.toLowerCase().compareTo(a.lastName.toLowerCase());
        }
        return result;
      });
      /**
       * Sort  Alphabetically by first name
       */
    }else {
      // Sort the student list based on first name and last name together (case-insensitive)
      thisCourse.courseStudents.sort((a, b) {
        int result = a.firstName.toLowerCase().compareTo(b.firstName.toLowerCase());
        if (result == 0) {
          result = a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase());
        }
        return result;
      });
    }
    //Navigates back to the selected page
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /**
       * App Bar
       */
      appBar: AppBar(
        backgroundColor: widget.course.color,
        title: Text(widget.course.name),
      ),
      /**
       * Radio Buttons
       */
      body: Column(
        children: [
          RadioListTile(
            title: Text('Alphabetical ABC (First Name)'),
            value: 'alphabetical_abc',
            groupValue: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Alphabetical ZYX (First Name)'),
            value: 'alphabetical_zyx',
            groupValue: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Alphabetical ABC (Last Name)'),
            value: 'alphabetical_abc_last',
            groupValue: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Alphabetical ZYX (Last Name)'),
            value: 'alphabetical_zyx_last',
            groupValue: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value.toString();
              });
            },
          ),
          RadioListTile(
            title: Text('Random'),
            value: 'random',
            groupValue: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value.toString();
              });
            },
          ),
          /**
           * Logic for radio buttons when generate is pressed
           */
          ElevatedButton(
            onPressed: () {
              // Perform action based on the selected option
              switch (selectedOption) {
                //When an option is pressed set the variable equal to 1-4 so that it can use
              // an if statement to sort the data based on the choice
                case 'alphabetical_abc':
                // Code for alphabetical ABC option
                print("ABC");
                option = 1;
                updateCourse(widget.course);
                  break;
                case 'alphabetical_zyx':
                // Code for alphabetical ZYX option
                  print("ZYX");
                  option = 2;
                  updateCourse(widget.course);
                  break;
                case 'alphabetical_abc_last':
                // Code for alphabetical ABC option
                  print("ABC");
                  option = 3;
                  updateCourse(widget.course);
                  break;
                case 'alphabetical_zyx_last':
                // Code for alphabetical ZYX option
                  print("ZYX");
                  option = 4;
                  updateCourse(widget.course);
                  break;
                case 'random':
                // Code for random option
                  print("RAND");
                  option = 5;
                  updateCourse(widget.course);
                  break;
                default:
              }
            },
            child: Text('Generate'),
          ),
        ],
      ),
    );
  }
}

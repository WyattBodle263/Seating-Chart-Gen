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
import 'generate_new.dart';
import 'shared_functions.dart';

class classSelected extends StatefulWidget {
  const classSelected({
    Key? key,
    required Course passedCourse,
    required this.course,
  }) : super(key: key);

  final Course course;

  @override
  State<classSelected> createState() => _classSelectedState();
}

class _classSelectedState extends State<classSelected> {

  // Reload the view
  void reloadView() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    //Sets variables for use
    int totalStudents = widget.course.courseStudents.length;
    int tableSize = widget.course.tableSize;
    int totalTables = (totalStudents / tableSize).ceil(); //Gets the total tables by dividing students by table size

    return Scaffold(
      /**
       * App Bar
       */
      appBar: AppBar(
        backgroundColor: widget.course.color,
        title: Text(widget.course.name),
      ),
      /**
       * Creates a Row for Each table and columns for each chair
       */
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < totalTables; i++) //For each table build a Row
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Table ${i + 1}', //Give it a header for each table
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  /**
                   * Grid View to show the tables
                   */
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: tableSize,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                    ),
                    itemCount: tableSize, //Builds columns for each chair in a table
                    itemBuilder: (context, deskIndex) { //Gives it a desk index and the name
                      int studentIndex = i * tableSize + deskIndex;
                      //If the student index is less than total students we need to add a new row
                      if (studentIndex < totalStudents) {
                        final student = widget.course.courseStudents[studentIndex];
                        /**
                         * Button for each student
                         */
                        return ElevatedButton(
                          onPressed: () {
                          },
                          child: Center(
                            child: Text(
                              student.firstName + " " + student.lastName[0] + ".",
                              style: TextStyle(fontSize: (50 / widget.course.tableSize), color: Colors.black),
                            ),
                          ),
                        );
                      } else {
                        return Container(); // Return an empty container for the extra desks
                      }
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
      /**
       * Generate new order button
       */
      bottomNavigationBar: BottomAppBar(
          color: widget.course.color,
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle "Generate New" button press
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => generateNewPage(
                        passedCourse: widget.course, course: widget.course,
                      ),
                    ),
                  ).then((value) {
                    // Reload the main screen when returning from the NewCoursePage
                    reloadView();
                  });
                  print('Generate New button pressed');
                },
                child: Text('Generate New'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


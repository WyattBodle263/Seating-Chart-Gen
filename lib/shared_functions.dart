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

//variable List of courses
List<Course> courses = [];

//Global variable of userID
String userId = "";

/**
 * Student class to hold their first and last name
 */
class Student {
  String firstName;
  String lastName;

  Student({
    required this.firstName,
    required this.lastName,
  });
}

/**
 * Course class to hold all other course information
 */
class Course {
  final String name;
  final Color color;
  final int size;
  final int tableSize;
  List<Student> courseStudents;

  Course({
    required this.name,
    required this.color,
    required this.courseStudents,
    required this.size,
    required this.tableSize,
  });

}

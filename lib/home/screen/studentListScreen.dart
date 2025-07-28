import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:students/model/student.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final Box<Student> studentBox = Hive.box<Student>('students');

  void deleteStudent(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Student"),
        content: const Text("Are you sure you want to delete this student?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              studentBox.deleteAt(index);
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Student deleted')));
              setState(() {});
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void editStudentDialog(Student student) {
    final idController = TextEditingController(text: student.id);
    final nameController = TextEditingController(text: student.name);
    final semesterController = TextEditingController(text: student.semester);
    final contactController = TextEditingController(text: student.contact);
    final emailController = TextEditingController(text: student.email ?? '');
    final rollNoController = TextEditingController(text: student.rollNo ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'ID'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: semesterController,
                decoration: const InputDecoration(labelText: 'Semester'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Contact'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: rollNoController,
                decoration: const InputDecoration(labelText: 'Roll No'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              student.id = idController.text;
              student.name = nameController.text;
              student.semester = semesterController.text;
              student.contact = contactController.text;
              student.email = emailController.text;
              student.rollNo = rollNoController.text;
              student.save(); // Save updated student
              Navigator.pop(context);
              setState(() {}); // Refresh UI
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Student updated')));
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey,
      ),
      body: ValueListenableBuilder(
        valueListenable: studentBox.listenable(),
        builder: (context, Box<Student> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No students added.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final student = box.getAt(index)!;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: student.image != null
                      ? CircleAvatar(
                          backgroundImage: FileImage(File(student.image!)),
                        )
                      : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(student.name),
                  subtitle: Text(
                    "ID: ${student.id}\nSemester: ${student.semester}\nContact: ${student.contact}",
                  ),
                  isThreeLine: true,
                  onTap: () => editStudentDialog(student),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteStudent(index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

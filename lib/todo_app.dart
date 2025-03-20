import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';

// Inisialisasi proyek Flutter
class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  // Menambahkan controller untuk input task
  final TextEditingController taskController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  DateTime? selectedDate;

 
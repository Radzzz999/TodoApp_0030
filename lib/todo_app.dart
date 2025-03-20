import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';

// 1. Inisialisasi proyek Flutter
class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  // 4. Menambahkan controller untuk input task
  final TextEditingController taskController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  DateTime? selectedDate;

  // 6. Membuat daftar task dalam list
  List<Map<String, dynamic>> daftarTask = [];
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  // 7. Menambahkan fungsi untuk menambahkan task
  void addTask() {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Silakan pilih deadline terlebih dahulu!")),
      );
      return;
    }

    if (key.currentState!.validate()) {
      setState(() {
        daftarTask.add({
          "task": taskController.text,
          "deadline": selectedDate,
          "status": false,
        });
        // 19. Menambahkan fitur reset setelah task ditambahkan
        taskController.clear();
        selectedDate = null;
        _autoValidate = AutovalidateMode.disabled;
      });
      // 15. Menampilkan pesan saat task berhasil ditambahkan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task berhasil ditambahkan!")),
      );
    } else {
      setState(() {
        _autoValidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  // 11. Menggunakan bottom_picker untuk memilih tanggal
  void _showDatePicker() {
    BottomPicker.dateTime(
      pickerTitle: Text(
        'Pilih Tanggal & Waktu Deadline',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      onSubmit: (date) {
        setState(() {
          selectedDate = date;
        });
      },
      onCloseButtonPressed: () {
        print('Picker closed');
      },
      minDateTime: DateTime.now(),
      maxDateTime: DateTime(2025, 12, 31),
      initialDateTime: selectedDate ?? DateTime.now(),
      gradientColors: [Color(0xfffdcbf1), Color(0xffe6dee9)],
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 17. Menambahkan AppBar dengan judul dan ikon menu
      appBar: AppBar(
        title: Text("Todo List"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 26, 255, 0),
        leading: Icon(Icons.menu),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Deadline :",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // 12. Menampilkan deadline dalam tampilan list task
                    Text(
                      selectedDate != null
                          ? "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year} ${selectedDate!.hour}:${selectedDate!.minute}"
                          : "Pilih Deadline",
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                  ],
                ),
                // 16. Menambahkan ikon kalender untuk memilih deadline
                IconButton(
                  icon: Icon(Icons.date_range, color: const Color.fromARGB(255, 26, 255, 0), size: 35),
                  onPressed: _showDatePicker,
                ),
              ],
            ),
            SizedBox(height: 20),
            // 5. Menambahkan form dan validasi input
            Form(
              key: key,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: taskController,
                      validator: (value) {
                        // 14. Memperbaiki validasi saat task ditambahkan
                        if (value == null || value.isEmpty) {
                          return "Task masih kosong";
                        }
                        return null;
                      },
                      autovalidateMode: _autoValidate,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Task",
                        hintText: "Masukkan Task",
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // 8. Menambahkan tombol untuk menyimpan task
                  ElevatedButton(
                    onPressed: () {
                      if (key.currentState!.validate()) {
                        addTask();
                      }
                    },
                    child: Text(
                      "Simpan",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 26, 255, 0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // 9. Menampilkan daftar task di ListView
            Expanded(
              child: ListView.builder(
                itemCount: daftarTask.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                daftarTask[index]["task"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Deadline: ${daftarTask[index]["deadline"]!.day}-${daftarTask[index]["deadline"]!.month}-${daftarTask[index]["deadline"]!.year} ${daftarTask[index]["deadline"]!.hour}:${daftarTask[index]["deadline"]!.minute}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              // 13. Menambahkan status task (Done/Not Done)
                              Text(
                                daftarTask[index]["status"]
                                    ? "Done"
                                    : "Not Done",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      daftarTask[index]["status"]
                                          ? Colors.green
                                          : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              // 20. Menambahkan fitur update status task dari checkbox
                              Checkbox(
                                value: daftarTask[index]["status"],
                                onChanged: (bool? value) {
                                  setState(() {
                                    daftarTask[index]["status"] = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

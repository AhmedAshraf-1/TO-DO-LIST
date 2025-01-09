import 'package:flutter/material.dart';
import '../util/dialog_box.dart';
import '../util/todo_tile.dart';
import '../data/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _toDoList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    _toDoList = await _dbHelper.getTasks();
    setState(() {});
  }

  void checkBoxChanged(bool? value, int index) {
    _dbHelper.updateCompletionStatus(_toDoList[index]['id'], value! ? 1 : 0);
    _loadTasks();
  }

  void saveNewTask() {
    if (_controller.text.isNotEmpty) {
      _dbHelper.insertTask(_controller.text);
      _controller.clear();
      Navigator.of(context).pop();
      _loadTasks();
    }
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void editTask(BuildContext context, int id, String currentTask) {
    _controller.text = currentTask; // Set current task in the controller

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: () {
            if (_controller.text.isNotEmpty) {
              _dbHelper.updateTask(id, _controller.text); // Update task in the database
              _controller.clear();
              Navigator.of(context).pop();
              _loadTasks();
            }
          },
          onCancel: () {
            _controller.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void deleteTask(int id) {
    _dbHelper.deleteTask(id);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'TO DO',
              style: TextStyle(color: Colors.white),
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: _toDoList[index]['task'],
            taskCompleted: _toDoList[index]['completed'] == 1,
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(_toDoList[index]['id']),
            editFunction: (context, id, task) => editTask(context, id, task), // Pass the correct task ID
          );
        },
      ),
    );
  }
}

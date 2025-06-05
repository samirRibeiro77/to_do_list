import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key, required this.appName});

  final String appName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _taskList = [];
  TextEditingController _taskController = TextEditingController();

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/taskList.json");
  }

  _saveTask() {
    var task = {"title": _taskController.text, "done": false};

    setState(() {
      _taskList.add(task);
    });

    _saveFile();
    _taskController.text = "";
  }

  _saveFile() async {
    var tasksJson = json.encode(_taskList);

    var file = await _getFile();
    file.writeAsString(tasksJson);
  }

  Future<String> _readFile() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _readFile().then((data) {
      setState(() {
        _taskList = json.decode(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appName,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: _taskList.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(_taskList[index]["title"]),
            value: _taskList[index]["done"],
            onChanged: (value) {
              setState(() {
                _taskList[index]["done"] = value;
              });
              _saveFile();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Adicionar tarefa"),
                content: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(labelText: "Digite sua tarefa"),
                  onChanged: (text) {},
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancelar"),
                  ),
                  TextButton(
                    onPressed: () {
                      _saveTask();
                      Navigator.pop(context);
                    },
                    child: Text("Salvar"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add_task),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:async/async.dart';
import 'dart:convert';

import 'package:task_list/model/task.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.appName});

  final String appName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _taskList = [];

  _saveFile() async {
    final dir = await getApplicationDocumentsDirectory();
    var file = File("${dir.path}/taskList.json");

    // Create task
    var task = Task.newTask("Ir ao mercado");
    setState(() {
      _taskList.add(task.toMap());
    });

    var tasksJson = json.encode(_taskList);
    file.writeAsString(tasksJson);
  }

  @override
  Widget build(BuildContext context) {
    _saveFile();
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
            return ListTile(
              title: Text(_taskList[index]["title"]),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  title: Text("Adicionar tarefa"),
                  content: TextField(
                    decoration: InputDecoration(
                      labelText: "Digite sua tarefa"
                    ),
                    onChanged: (text) {

                    },
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancelar")
                    ),
                    TextButton(
                        onPressed: (){
                          // TODO: Create function
                          Navigator.pop(context);
                        },
                        child: Text("Salvar")
                    ),
                  ],
                );
              }
          );
        },
        child: Icon(Icons.add_task),
      ),
    );
  }
}

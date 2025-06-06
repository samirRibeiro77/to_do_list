import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.appName});

  final String appName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _taskList = [];
  Map<String, dynamic> _lastRemoved = {};
  final TextEditingController _taskController = TextEditingController();

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

  _shareFile() async {
    var file = await _getFile();
    final params = ShareParams(
      text: "TaskList file",
      files: [
        XFile(file.path)
      ]
    );

    final result = await SharePlus.instance.share(params);

    print("Share status: ${result.status}");
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

  Widget _createListTile(context, index) {
    final task = _taskList[index];

    return Dismissible(
      key: ValueKey(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.all(16),
        color: Colors.redAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Icon(Icons.delete_forever, color: Colors.white)],
        ),
      ),
      onDismissed: (direction) {
        _lastRemoved = task;
        _taskList.removeAt(index);
        _saveFile();

        final snackBar = SnackBar(
          content: Text("Tarefa deletada"),
          action: SnackBarAction(
            label: "Desfazer",
            onPressed: () {
              setState(() {
                _taskList.insert(index, _lastRemoved);
              });
              _saveFile();
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: CheckboxListTile(
        title: Text(task["title"]),
        value: task["done"],
        onChanged: (value) {
          setState(() {
            task["done"] = value;
          });
          _saveFile();
        },
      ),
    );
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
        actions: [
          IconButton(
              onPressed: _shareFile,
              icon: Icon(Icons.share)
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _taskList.length,
        // padding: EdgeInsets.all(16),
        itemBuilder: _createListTile,
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

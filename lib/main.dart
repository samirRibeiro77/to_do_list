import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'domain/ToDoTask.dart';

void main() {
  runApp(MaterialApp(
    title: "To Do List",
    home: Home(),
  ));
}

Future<File> _getFile() async {
  final directory = await getApplicationDocumentsDirectory();
  var file = await File("${directory.path}/toDoTask.json");
  var fileExists = await file.exists();
  if (!fileExists) {
    await file.create(recursive: true);
  }

  return file;
}

Future<File> _saveData(List<ToDoTask> listSave) async {
  var listMap = List<Map<String, dynamic>>();
  listSave.forEach((data) {
    listMap.add(data.toJson());
  });

  String dataJson = json.encode(listMap);
  final file = await _getFile();
  return file.writeAsString(dataJson);
}

Future<String> _readData() async {
  try {
    var data = await _getFile();
    return data.readAsString();
  } catch (e) {
    return null;
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final taskToAdd = TextEditingController();

  List<ToDoTask> _toDoList = [];

  void _addToDo() {
    var newToDo = ToDoTask(taskToAdd.text);
    taskToAdd.text = "";

    setState(() {
      _toDoList.add(newToDo);
      _saveData(_toDoList);
    });
  }

  void _deleteItem(context, item, index) {
    setState(() {
      _toDoList.removeAt(index);
      _saveData(_toDoList);

      final snackbar = SnackBar(
        content: Text("Task \"${item.name}\" removed."),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
            label: "Undo",
            onPressed: (){
          _rollbackItem(item, index);
        }),
      );

      Scaffold.of(context).showSnackBar(snackbar);
    });
  }

  void _rollbackItem(item, index) {
    setState(() {
      _toDoList.insert(index, item);
    });
  }

  @override
  void initState() {
    super.initState();

    _readData().then((data) {
      List mapJson = json.decode(data);
      mapJson.forEach((jsonData) {
        print(jsonData);
        var task = ToDoTask.fromJson(jsonData);
        setState(() {
          _toDoList.add(task);
        });
      });
    });
  }

  Widget buildItem(context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      onDismissed: (direction) {
        _deleteItem(context, _toDoList[index], index);
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      child: CheckboxListTile(
        title: Text(_toDoList[index].name),
        value: _toDoList[index].done,
        secondary: CircleAvatar(
          backgroundColor: Colors.purple,
          child: Icon(_toDoList[index].done ? Icons.done : Icons.close, color: Colors.white,),
        ),
        onChanged: (checked) {
          setState(() {
            _toDoList[index].changeStatus();
            _saveData(_toDoList);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do List"),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: taskToAdd,
                    decoration: InputDecoration(
                        labelText: "New task",
                        labelStyle: TextStyle(color: Colors.purple)),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.purple,
                    size: 30.0,
                  ),
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.fromLTRB(17.0, 2.0, 17.0, 0.0),
                itemCount: _toDoList.length,
                itemBuilder: buildItem),
          )
        ],
      ),
    );
  }
}

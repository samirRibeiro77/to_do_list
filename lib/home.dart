import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.appName});

  final String appName;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _list = ["Item 1", "Item 2", "Item 3"];

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
        itemCount: _list.length,
          padding: EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_list[index]),
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

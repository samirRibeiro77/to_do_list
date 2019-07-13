class ToDoTask {
  String _name;
  bool _done;

  ToDoTask(this._name) {
    this._done = false;
  }

  get name => _name;

  get done => _done;

  void changeStatus() => _done = !_done;

  ToDoTask.fromJson(Map<String, dynamic> json) {
    this._name = json["name"].toString();
    this._done = json["done"].toString().toLowerCase() == 'true';
  }

  Map<String, dynamic> toJson() => {
        "name": _name,
        "done": _done,
      };
}

class ToDoTask {
  String _name;
  bool _done;

  ToDoTask(this._name) {
    this._done = false;
  }

  get name => _name;
  get done => _done;

  void changeStatus() => _done = !_done;
}
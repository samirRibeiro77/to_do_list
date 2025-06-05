import 'dart:convert';

class Task {
  late String title;
  late bool done;

  Task(this.title, this.done);

  Task.newTask(this.title) {
    done = false;
  }

  Task.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    done = json["done"];
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "done": done
    };
  }

  String toJson() {
    return json.encode(toMap);
  }
}
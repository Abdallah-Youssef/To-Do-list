
class SubTask {

  String text;
  bool status;
  SubTask(String text, bool status) {
    this.text = text;
    this.status = status;
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'status': status
    };
  }

  SubTask.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        status = json['status'];

}
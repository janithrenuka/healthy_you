class DayWorkut {
  int? day;
  String? type;
  //List<String>? exercises;

  DayWorkut({
    this.day, 
    this.type, 
    //this.exercises
  });

  DayWorkut.fromJson(Map<String, dynamic> json) {
    day = json["day"];
    type = json["type"];
    //exercises = json["exercises"];
  }
}

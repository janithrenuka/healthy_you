class WorkoutModel {
  final int type;
  final int perWeek;
  final List<String> workout;

  WorkoutModel({required this.type, required this.perWeek, required this.workout});

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      type: json['type'],
      perWeek: json['perWeek'],
      workout: List<String>.from(json['workout']),
    );
  }
}
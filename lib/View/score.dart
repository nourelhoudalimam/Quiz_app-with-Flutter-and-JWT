class Score{
  int id;
  String dateTime;
  String result;
  int score;
  Score({required this.id,required this.dateTime,required this.result,required this.score});
  factory Score.fromJson( dynamic json) {
    return Score(
      id: json['id'] ?? 0,
      dateTime : json['dateTime'] ?? [],
      result: json['result'] ?? "",
      score:json['score'] ?? 0,
    );
  }

}
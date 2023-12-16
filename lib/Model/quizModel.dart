class quizModel{
 String question;
 List<String> answers;
 String correct;
quizModel({
  required this.question,required this.answers,required this.correct
});
 factory quizModel.fromJson(Map<String, dynamic> json) {
    return quizModel(
      question: json['question'] ?? "",
      answers: List<String>.from(json['answers'] ?? []),
      correct: json['correct'] ?? "",
    );
  }


}
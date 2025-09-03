class AnswerReview {
  final String questionText;
  final String? correctOption;

  AnswerReview({required this.questionText, this.correctOption});

  factory AnswerReview.fromJson(Map<String, dynamic> json) {
    return AnswerReview(
      questionText: json['question_text'],
      correctOption: json['correct_option'],
    );
  }
}

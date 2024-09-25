class MCQ {
  String question;
  String option1;
  String option2;
  String option3;
  String option4;
  String correctAnswer;

  MCQ(
      {this.question = '',
      this.option1 = '',
      this.option2 = '',
      this.option3 = '',
      this.option4 = '',
      this.correctAnswer = ''});

  void reset() {
    question = '';
    option1 = '';
    option2 = '';
    option3 = '';
    option4 = '';
    correctAnswer = '';
  }
}

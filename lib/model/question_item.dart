class QuestionItem {
  //? สร้างตัว import ที่เช็คตั้งแต่แรกเลย ว่า ข้อมูลใน json ผิดอะป่าว

  QuestionItem(
      {required this.answers, required this.questions, this.score = 1});

  // ["ans1", "ans2", ...]
  final List<String> answers;

  //[
  //  {
  //    questionText : "question text",
  //    correctAnswers : ["ans1", "ans2", ...]
  //    userAnswers :[], // not in json but auto gen when import //! <<-- add when build with dragtarget
  //  }, {...},
  //]
  final List<Map<String, dynamic>> questions;

  final int score;
}

//! done
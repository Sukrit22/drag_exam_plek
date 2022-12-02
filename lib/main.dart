import 'dart:io';
import 'dart:convert';
import 'package:drag_exam_plek/model/question_item.dart';
import 'package:flutter/material.dart';
import 'package:drag_exam_plek/screen/drag_answer_screen.dart';
import 'package:drag_exam_plek/setting.dart';
import 'package:file_picker/file_picker.dart';

Future<void> main() async {
  FilePickerResult? result;
  do {
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'], //! allow only json file
    );
  } while (result == null);

  File file = File(result.files.single.path!);
  //json string
  List<QuestionItem> questions = [];
  List<dynamic> temp = json.decode(await file.readAsString());
  for (var item in temp) {
    List answer = item["answers"] as List;
    List question = item["questions"] as List;
    questions.add(QuestionItem(
        answers: answer.map((e) => e as String).toList(),
        questions: question.map((e) => e as Map<String, dynamic>).toList(),
        score: item["score"] ?? 1));
  }
  questions.shuffle();
  runApp(DragExamPLek(questions: questions));
}

class DragExamPLek extends StatelessWidget {
  const DragExamPLek({super.key, required this.questions});

  final List<QuestionItem> questions;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exam draggable',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: MyHomePage(
        title: 'Exam draggable by game',
        questionItems: questions,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key, required this.title, required this.questionItems});
  final List<QuestionItem> questionItems;
  final String title;
  //List<dynamic> test = [];

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentQuestionNum = 0;

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionNum < widget.questionItems.length - 1) {
        _currentQuestionNum++;
        Setting.showOnlyOne = false;
      }
    });
  }

  void _prevQuestion() {
    setState(() {
      if (_currentQuestionNum > 0) {
        _currentQuestionNum--;
        Setting.showOnlyOne = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Text("ข้อที่ : ${_currentQuestionNum + 1}",
            style: const TextStyle(fontSize: 20)),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                Setting.showOnlyOne = !Setting.showOnlyOne;
              });
            },
            icon: const Icon(Icons.find_in_page),
            label: const Text("ตรวจข้อเดียว"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                Setting.showAnswer = !Setting.showAnswer;
                Setting.showOnlyOne = false;
              });
            },
            icon: Setting.showAnswer
                ? const Icon(Icons.visibility_off_outlined)
                : const Icon(Icons.visibility_outlined),
            label: Setting.showAnswer
                ? const Text("Hide answer")
                : const Text("Show answer"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              int score = 0;
              int max = widget.questionItems.length;
              for (var questionItem in widget.questionItems) {
                bool notWrong = true;
                for (var eachQuestion in questionItem.questions) {
                  if (!eachQuestion["correctAnswers"]
                      .contains((eachQuestion["userAnswers"] ?? [''])[0])) {
                    notWrong = false;
                  }
                }
                if (notWrong) score += 1;
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Your score is $score / $max"),
                action: SnackBarAction(
                  label: "สุด",
                  onPressed: () {},
                ),
              ));
            },
            icon: const Icon(Icons.check),
            label: const Text("ตรวจทุกข้อ!!"),
          )
        ],
      ),
      body: DragAnswerScreen(
        questionItem: widget.questionItems[_currentQuestionNum],
      ),
      floatingActionButton: Wrap(
        alignment: WrapAlignment.end,
        children: [
          // FloatingActionButton(
          //   onPressed: () {
          //     widget.test[2] = 20;
          //     print(widget.test);
          //   },
          // ),
          FloatingActionButton(
            onPressed: _currentQuestionNum > 0 ? _prevQuestion : null,
            child: const Icon(Icons.navigate_before_rounded),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: _currentQuestionNum < widget.questionItems.length - 1
                ? _nextQuestion
                : null,
            child: const Icon(Icons.navigate_next_rounded),
          ),
        ],
      ),
    );
  }
}

import 'package:drag_exam_plek/model/question_item.dart';
import 'package:flutter/material.dart';

class MakingAnswerScreen extends StatefulWidget {
  const MakingAnswerScreen({super.key});

  @override
  State<MakingAnswerScreen> createState() => _MakingAnswerScreenState();
}

//

class _MakingAnswerScreenState extends State<MakingAnswerScreen> {
  late final List<QuestionItem> questionItems;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('หน้าสร้างคำถาม'),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Container();
          },
        ),
      ),
    );
  }
}

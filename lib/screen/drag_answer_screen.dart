import 'package:drag_exam_plek/model/question_item.dart';
import 'package:flutter/material.dart';
import 'package:drag_exam_plek/setting.dart';

class DragAnswerScreen extends StatefulWidget {
  const DragAnswerScreen({super.key, required this.questionItem});
  final QuestionItem questionItem;

  /*
  design structure

  mainQuestion = set of questions
  [in each question contain set of correct answers value]
  :: list of list

  answers = list of answer

  to UI
  questions{
    builder (questions.length) => {
      question {
        builder (answers.length) => {
            DragTarget
          }
      }
    }
  }

  answers {
    builder (answer.length) => {
      Draggable(
        text: answer.data
      )
    }
  }
  */

  @override
  State<DragAnswerScreen> createState() => _DragAnswerScreenState();
}

class _DragAnswerScreenState extends State<DragAnswerScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text("Answer"),
                  ...answers(),
                ],
              ),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text("Question"),
                ...questions(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox feedback(String answer) {
    return SizedBox(
        width: Setting.sizeAnswerW,
        height: Setting.sizeAnswerH,
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 164, 218, 231),
              border: Border.all(width: 5.0),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Text(
              answer,
              style: const TextStyle(
                  fontSize: 20, color: Color.fromARGB(255, 38, 108, 141)),
            ),
          ),
        ));
  }

  Widget answerTile(String answer) {
    if (answer == "") return blankAnswerTile();
    return SizedBox(
      width: Setting.sizeAnswerW,
      height: Setting.sizeAnswerH,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            border: Border.all(width: 5.0),
            borderRadius: BorderRadius.circular(20)),
        child: Center(child: Text(answer)),
      ),
    );
  }

  Widget blankAnswerTile() {
    return SizedBox(
      width: Setting.sizeAnswerW,
      height: Setting.sizeAnswerH,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            border: Border.all(width: 5.0),
            borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  List<Widget> answers() {
    List<Widget> out = [];
    //list builder
    for (var answer in widget.questionItem.answers) {
      out.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Draggable(
          data: answer,
          feedback: feedback(answer),
          childWhenDragging: answerTile(""),
          child: answerTile(answer),
        ),
      ));
    }
    return out;
  }

  Widget qAnswerTile(String answer) {
    if (answer == "") return blankAnswerTile();
    return SizedBox(
      width: Setting.sizeAnswerW,
      height: Setting.sizeAnswerH,
      child: Container(
        decoration: BoxDecoration(
            color: Setting.showAnswer
                ? Colors.blueGrey.shade100
                : Colors.blueGrey.shade300,
            border: Border.all(width: 5.0),
            borderRadius: BorderRadius.circular(20)),
        child: Center(child: Text(answer)),
      ),
    );
  }

  Widget checkQAnswerTile(String answer, List<dynamic> correctAnswers) {
    if (answer == "") return blankAnswerTile();
    return SizedBox(
      width: Setting.sizeAnswerW,
      height: Setting.sizeAnswerH,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Setting.showAnswer
                      ? Colors.blueGrey.shade100
                      : Colors.blueGrey.shade300,
                  border: Border.all(width: 5.0),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text(answer)),
            ),
          ),
          correctAnswers.contains(answer)
              ? const Icon(Icons.check, color: Colors.green)
              : const Icon(Icons.clear, color: Colors.red)
        ],
      ),
    );
  }

  SizedBox questionTextWidget(String questionText) {
    return SizedBox(
      width: Setting.sizeAnswerW,
      height: Setting.sizeAnswerH,
      child: Center(child: Text(questionText)),
    );
  }

  List<Widget> questionAnswers(int answerAmout, int questionIndex) {
    List<Widget> out = [];
    for (int i = 0; i < answerAmout; i++) {
      out.add(Row(
        children: [
          DragTarget(
            builder: ((context, candidateData, rejectedData) {
              if (widget.questionItem.questions[questionIndex]["userAnswers"] ==
                  null) {
                widget.questionItem.questions[questionIndex]["userAnswers"] =
                    List.generate(answerAmout, (int index) => "",
                        growable: false);
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Setting.showAnswer
                    ? qAnswerTile(widget.questionItem.questions[questionIndex]
                        ["correctAnswers"][i])
                    : Setting.showOnlyOne
                        ? checkQAnswerTile(
                            widget.questionItem.questions[questionIndex]
                                ["userAnswers"][i],
                            widget.questionItem.questions[questionIndex]
                                ["correctAnswers"])
                        : qAnswerTile(widget.questionItem
                            .questions[questionIndex]["userAnswers"][i]),
              );
            }),
            onWillAccept: (data) => true,
            onAccept: (String data) {
              widget.questionItem.questions[questionIndex]["userAnswers"][i] =
                  data;
            },
            hitTestBehavior: HitTestBehavior.opaque,
          ),
          !Setting.showOnlyOne || (Setting.showOnlyOne && Setting.showAnswer)
              ? const SizedBox(
                  width: 20,
                )
              : Container(),
        ],
      ));
    }
    return out;
  }

  List<Widget> questions() {
    List<Widget> out = [];
    for (var question in widget.questionItem.questions) {
      int answerAmout = question["correctAnswers"].length;
      int questionIndex = widget.questionItem.questions.indexOf(question);
      out.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.blueGrey),
          child: Column(
            children: [
              questionTextWidget(question["questionText"]),
              ...questionAnswers(answerAmout, questionIndex),
            ],
          ),
        ),
      ));
    }
    return out;
  }
}

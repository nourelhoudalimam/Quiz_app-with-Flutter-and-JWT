
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_jwtapp/Controller/quizPageController.dart';

class QuizHome extends StatefulWidget {
  QuizHome({Key? key}) : super(key: key);

  @override
  _QuizHomeState createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  late quizPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(quizPageController());
    controller.initializeQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz App"),
        centerTitle: true,
      ),
      body: GetBuilder<quizPageController>(
        builder: (controller) {
    

      
          return Column(
            children: [
              Expanded(flex: 2, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Text(
                  controller.quiz.isNotEmpty && controller.ind < controller.quiz.length
 
                      ? controller.quiz[controller.ind].question
                      : "Loading...",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                ),
              ),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 6,
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          minWidth: 500,
                          color: controller.color == true &&
                                  controller.quiz[controller.ind]
                                          .answers[index] ==
                                      controller.quiz[controller.ind].correct
                              ? Colors.white
                              : Colors.blue,
                          onPressed: () {
                            controller.changeIndex(index);
                          },
                          child: Text(
                            controller.quiz.isNotEmpty
                                ? controller.quiz[controller.ind].answers[index]
                                : "",
                            style: TextStyle(
                              color: controller.color == true &&
                                      controller.quiz[controller.ind]
                                              .answers[index] ==
                                          controller.quiz[controller.ind]
                                              .correct
                                  ? Colors.blue
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Expanded(flex: 2, child: SizedBox()),
            ],
          );
        },
      ),
    );
  }
}

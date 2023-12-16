import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_jwtapp/Controller/quizPageController.dart';
import 'package:my_jwtapp/View/home.dart';
import 'package:my_jwtapp/View/quizHome.dart';

class ResultPage extends StatefulWidget{
   int result;
  ResultPage({Key?key,required this.result}):super(key:key);
   @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
 
  quizPageController controller=Get.find();
    @override
  void initState() {
    super.initState();
    controller = Get.find();
    controller.getText();
    controller.addScore(widget.result,controller.resultText); // Add this line to send the score to the server
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
body:Center(
  child:Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
       Text("Score",style:TextStyle(fontSize: 40,color:Colors.black)),
        Text(widget.result.toString(),style:TextStyle(fontSize: 40,color:Colors.black)),
        Text(controller.resultText,style:TextStyle(fontSize: 40,color:const Color.fromARGB(255, 6, 42, 104))),

      MaterialButton(color:Colors.blue,onPressed: (){
        controller.ind=0;
        controller.result=0;
        controller.update();
        Get.off(()=>QuizHome());
      },child:Text("restart",style:TextStyle(fontSize: 20,color:Colors.white)))
    ,
    const Expanded(flex:1,child: SizedBox()),
    MaterialButton(color:Colors.blue,onPressed: (){
        controller.ind=0;
        controller.result=0;
        controller.update();
        Get.off(()=>Home());
      },child:Text("Logout",style:TextStyle(fontSize: 20,color:Colors.white)))],
  )
),


    );
  }

}
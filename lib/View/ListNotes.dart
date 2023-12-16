import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:my_jwtapp/Controller/quizPageController.dart';

class ListNotes extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=>_ListNotePage();


}

class _ListNotePage extends State<ListNotes> {
   TextEditingController titleController=TextEditingController();
  TextEditingController desController=TextEditingController();
  late quizPageController controller;

@override
  void initState() {
    super.initState();
     controller = Get.put(quizPageController());
    controller.initializeNotes();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(appBar: AppBar(
    title:Text("CRUD App",style: TextStyle(color:Colors.white),),
    centerTitle: true,
    backgroundColor:const Color.fromARGB(255, 87, 9, 3) ,
   ),
body: GetBuilder<quizPageController>(
        builder: (controller) {
return  Column(
  children: [  Expanded(child:ListView.builder(
  
    itemCount: controller.scores.length,
  
    itemBuilder: (context,index){
  
  
  return ListTile(
  
    title: Text(controller.scores[index].result),
   subtitle: Text(controller.scores[index].score.toString()),
    trailing: Row(
  
      mainAxisSize: MainAxisSize.min,
  
      children: [
  
       
  
        TextButton(onPressed: (){
  
       controller.deleteNote(controller.scores[index].id);

  
      //   controller.getScores();
  
        }, child: Text("Delete"))
  
  
  
      ],
  
    ),
  
  );
  
  })),]
);
  }),);
  }

}
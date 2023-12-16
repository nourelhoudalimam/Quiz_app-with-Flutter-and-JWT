import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:my_jwtapp/Model/quizModel.dart';
import 'package:my_jwtapp/View/resultPage.dart';
import 'package:my_jwtapp/View/score.dart';
import 'package:my_jwtapp/service/api_service.dart';

class quizPageController extends GetxController{
  final ApiService apiService = ApiService("NourelHoudaLimam/24051999/09892244"); // Remplacez "votre_clé_secrète" par votre clé secrète réelle
   List<Score> scores= [];

   List<quizModel> quiz=[];
  int ind=0;
  int result=0;
  bool color=false;
  late String resultText;
   Future<void> initializeNotes() async {
    try {
    
    //  await exportDataToJsonAndPost();
       await getScores();
  
  } catch (e) {
    print('Erreur lors de la récupération des scores : $e');
  }
  }
  Future<void> initializeQuiz() async {
    try {
      await getQuizQuestions();
    } catch (e) {
      // Gérer les erreurs, par exemple, afficher un message à l'utilisateur
      print('Erreur lors de la récupération des questions : $e');
    }
  }
   // Méthode pour récupérer les questions depuis l'API sécurisée
  Future<void> getQuizQuestions() async {

  try {
    final String? jwt = await apiService.login(apiService.payload['email'].toString(), apiService.payload['password'].toString());

     if (jwt != null) {
      final Uri apiUrl = Uri.parse('http://192.168.1.26:3000/quizModel');
      final Map<String, String> headers = {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
      };

      final http.Response response = await http.get(apiUrl, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        quiz = data.map((json) => quizModel.fromJson(json)).toList();
        update(); // Met à jour l'UI avec les nouvelles questions
      } else {
        print('Erreur de requête : ${response.statusCode}');
        throw Exception('Erreur de requête');
      }
    } else {
      print('JWT non disponible');
      throw Exception('JWT non disponible');
    }
  } catch (e) {
    print('Erreur lors de la récupération des questions : $e');
    // Gérer les erreurs, par exemple, afficher un message à l'utilisateur
  }}
void changeIndex(index) {
  if (ind >= 0 && ind < quiz.length) {
    if (index >= 0 && index < quiz[ind].answers.length) {
      quiz[ind].answers[index] == quiz[ind].correct ? correct() : go();
      update();
    } else {
      // Handle an invalid answer index, maybe print a message or log it
      print('Invalid answer index: $index');
    }
  } else {
    // Handle an invalid quiz index, maybe print a message or log it
    print('Invalid quiz index: $ind');
  }
}

  go()async{ await    ind!=9?ind++:Get.off(()=> ResultPage(result: result,));
}
  correct()async{
    await Future.delayed(const Duration(milliseconds: 200));
    result+=10;
    color=true;
    update();
     ind!=9?
     ind++:Get.off(()=> ResultPage(result:result));
      color=false;update();
  }
  String getText(){
    if(result >=60){
      resultText="Excellent";
    }
    else if(result <=30){
      resultText="Bad";
    }
    else{resultText="Good";}
    return resultText;
  }
 
  Future<void> addScore(int score, String result) async {
  try {
    final String? jwt = await apiService.login(
        apiService.payload['email'].toString(),
        apiService.payload['password'].toString());

    if (jwt != null) {
      final Uri apiUrl = Uri.parse('http://192.168.1.26:3000/score');
      final Map<String, String> headers = {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> body = {
        'score': score,
        'result': result,
        'datetime': DateTime.now().toIso8601String(),
      };

      final http.Response serverResponse =
          await http.post(apiUrl, headers: headers, body: jsonEncode(body));

      if (serverResponse.statusCode == 200 || serverResponse.statusCode == 201) {
        print('Score added successfully to server');

        // Ensure the user is signed in
          
     
         const String firebaseDatabaseURL =
                'https://jwtshare-86dbe-default-rtdb.europe-west1.firebasedatabase.app/score.json';

            final http.Response firebaseResponse = await http.post(
              Uri.parse(firebaseDatabaseURL),
              headers: {
                
                'Content-Type': 'application/json',
              },
              body: jsonEncode(body),
            );

            if (firebaseResponse.statusCode == 200 ||
                firebaseResponse.statusCode == 201) {
              print('Score added successfully to Firebase');
            } else {
              print('Error adding score to Firebase: ${firebaseResponse.statusCode}');
              throw Exception('Error adding score to Firebase');
            }
        
      } else {
        print('Error adding score to server: ${serverResponse.statusCode}');
        throw Exception('Error adding score to server');
      }
    } else {
      print('JWT not available');
      throw Exception('JWT not available');
    }
  } catch (e) {
    print('Error adding score: $e');
    throw Exception('Error adding score');
  }
}

 Future<void> deleteNote(int ScoreId) async {
    try {
      final String? jwt = await apiService.accessData();
      if (jwt != null) {
        final Uri apiUrl = Uri.parse('http://192.168.1.26:3000/score/$ScoreId'); // Assuming your API supports deleting notes by ID
        final Map<String, String> headers = {
          'Authorization': 'Bearer $jwt',
        };

        final http.Response response = await http.delete(apiUrl, headers: headers);

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Note deleted successfully');
          scores.removeWhere((score) => score.id == ScoreId);
        update();
             String firebaseDatabaseURL =
                'https://jwtshare-86dbe-default-rtdb.europe-west1.firebasedatabase.app/score/$ScoreId.json';

            final http.Response firebaseResponse = await http.delete(
              Uri.parse(firebaseDatabaseURL),
              headers: {
                
                'Content-Type': 'application/json',
                    }            );

            if (firebaseResponse.statusCode == 200 ||
                firebaseResponse.statusCode == 201) {
              print('Score deleted successfully to Firebase');
            } else {
              print('Error deleting score to Firebase: ${firebaseResponse.statusCode}');
              throw Exception('Error deleting score to Firebase');
            }
        
        } else {
          print('Error deleting Score: ${response.statusCode}');
          throw Exception('Error deleting score');
        }
      } else {
        print('JWT not available');
        throw Exception('JWT not available');
      }
    } catch (e) {
      print('Error deleting note: $e');
      throw Exception('Error deleting score');
    }
  }

  
 Future<void> getScores() async {
  try {
    final String? jwt = await apiService.accessData();
    const apiUrl = 'http://192.168.1.26:3000/score';

    if (jwt != null) {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $jwt'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);

        // Use a try-catch block to handle errors during mapping
        try {
          scores = data.map((json) => Score.fromJson(json)).toList();
        update();
        } catch (e) {
          print('Error mapping JSON to Score: $e');
        }
      } else {
        print('Échec de la récupération des scores. Erreur: ${response.reasonPhrase}');
        return null;
      }
    } else {
      print('JWT non disponible');
      throw Exception('JWT non disponible');
    }
  } catch (e) {
    print('Erreur lors de la récupération des scores : $e');
    // Handle errors, e.g., display a message to the user
  }
}
  }
  


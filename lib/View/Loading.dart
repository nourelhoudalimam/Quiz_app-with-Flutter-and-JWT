// loading_page.dart

import 'package:flutter/material.dart';
import 'package:my_jwtapp/View/quizHome.dart';
import 'package:my_jwtapp/service/api_service.dart';

class LoadingPages extends StatefulWidget {
  final ApiService apiService;

  LoadingPages({required this.apiService});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPages> {

  @override
  void initState() {
    super.initState();
    _handleLogin();
  }

  void _handleLogin() async {
    // Simulate a delay (you can replace this with an actual operation)
    await Future.delayed(Duration(seconds: 2));

    // Perform your API service operations here

    // Use the result or perform further operations

    // After the API service operations, navigate to QuizHome or another page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizHome(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

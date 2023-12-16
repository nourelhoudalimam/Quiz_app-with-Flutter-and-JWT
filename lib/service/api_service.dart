import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';


class ApiService {
  final String secretKey;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

 final payload= {
    "email": "nourlimam25@gmail.com",
    "password": "Chaimahouidi24",
    "iat": 1516239022
  };

  ApiService(this.secretKey);

 
 Future<String?> accessData() async {
  
  try {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('jwt');

    DatabaseEvent event = await databaseReference.once();
    DataSnapshot dataSnapshot = event.snapshot;

    // Check if the 'jwt' key exists in the database
    if (dataSnapshot.value != null) {
      // If the key exists, return the jwt value
      String? jwt = dataSnapshot.value.toString();
      print("access to jwt");
      return jwt;
    } else {
      // If the key doesn't exist, return null or handle accordingly
      return null;
    }
  } catch (e) {
    print('Error reading jwt from Firebase: $e');
    return null;
  }}
  Future<String?> generateJwt() async {
    try {
     

      final header = {
        'alg': 'HS256',
        'typ': 'JWT',
      };

      final encodedHeader = base64Url.encode(utf8.encode(jsonEncode(header)));
      final encodedPayload = base64Url.encode(utf8.encode(jsonEncode(payload)));

      final signatureInput = '$encodedHeader.$encodedPayload';
      final hmac = Hmac(sha256, utf8.encode(secretKey));
      final signatureBytes = hmac.convert(utf8.encode(signatureInput)).bytes;
      final encodedSignature = base64Url.encode(signatureBytes);

      return '$encodedHeader.$encodedPayload.$encodedSignature';
    } catch (e) {
      print('Error during JWT generation: $e');
      return null;
    }
  }

  Future<bool> authenticateUser(String enteredEmail, String enteredPassword) async {
    try {
      final expectedEmail = payload['email'];
      final expectedPassword = payload['password'];
print(enteredEmail);
print(enteredPassword);
      return enteredEmail == expectedEmail && enteredPassword == expectedPassword;
    } catch (e) {
      print('Error during user authentication: $e');
      return false;
    }
  }
Future<void> storeJWT(String jwt) async {
 try {
    // Store the JWT locally using secureStorage
    await secureStorage.write(key: 'jwt_key', value: jwt);

    // Store the JWT on Firebase Realtime Database
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    await databaseReference.child('jwt').set(jwt);

  } catch (e) {
    print("Error storing JWT: $e");
  }    
  }




  Future<String> login(String email, String password) async {
   try{


      if (await authenticateUser(email, password)) {
        UserCredential usrCred=await FirebaseAuth.instance.signInWithEmailAndPassword(
          email:email,password:password
        );
        print("User logged in:${usrCred.user?.uid}");
        String idToken=await usrCred.user?.getIdToken()?? "";
        print("ID Token:$idToken");
        final jwt = await generateJwt();
        storeJWT(jwt!);
        storeJWT(idToken);
        print('Token: $jwt');
           

    // Get the user's Firebase ID token
  
        return 'Token: $jwt ';
      } else {
        return 'ERROR';
      }
  
    } catch (e) {
      print('Error during login: $e');
      return'ERROR';
    }
  }
 Future<String> loginDB(String webAPIKey,String email, String password) async {
   try{


      if (await authenticateUser(email, password)) {
        UserCredential usrCred=await FirebaseAuth.instance.signInWithEmailAndPassword(
          email:email,password:password
        );
     
        String idToken=await usrCred.user?.getIdToken()?? "";
        print("ID Token:$idToken");
       
        storeJWT(idToken);
        print('Token: $idToken');
           

    // Get the user's Firebase ID token
  
        return 'Token: $idToken ';
      } else {
        return 'ERROR';
      }
  
    } catch (e) {
      print('Error during login: $e');
      return'ERROR';
    }
  }
}

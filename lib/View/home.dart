
import 'package:flutter/material.dart';
import 'package:my_jwtapp/View/Loading.dart';
import 'package:my_jwtapp/service/api_service.dart';
class Home extends StatefulWidget {
//  final ApiService apiService;

  Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final formField=GlobalKey<FormState>();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
bool passToggle=true;
late ApiService apiService;

  bool isLoading = false;
  
@override
  void initState() {
    // TODO: implement initState
    super.initState();
        apiService = ApiService("NourelHoudaLimam/24051999/09892244"); // Replace with your actual secret key

  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(

    appBar: AppBar(title: Text("Login page"),
    centerTitle: true,),
    body:SingleChildScrollView(child: Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 60),
    child: Form(
      key:formField,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Image.asset("images/avatar.png", height:200,
    width:200),
    SizedBox(height: 50,),

    TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(labelText: "Email",
    border:OutlineInputBorder(),
    prefixIcon: Icon(Icons.email),
    ),
        validator:(value) {
bool emailValid = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value!);

          if(value!.isEmpty){return "Enter Email";}
       else if(!emailValid){
          return "Enter valid email";
        }
        }

),
        SizedBox(height: 20,),

    TextFormField(
      controller: passwordController,
      obscureText: passToggle,
      keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(labelText: "Password",
    border:OutlineInputBorder(),
    prefixIcon: Icon(Icons.lock),
    suffix:InkWell(
      onTap: (){
        setState(() {
          passToggle=!passToggle;
        }); },
        child:Icon(passToggle? Icons.visibility:Icons.visibility_off),

     
    )),
   validator:(value) {
          if(value!.isEmpty){return "Enter password";}
        
        else if(passwordController.text.length<8){
          return "Password length should be more than 6 characters";
        }
        }    ),
            SizedBox(height: 60,),

   /* if(formField.currentState!.validate()){
      print("Success");
      emailController.clear();
      passwordController.clear();
    }*/
  
  MaterialButton(
  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                minWidth: 500,
                
                color:Colors.blue
                , onPressed: () async {
                    if (formField.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      final email = emailController.text;
                      final password = passwordController.text;

                      final jwt = await apiService.login(email, password);

                      setState(() {
                        isLoading = false;
                      });

                      if (jwt != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoadingPages(apiService: apiService),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login failed. Please try again.')),
                        );
                      }
                    }
                  },
child:Text("Login",style:TextStyle(color:Colors.white)), ),



   ]
    
    ,)),),)
   );



  }
 


}
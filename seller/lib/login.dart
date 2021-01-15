import 'dart:convert';
import 'package:seller/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool wait=false;
  String mobile="",passkey="",token="";
  final FirebaseMessaging _firebaseMessaging=FirebaseMessaging();

  login()async{
    try{
      setState(() {
        wait=true;
      });
      await Firebase.initializeApp();
      await _firebaseMessaging.getToken().then((s){
          token=s;
      });

      Map data={
        'mobile':mobile,
        'passkey':passkey,
        'DToken':token,
      };

      final url="http://www.bluepapaya.in/AdvocateManager/login.php";
      final response=await http.post(url,body:data);

      if(response.statusCode==200)
      {
        Map res=jsonDecode(response.body);

        if(res['ok']=='1')
        {
          if(res['present']=='1')
          {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("auth",res['auth']);
            prefs.setString("direct",res['direct']);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>MyHomePage()),(Route<dynamic> route)=>false);
          }
          else
          {
            Toast.show("Wrong credential. Check your mobile number and login ID",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);        
          }
          
        }
        else
        {
          Toast.show("Something went wrong. Please try after sometime",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);      
        }
      }
      else
      {
        Toast.show("Something went wrong. Please try after sometime",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);  
      }

    }catch(e){
      // print(e);
      Toast.show("Something went wrong. Please try after sometime",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);  
    }finally{
      setState(() {
        wait=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advocate Manager"),
      ),
      body: wait==true?Center(child: CircularProgressIndicator()):
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
                      decoration: InputDecoration(
                        hintText: "Registered mobile number",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (s){
                        setState(() {
                          mobile=s;
                        });  
                      },
                  ),
          SizedBox(height:20),
          TextFormField(
                      decoration: InputDecoration(
                        hintText: "Login ID",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      obscureText: true,
                      
                      onChanged: (s){
                        setState(() {
                          passkey=s;
                        });  
                      },
                  ),
          SizedBox(height:20),

          MaterialButton(
            onPressed:(){
              if(checkMobile(mobile))
              {
                login();
              }
              else
              {
                Toast.show("Please enter correct mobile number",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);    
              }
            },
            child: Text("Login"),
            color: Colors.amberAccent,
          )

        ],
      )
    );
  }

  bool checkMobile(String m)
  {
    if(m.length!=10)
      return false;

    for(int i=0;i<10;i++)
    {
      if(m[i]!='0' && m[i]!='1' && m[i]!='2' && m[i]!='3' && m[i]!='4' && m[i]!='5' && m[i]!='6' && 
      m[i]!='7' && m[i]!='8' && m[i]!='9')
        return false;
    }
    return true;   
  }
}
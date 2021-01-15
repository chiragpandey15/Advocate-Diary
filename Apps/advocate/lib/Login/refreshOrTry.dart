import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RefreshOrTry extends StatefulWidget {
  @override
  _RefreshOrTryState createState() => _RefreshOrTryState();
}

class _RefreshOrTryState extends State<RefreshOrTry> {

  bool wait=false;
  String error="";


  Future<void>trial()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String auth=prefs.getString("login");
      
      Map <String,String>data={
        'auth':auth,
      };

      final url="http://www.bluepapaya.in/AdvocateManager/trial.php";
      final response =await http.post(url,body:data);

      if(response.statusCode==200)
      {
        Map res=jsonDecode(response.body);

        if(res['ok']=='1')
        {
          if(res['exp']=='0')
          {
            prefs.setString("expDate",res['expDate']);
            Navigator.of(context).pop(0);
          }
          else
          {
            error=res['message'];
          }
        }
      }


    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Advocate Manager"),
      ),
      body: wait==true?Center(child: CircularProgressIndicator()):
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                child: Text("7 days trial"),
                onPressed: (){
                  //trial
                  trial();
                },
                color: Colors.amberAccent,
              ),
            ],
          ),
          SizedBox(height: 20,),
          MaterialButton(
            child: Text("Regular use"),
            onPressed: (){
              Navigator.pushNamed(context,"/refresh").then((value){
                Navigator.of(context).pop(value);
              });
            },
            color: Colors.amberAccent,
          ),
          SizedBox(height: 25,),
          Text(
            error,
            style: TextStyle(
              color:Colors.red,
            ),
          ),
        ],
      )
    );
  }
}
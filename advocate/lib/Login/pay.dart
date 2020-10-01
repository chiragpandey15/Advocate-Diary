import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Pay extends StatefulWidget {
  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {

  bool wait=false;
  String mobile="",passkey="";

  Future<void>validate()async{
    try{
      setState(() {
        wait=true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email=prefs.getString("user_email");
      
      Map <String,String>data={
        'validatingID':mobile,
        'passkey':passkey,
        'email':email,
      };

      final url="http://192.168.43.235/Advocate/validate.php";
      print(url);
      print(data);
      final response =await http.post(url,body:data);
      print("In Pay");
      print(response.body);
      if(response.statusCode==200)
      {
        Map res=jsonDecode(response.body);
        if(res['ok']=='1')
        {
          DateTime now=DateTime.now();
          now=now.add(Duration(days: 365));
          int m=now.month;
          int d=now.day;
          
          String today=now.year.toString()+'-';
          if(m<10)
            today=today+"0"+m.toString()+"-";
          else
            today=today+m.toString()+"-";
          
          if(d<10)
            today=today+"0"+d.toString();
          else
            today=today+d.toString();

          print("Today==="+today);


          prefs.setString("expDate",today);
          prefs.setString("allowed",'1');
          Navigator.of(context).pop(1);
        }
        else
        {
          Toast.show("Something went wrong",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
        }
      }
      else
      {
        Toast.show("Something went wrong",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
      }

    }catch(e){
      print(e);
      Toast.show("Something went wrong",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     

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
        title:Text("Pay"),
      ),
      body: wait==true?Center(child:CircularProgressIndicator()):
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
                      decoration: InputDecoration(
                        hintText: "Mobile Number of seller",
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
            SizedBox(height:10),
            TextFormField(
                      decoration: InputDecoration(
                        hintText: "Passkey",
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
            SizedBox(height:10),
            MaterialButton(
              onPressed: (){
                validate();
              },
              child: Text("Validate"),
              color: Colors.amberAccent,
            ),
        ],
      ),
    );
  }
}
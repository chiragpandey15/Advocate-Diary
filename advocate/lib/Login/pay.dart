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

      Map <String,String>data={
        'validatingID':mobile,
        'passkey':passkey,
      };

      final url="http://192.168.43.235/Advocate/validate.php";

      final response =await http.post(url,body:data);

      if(response.statusCode==200)
      {
        Map res=jsonDecode(response.body);
        if(res['ok']=='1')
        {
          Navigator.pushNamed(context, "/verify",arguments: {'mobile':mobile});
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
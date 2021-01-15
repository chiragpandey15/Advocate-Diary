import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddCoordinator extends StatefulWidget {
  @override
  _AddCoordinatorState createState() => _AddCoordinatorState();
}

class _AddCoordinatorState extends State<AddCoordinator> {

  bool wait=false;
  String name="",mobile="",loginID="",passkey="",description="";


  Future<void>add()async{
    try{
      setState(() {
        wait=true;
      });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String auth=prefs.getString("auth");
    Map data={
      'auth':auth,
      'name':name,
      'mobile':mobile,
      'loginID':loginID,
      'passkey':passkey,
      'description':description
    };
    final url="http://www.bluepapaya.in/AdvocateManager/insertCoordinator.php";

    final response=await http.post(url,body:data);

    if(response.statusCode==200)
    {
      Map res=jsonDecode(response.body);

      if(res['ok']=='1' && res['done']=='1')
      {
        Toast.show("Successfully Added",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);              
        Navigator.of(context).pop();
      }
      else
        Toast.show("Something went wrong",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);            
      
    }
    else
    {
      Toast.show("Something went wrong",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);            
    }

    }catch(e){
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Add Coordinator"),
      ),
      body:wait==true?Center(child: CircularProgressIndicator()):
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height:10),
            TextFormField(
                        decoration: InputDecoration(
                          hintText: "Name of Coordinator",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onChanged: (s){
                          setState(() {
                            name=s;
                          });  
                        },
                    ),
            SizedBox(height:20),
            TextFormField(
                        decoration: InputDecoration(
                          hintText: "Mobile Number",
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
                            loginID=s;
                          });  
                        },
                    ),
            SizedBox(height:20),
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
            SizedBox(height:20),
            TextFormField(
                        decoration: InputDecoration(
                          hintText: "Place and other description",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onChanged: (s){
                          setState(() {
                            description=s;
                          });  
                        },
                    ),
            SizedBox(height:20),
            MaterialButton(
              onPressed:(){
                if(checkMobile(mobile))
                {
                  if(name.length>0 && loginID.length>0 && passkey.length>0 && description.length>0)
                    add();
                  else
                    Toast.show("All fields are required",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);      
                }
              },
              child: Text("Add"),
              color: Colors.amberAccent,
            )
          ],
        ),
      ),
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
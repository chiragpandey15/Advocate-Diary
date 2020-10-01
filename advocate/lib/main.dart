import 'dart:convert';

import 'package:advocate/Login/pay.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:advocate/Login/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advocate manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
      routes: {
        '/pay':(context)=>Pay(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  Future<void>validateFromServer()async{
    try{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String auth=prefs.getString("login");
      print("Valid From server");
      print("auth");
      final url="http://192.168.43.235/Advocate/validateFromServer.php?auth="+auth;
      print(url);
      final response =await http.get(url);
      print("Valid Response");
      print(response.body);
      if(response.statusCode==200)
      {
        Map res=jsonDecode(response.body);
        if(res['ok']=='1')
        {
          prefs.setString("expDate", res['expDate']);
          prefs.setString("allowed", res['allowed']);
          if(res['allowed']=='0')
          {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Note"),
                    content: Text("Ask seller to give confirmation."),
                    actions: [
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        }, 
                        child: Text("Ok"),
                      )
                    ],
                  );  
                },
              );
          }
        }
      }

    }catch(e){
      print(e);
    }
  }


  void pay(){
    Navigator.pushNamed(context, '/pay').then((value){
            if(value==1)
            {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Note"),
                    content: Text("Ask seller to give confirmation."),
                    actions: [
                      FlatButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        }, 
                        child: Text("Ok"),
                      )
                    ],
                  );  
                },
              );
            }

            // Fetch Data


          });
  }

  

  Future<void>checkPayment()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String _lastDate=prefs.getString("expDate");
      if(_lastDate!=null && _lastDate!='')
      {
        DateTime now =DateTime.now();
        print("lastDate="+_lastDate);
        DateTime lastDate=DateTime.parse(_lastDate);
        
        int difference=lastDate.difference(now).inDays;

        if(difference<30 && difference>0)
        {
         Toast.show(difference.toString()+" days are remaining. Buy today to get uninterupted service",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
        }
        else if(difference<0)
        {
          pay();
        } 
        validateFromServer();

        // Fetch Data


      }
      else
      {
        pay();
      }
    }catch(e){
      print(e);
    }
  }

  Future<void>checkLogin()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.clear();
      if(prefs.getString("login")==null)
      {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>Login()),(Route<dynamic> route)=>false);
      }
      else
      {
        checkPayment();
      }

    }catch(e){
      print(e);
    }finally{
      
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Advocate Manager"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_today_rounded,
              size: 35,
            ),
            onPressed: null
          ),
          SizedBox(width:20),
        ],
      ),
      body: Text(""),
      floatingActionButton: FloatingActionButton(
                              onPressed: null,
                              child: Icon(Icons.add),
                            ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height:30,
            ),
            Column(
            children:<Widget>[
                CircleAvatar(
                    
                ),
                Text("Name"),
              ],
            ),
            Card(
              child: InkWell(
                onTap:(){},
                child:Row(
                    children: <Widget>[
                      Icon(Icons.book),
                      Text("Add Case"),
                    ],
                 ),
              ),
            ),
            Card(
              child: InkWell(
                onTap:(){},
                child:Row(
                    children: <Widget>[
                      Icon(Icons.message),
                      Text("Messages"),
                    ],
                 ),
              ),
            ),
            Card(
              child: InkWell(
                onTap:(){},
                child:Row(
                    children: <Widget>[
                      Icon(Icons.bookmark),
                      Text("Tomorrow's Cases"),
                    ],
                 ),
              ),
            ),
            Card(
              child: InkWell(
                onTap:(){},
                child:Row(
                    children: <Widget>[
                      Icon(Icons.calendar_today_rounded),
                      Text("Search by Date"),
                    ],
                 ),
              ),
            ),

            Card(
              child: InkWell(
                onTap:(){},
                child:Row(
                    children: <Widget>[
                      Icon(Icons.search_rounded),
                      Text("Search by Client"),
                    ],
                 ),
              ),
            ),
            Card(
              child: InkWell(
                onTap:(){},
                child:Row(
                    children: <Widget>[
                      Icon(Icons.logout),
                      Text("Logout"),
                    ],
                 ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

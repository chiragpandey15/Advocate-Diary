import 'package:advocate/Login/pay.dart';
import 'package:advocate/Login/verify.dart';
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
        '/verify':(context)=>Verify()
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

    }catch(e){
      print(e);
    }
  }

  Future<void>checkPayment()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getString("payment")==null)
      {
        String _lastDate=prefs.getString("payLastDate");
        DateTime now =DateTime.now();
        DateTime lastDate=DateTime.parse(_lastDate);

        int difference=now.difference(lastDate).inDays;

        if(difference<30)
        {
         Toast.show(difference.toString()+" days are remaining. Buy today to get uninterupted service",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
        }
        else if(difference<-2)
        {
          prefs.remove("payment");
          prefs.remove("payLastDate");
          Navigator.pushNamed(context, '/pay');
        }
        else{
          validateFromServer();
        }
      }
      else
      {
        Navigator.pushNamed(context, '/pay');
      }
    }catch(e){
      print(e);
    }
  }

  Future<void>checkLogin()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
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
      ),
      body: Text(""),
    );
  }
}

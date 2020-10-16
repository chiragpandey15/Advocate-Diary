import 'dart:convert';

import 'package:advocate/Login/pay.dart';
import 'package:advocate/caseByDate.dart';
import 'package:advocate/editCase.dart';
import 'package:advocate/editDate.dart';
import 'package:advocate/searchByClient.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:advocate/Login/login.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/database.dart';
import 'package:advocate/Storage/driveStorage.dart';
import 'package:advocate/addCase.dart';
import 'package:advocate/perticaularCase.dart';
import 'package:advocate/page.dart';
import 'package:advocate/addDate.dart';
import 'package:advocate/Message/message.dart';
import 'package:advocate/Message/perticularMessage.dart';
import 'package:advocate/Message/sendSMS.dart';

import 'dart:io';
import 'package:sqflite/sqflite.dart';
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
        '/addCase':(context)=>AddCase(),
        '/perticularCase':(context)=>PerticaularCase(),
        '/searchByClient':(context)=>SearchByClient(),
        '/searchByDate':(context)=>CaseByDate(),
        '/editCase':(context)=>EditCase(),
        '/editDetails':(context)=>EditDate(),
        '/page':(context)=>Pages(),
        '/addDetails':(context)=>AddDate(),
        '/message':(context)=>Message(),
        '/perticularMessage':(context)=>PerticularMessage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  
  List<Case>todaysCase=List();
  bool wait=false;

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

          });
  }

  Future<void>getTodaysList()async{
    try{
      setState(() {
        wait=true;
      });
      print("Here we are");
      DateTime now =DateTime.now();
      String today=now.year.toString()+"-"+now.month.toString()+"-"+now.day.toString();
      print(today);
      DbHelper dB=DbHelper();
      todaysCase=await dB.getCaseByDate(today);
      print(todaysCase);
    }catch(e){
      print(e);
    }finally{
      setState((){
        wait=false;
      });
    }
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
        getTodaysList();
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

  String getMessage(String msg){
    String exp="";
    DateTime now=DateTime.now();
    now=now.add(Duration(days: 1));
    String date=now.day.toString()+"-"+now.month.toString()+"-"+now.year.toString();
    
    for(int i=0;i<msg.length;i++)
    {
      if(i<msg.length-1 && msg[i]=="#" && (msg[i+1]=='1' || msg[i+1]=='2' || msg[i+1]=='3' || msg[i+1]=='4'))
      {
        exp+=date;
        i++;
      }
      else
        exp=exp+msg[i];
    }
    return exp;
  }

  Future<void>sendReminder()async{
    try{
      DbHelper dB=DbHelper();
      Map msg=await dB.getMessage(2);
      String messageText=msg['textMessage'];
      int allowed=msg['allowed'];
      if(allowed==1)
      {
        String message=getMessage(messageText);
        
        DateTime now=DateTime.now().add(Duration(days: 1));
        String today=now.year.toString()+"-"+now.month.toString()+"-"+now.day.toString();
        
        List<Case> tomorrowCase=await dB.getCaseByDate(today);
        
        SendSMS sms=SendSMS();
        for(int i=0;i<tomorrowCase.length;i++)
        {
          if(tomorrowCase[i].messagePermission==true)
          {
            sms.send(message,tomorrowCase[i].clientMobile);
          }
        }
      }


    }catch(e){
      print(e);
    }
  }

  Future<void>checkReminder()async{
    try{

      DateTime now=DateTime.now();
      print(now.hour);
      if(now.hour>17)
      {
        SharedPreferences prefs = await SharedPreferences.getInstance(); 
        String reminderLastDate=prefs.getString("reminderLastDate");
        String nowString=now.day.toString()+"-"+now.month.toString()+"-"+now.year.toString();
        
        if(nowString==reminderLastDate)
          return;

        sendReminder();
        await prefs.setString("reminderLastDate",nowString);  
      }

      


    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkLogin();
    checkReminder();
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkReminder();
    }
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
            onPressed: ()async{
              // DriveStorage dS=DriveStorage();
              // await dS.updateToDrive();
              // print("Update Ho gaya dude");

              selectPreviousDate(context);
            }
          ),
          SizedBox(width:20),
          IconButton(
            icon: Icon(Icons.login), 
            onPressed: (){
              DbHelper dB=DbHelper();
              dB.log();
            }
          ),
          SizedBox(width:20),
          IconButton(
            icon: Icon(Icons.outbond), 
            onPressed: ()async{
              String path=await getDatabasesPath();
              File f=File(path+"/advocate.db");
              List<int>read=await f.readAsBytes();
              print(read);
              
              DriveStorage dS=DriveStorage();
              await dS.downloadGoogleDriveFile();
              print("Downloaded wala upper hai aur read wala niche");
              
              
              // File temp=File(p);
              // String read=await temp.readAsString();
              // print("File read");
              // print(read);
            }
          ),
        ],
      ),
      body: wait==true?Center(
        child:CircularProgressIndicator(),
      ):
      ListView.builder(
        itemCount: todaysCase.length,
        itemBuilder: (context,index){
          return Card(
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/perticularCase',arguments: {'case':todaysCase[index]}).then((s){
                  getTodaysList();
                });
              },
              child:Column(
                children:<Widget>[
                  Text(
                      todaysCase[index].caseNumber.toString(),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      Text(
                        todaysCase[index].clientName,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      todaysCase[index].opponent==""?Text(''):
                      Text(
                        "vs "+todaysCase[index].opponent,
                        style: TextStyle(
                          color:Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]
                  ),
                ]
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
                              onPressed: (){
                                Navigator.pushNamed(context, '/addCase',);
                              },
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
                onTap:(){
                  Navigator.pushNamed(context, '/addCase',);
                },
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
                onTap:(){
                  Navigator.pushNamed(context, '/message');
                },
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
                onTap:(){
                  DateTime now=DateTime.now().add(Duration(days: 1));
                  String requireDate=now.year.toString()+"-"+now.month.toString()+"-"+now.day.toString();
                  Navigator.pushNamed(context, '/searchByDate',arguments: {'date':requireDate}).then((value){
                    getTodaysList();
                  });     
                },
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
                onTap:(){
                  selectPreviousDate(context);
                },
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
                onTap:(){
                  Navigator.pushNamed(context, '/searchByClient',).then((value){
                    getTodaysList();
                  });
                },
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

  Future<void>getCases()async{
    try{
      
      setState(() {
        wait=true;
      });

      String date=DateTime.now().day.toString()+"-"+DateTime.now().month.toString()+"-"+DateTime.now().year.toString();
      DbHelper dB=DbHelper();
      dB.getCaseByDate(date).then((value){
        todaysCase=value;
      });

    }catch(e){
      print(e);
    }finally{
      setState(() {
        wait=false;
      });
    }
  }

  Future<void>selectPreviousDate(BuildContext context) async{
    String requireDate="";
    final DateTime picked = await showDatePicker(
        context: context,
        helpText: "Next Date",
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2032));
    if (picked != null)
    {
      requireDate=picked.year.toString()+"-"+picked.month.toString()+"-"+picked.day.toString();
      Navigator.pushNamed(context, '/searchByDate',arguments: {'date':requireDate}).then((value){
        getTodaysList();
      });      
    }
  }

}

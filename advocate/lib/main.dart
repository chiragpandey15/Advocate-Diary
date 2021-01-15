import 'dart:convert';

import 'package:advocate/Login/refresh.dart';
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
import 'package:advocate/handbook.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:advocate/account.dart';
import 'package:advocate/Login/refreshOrTry.dart';
import 'package:advocate/guidelines.dart';
import 'package:advocate/contact.dart';

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
        '/refresh':(context)=>Refresh(),
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
        '/handbook':(context)=>Handbook(),
        '/account':(context)=>Account(),
        '/refreshOrTry':(context)=>RefreshOrTry(),
        '/guidelines':(context)=>Guidelines(),
        '/contact':(context)=>Contact()
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
  bool wait=false,update=false;
  String name="",image="",updateURL="";


  checkUpdate(String url,String updateDate)async
  {
    updateURL=url;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("updateURL", url);
    String lastUpdate=prefs.getString("updateDate");
    DateTime a=DateTime.parse(updateDate);
    DateTime b=DateTime.parse(lastUpdate);
    int day=a.difference(b).inDays;
    
    print("Day==="+day.toString());
    print(a);
    print(b);

    if(day>0)
    {
      setState((){
        update=true;
      });
    }
  }

  Future<void>validateFromServer()async{
    try{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String auth=prefs.getString("login");
      
      final url="http://www.bluepapaya.in/AdvocateManager/validateFromServer.php?auth="+auth;
      
      final response =await http.get(url);
      if(response.statusCode==200)
      {
        Map res=jsonDecode(response.body);
        print("From Server");
        print(res);
        if(res['ok']=='1')
        {
          prefs.setString("expDate", res['expDate']);
          prefs.setString("allowed", res['allowed']);
          prefs.setString("ipc", res['ipc']);
          prefs.setString("crpc", res['crpc']);
          prefs.setString("iea", res['iea']);
          prefs.setString("cpc", res['cpc']);
          prefs.setString("coi", res['coi']);

          if(res['allowed']=='0')
          {
            Navigator.pushNamed(context, '/refresh').then((value){
            if(value==1)
            {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Note"),
                    content: Text("Ask Coordinator to give confirmation."),
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

            else
            {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Note"),
                    content: Text("Contact Coordinator for any query."),
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
            // showDialog(
            //     context: context,
            //     builder: (context) {
            //       return AlertDialog(
            //         title: Text("Note"),
            //         content: Text("Ask Coordinator to give confirmation."),
            //         actions: [
            //           FlatButton(
            //             onPressed: (){
            //               Navigator.of(context).pop();
            //             }, 
            //             child: Text("Ok"),
            //           )
            //         ],
            //       );  
            //     },
            //   );
          }
          checkUpdate(res['updateURL'],res['updateDate']);
        }
      }

    }catch(e){
      print(e);
    }
  }


  void refresh(){
    Navigator.pushNamed(context, '/refresh').then((value){
            if(value==1)
            {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Note"),
                    content: Text("Ask Coordinator to give confirmation."),
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

            else
            {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Note"),
                    content: Text("Contact Coordinator for any query."),
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      name=prefs.getString("user_name");
      image=prefs.getString("user_photoUrl");
      

      DateTime now =DateTime.now();
      String today=now.year.toString()+"-"+now.month.toString()+"-"+now.day.toString();
      DbHelper dB=DbHelper();
      todaysCase=await dB.getCaseByDate(today);
    }catch(e){
      print(e);
    }finally{
      setState((){
        wait=false;
      });
    }
  }

  Future<void>checkRefreshment()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String _lastDate=prefs.getString("expDate");
      if(_lastDate!=null && _lastDate!='')
      {
        DateTime now =DateTime.now();
        DateTime lastDate=DateTime.parse(_lastDate);
        
        int difference=lastDate.difference(now).inDays+1;

        if(difference<30 && difference>0)
        {
         Toast.show(difference.toString()+" days are remaining. Buy today to get uninterupted service",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
        }
        else if(difference<0)
        {
          refresh();
        }
        if(prefs.getString("expDate")!=null) 
          validateFromServer();
        
        getTodaysList();
        // Fetch Data

      }
      else
      {
        refresh();
      }
    }catch(e){
      print(e);
    }
  }

  Future<void>checkLogin()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var status=await Permission.sms.isGranted;
      while(status==false)
      {
        var cur=await Permission.sms.request();
        status=cur.isGranted;
        if(status==false)
          Toast.show("We require SMS permission to serve you better.",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
        else if(prefs.getString("login")==null)
        {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>Login()),(Route<dynamic> route)=>false);
        }
      }


      
      
      // prefs.clear();
      if(prefs.getString("login")==null)
      {
        
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>Login()),(Route<dynamic> route)=>false);
      }
      else
      {
        checkReminder();
        checkRefreshment();
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
        if(msg[i+1]=='1')
          exp+=date;
        // else if(msg[i+1]=='3')
        //   exp+=paymentDemand;
        // else if(msg[i+1]=='4')
        //   exp+=clientName;
        // else if(msg[i+1]=='2') 
        // {
        //  String time=await getTime();
        //  exp+=time; 
        // }

        i++;
      }
      else
        exp=exp+msg[i];
    }
    return exp;
  }

  Future<bool>sendReminder()async{
    try{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String expDate=prefs.getString("expDate");
      if(expDate==null)
      {
        return false;      
      }
      else
      {
        DateTime lastDate=DateTime.parse(expDate);
        DateTime now=DateTime.now();

        int difference=lastDate.difference(now).inDays;
        if(difference<-1)
        {
          return false;
        }
      }
      

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
        return true;
      }


    }catch(e){
      print(e);
    }
    return false;
  }

  Future<void>checkReminder()async{
    try{

      DateTime now=DateTime.now();
      if(now.hour>17)
      {
        SharedPreferences prefs = await SharedPreferences.getInstance(); 
        String reminderLastDate=prefs.getString("reminderLastDate");

        String day=now.day.toString();

        if(now.day<10)
          day="0"+day;

        String month=now.month.toString();

        if(now.month<10)
          month="0"+month;

        String year=now.year.toString();

        String nowString=year+"-"+month+"-"+day;
        

        if(nowString!=reminderLastDate)
        {
          bool res=await sendReminder();
          if(res==true)
          {
            // await prefs.setString("reminderLastDate",nowString);  
          }
        }

        now=now.add(Duration(days:1));
        
        day=now.day.toString();

        if(now.day<10)
          day="0"+day;

        month=now.month.toString();

        if(now.month<10)
          month="0"+month;

        year=now.year.toString();

        nowString=year+"-"+month+"-"+day;

        Navigator.pushNamed(context, '/searchByDate',arguments: {'date':nowString}).then((value){
                    getTodaysList();
                  });
      }

      


    }catch(e){
      print(e);
    }
  }


  Future<String> getPhoto()async{
    
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    String res=prefs.getString("user_photoUrl");
    return res;
  }

  Future<String> getName()async{
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    String res= prefs.getString("user_name");
    return res;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkLogin();
    
    DriveStorage dS=DriveStorage();
    dS.backUpToDrive();
  }

  logout()async{
    GoogleSignIn _googleSignIn=new GoogleSignIn();
    _googleSignIn.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    prefs.remove("login");
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>Login()),(Route<dynamic> route)=>false);
  }
  


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkLogin();
      
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

              selectPreviousDate(context);
            }
          ),
          SizedBox(width:20),
          
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
                SizedBox(height:10),
                CircleAvatar(
                    child: Image.network(image),
                ),
                Text(name),
              ],
            ),
            Card(
              child: InkWell(
                onTap:(){
                  Navigator.pushNamed(context, '/addCase',);
                },
                child:Row(
                    children: <Widget>[
                      Icon(
                        Icons.book,
                        size: 35,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Add Case",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
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
                      Icon(
                        Icons.message,
                        size: 35,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Messages",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
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
                      Icon(
                        Icons.bookmark,
                        size: 35,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Tomorrow's Cases",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
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
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 35,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Search by Date",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
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
                      Icon(
                        Icons.search_rounded,
                        size: 35,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Search",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                 ),
              ),
            ),

            Card(
              child: InkWell(
                onTap:(){
                  Navigator.pushNamed(context, '/handbook',).then((value){
                    getTodaysList();
                  });
                },
                child:Row(
                    children: <Widget>[
                      Icon(
                        Icons.note,
                        size: 35,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Handbook",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                 ),
              ),
            ),

            Card(
              child: InkWell(
                onTap:(){
                  refresh();
                },
                child:Row(
                    children: <Widget>[
                      Icon(
                        Icons.cached,
                        size: 35,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Refresh Account", //ready to use
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                 ),
              ),
            ),

            Card(
              child: InkWell(
                onTap:(){
                  Navigator.pushNamed(context, '/guidelines',arguments: {'update':update,'url':updateURL});
                },
                child:Row(
                    children: <Widget>[
                      Icon(
                        Icons.ac_unit,
                        size: 35,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Guidelines and update",
                        style: TextStyle(
                          fontSize: 20,
                          color:update?Colors.red:Colors.black,
                        ),
                      ),
                    ],
                 ),
              ),
            ),

            Card(
              child: InkWell(
                onTap:(){
                  Navigator.pushNamed(context, '/contact',);
                },
                child:Row(
                    children: <Widget>[
                      Icon(
                        Icons.feedback,
                        size: 35,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Feedback",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                 ),
              ),
            ),


            Card(
              child: InkWell(
                onTap:(){
                  logout();
                },
                child:Row(
                    children: <Widget>[
                      Icon(
                        Icons.logout,
                        size: 35,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
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
      String day=picked.day.toString();
      
      if(picked.day<10)
        day="0"+day;
      requireDate=picked.year.toString()+"-"+picked.month.toString()+"-"+day;
      Navigator.pushNamed(context, '/searchByDate',arguments: {'date':requireDate}).then((value){
        getTodaysList();
      });      
    }
  }

}

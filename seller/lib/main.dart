import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:seller/login.dart';
import 'package:seller/profile.dart';
import 'package:seller/addCoordinator.dart';
import 'package:seller/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advocate Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        '/profile':(context)=>Profile(),
        '/addCoordinator':(context)=>AddCoordinator(),
        '/edit':(context)=>Edit(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class Customer{
  String mobile,name,email;
  Customer(this.mobile,this.name,this.email);
}

class _MyHomePageState extends State<MyHomePage> {
  
  bool wait=false,direct=false;
  Customer customer;
  final FirebaseMessaging _firebaseMessaging=FirebaseMessaging();
  List coordinator=List();

  Future<void>getCustomer()async{
    try{
      setState((){
        wait=true;
      });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String auth=prefs.getString("auth");
    Map data={'auth':auth};
    final url="http://www.bluepapaya.in/AdvocateManager/yetToConfirm.php";

    final response=await http.post(url,body:data);
    // print(response.body);
    if(response.statusCode==200)
    {
      Map res=jsonDecode(response.body);

      if(res['ok']=='1')
      {
        if(res['present']=='1')
        {
          customer=Customer(res['mobile'],res['name'],res['email']);
          
        }
      }
      else
      {
        Toast.show("Something went wrong. Please check your internet connection and try again.",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);      
      }
    }
    else
      Toast.show("Something went wrong. Please check your internet connection and try again.",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);    
      

    }catch(e){
      // print(e);
      Toast.show("Something went wrong. Please check your internet connection and try again.",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);    
    }finally{
      setState(() {
        wait=false;
      });
    }
  }


  Future<void>request(String responseOfSeller)async{
    try{
      // make request
      setState(() {
        wait=true;
      });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String auth=prefs.getString("auth");
    Map<String,String>data={
      'auth':auth,
      'email':customer.email,
      'response':responseOfSeller,
    };
    final url="http://www.bluepapaya.in/AdvocateManager/confirm.php";

    final response=await http.post(url,body:data);
    // print(response.body);
    if(response.statusCode==200)
    {
      Map res=jsonDecode(response.body);
      if(res['ok']=='1')
      {
        customer=null;
        Toast.show("Done",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);  
      }
      else
      {
        Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);  
      }
    }
    else
      Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);    

    }catch(e){
      Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);  
    }finally{
      setState(() {
        wait=false;
      });
    }
  }


  confirm(){
    showDialog(
      context:context,
      builder:(context){
        return AlertDialog(
          title:Text("Confirm"),
          content: Text("Are you sure you want to confirm"),
          actions: [
            FlatButton(
              onPressed:(){
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            FlatButton(
              onPressed:(){
                Navigator.of(context).pop();
                request("Confirm");
              },
              child: Text("Yes"),
            ),
          ],
        );
      }
    );
  }



  cancel(){
    showDialog(
      context:context,
      builder:(context){
        return AlertDialog(
          title:Text("Cancel"),
          content: Text("Are you sure you want to cancel"),
          actions: [
            FlatButton(
              onPressed:(){
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            FlatButton(
              onPressed:(){
                Navigator.of(context).pop();
                request("Cancel");
              },
              child: Text("Yes"),
            ),
          ],
        );
      }
    );
  }


  Future<void>getCoordinator()async{
    try{
      setState(() {
        wait=true;
      });
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String auth=prefs.getString("auth");

      Map data={'auth':auth};
      final url="http://www.bluepapaya.in/AdvocateManager/getCoordinator.php";

      final response=await http.post(url,body:data);
      // print(response.body);
      if(response.statusCode==200)
      {
        coordinator=jsonDecode(response.body);
      }
      else
      {
        Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);            
      }

    }catch(e){
      // print(e);
      Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);    
    }finally{
      setState((){
        wait=false;
      });
    }
  }

  checkLogin()async{
    try{
      setState(() {
        wait=true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getString("auth")==null)
      {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>Login()),(Route<dynamic> route)=>false);
      }
      else
      {
        direct=prefs.getString("direct")=='1'?true:false;
        if(direct)
          getCustomer();
        else
          getCoordinator();
      }

    }catch(e){
      Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);    
    }
  }


  Future<void>block(String mobile,String res)async{
    try{
      setState(() {
        wait=true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String auth=prefs.getString("auth");

      Map <String,String>data={
        'auth':auth,
        'response':res,
        'mobile':mobile,
      };
      final url="http://www.bluepapaya.in/AdvocateManager/block.php";

      final response=await http.post(url,body:data);
      if(response.statusCode==200)
      {
        await getCoordinator();
      }
      else
      {
        Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);            
      }

    }catch(e){
      // print(e);
      Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);    
    }finally{
      setState(() {
        wait=false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
    _firebaseMessaging.configure(
      onMessage: (Map<String,dynamic> msg) async{
        // print(msg);
        customer=Customer(msg['mobile'],msg['name'],msg['email']);
        setState((){
          wait=false;
        });
      },
      onResume:(Map<String,dynamic> msg) async{
        // print(msg);
        customer=Customer(msg['mobile'],msg['name'],msg['email']);
        setState((){
          wait=false;
        });
      },
      onLaunch: (Map<String,dynamic> msg) async{
        
      }, 
    );

    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true,badge:true,alert: true)
    );
  }


  @override
  Widget build(BuildContext context) {



    if(direct==false)
    {
      return Scaffold(
        appBar: AppBar(
          title:Text("Advocate Manager"),
        ),
        body:wait==true?Center(child: CircularProgressIndicator()):
        ListView.builder(
          itemCount: coordinator.length,
          itemBuilder: (context,index){
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children:[
                      Text(
                      "Name: "+coordinator[index]['name'],
                      style: TextStyle(
                        fontSize:16,
                      ),
                    ),
                    SizedBox(height:10),
                    Text(
                      "Mobile: "+coordinator[index]['mobile'],
                      style: TextStyle(
                        fontSize:16,
                      ),
                    ),
                    SizedBox(height:10),
                    Text(
                      "Login ID: "+coordinator[index]['loginID'],
                      style: TextStyle(
                        fontSize:16,
                      ),
                    ),
                    SizedBox(height:10),
                    Text(
                      "Count: "+coordinator[index]['count'],
                      style: TextStyle(
                        fontSize:16,
                      ),
                    ),
                    SizedBox(height:10),
                    Text(
                      "Description: "+coordinator[index]['description'],
                      style: TextStyle(
                        fontSize:16,
                      ),
                    ),
                    SizedBox(height:10),
                    Text(
                      coordinator[index]['allowed']=='1'?"Allowed":"Blocked",
                      style: TextStyle(
                        fontSize:16,
                      ),
                    ),
                    SizedBox(height:10),
                    MaterialButton(
                      onPressed: (){
                        Navigator.pushNamed(context, "/edit",arguments: 
                        {
                          'mobile':coordinator[index]['mobile'],
                          'name':coordinator[index]['name'],
                          'description':coordinator[index]['description'],
                          'allowed':coordinator[index]['allowed']
                        }).then((value){
                          getCoordinator();
                        });
                      },
                      child: Text("Edit"),
                      color: Colors.grey,
                    )
                  ]
                ),
              )
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
                                      onPressed: (){
                                        Navigator.pushNamed(context,"/addCoordinator").then((value){
                                          getCoordinator();
                                        });
                                      },
                                      child: Icon(Icons.add),                          
                                    ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Advocate Manager"),
        actions: [
          IconButton(
            onPressed:(){
              Navigator.pushNamed(context, "/profile");
            },
            icon: Icon(
              Icons.account_circle,
              size:35,
            ),
          ),
          SizedBox(width:10),
        ],
      ),
      body:wait==true?Center(child:CircularProgressIndicator()):
      customer==null?Center(child: Text("Nothing to show")):
      Card(
        child: Column(
          children:[
            Text(
              "Name: "+customer.name,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height:20),  
            Text(
              "Mobile: "+customer.mobile,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height:20),
            Text(
              "Email: "+customer.email,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height:20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: (){
                    cancel();
                  },
                  child: Text("Cancel"),
                  color: Colors.red,
                ),
                MaterialButton(
                  onPressed: (){
                    confirm();
                  },
                  child: Text("Confirm"),
                  color: Colors.green,
                ),
              ],
            ),
          ]
        ),
      ),
   );
  }
}

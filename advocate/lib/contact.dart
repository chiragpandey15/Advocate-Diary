import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {

  bool wait=false;
  String feedback="";


  Future<void>sendFeedback()async{
    try{

      setState((){
        wait=true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String auth=prefs.getString('login');

      Map<String,String>data={
        'feedback':feedback,
        'auth':auth,
      };
      
      final url="http://www.bluepapaya.in/AdvocateManager/feedback.php";
      
      final response =await http.post(url,body:data);

      if(response.statusCode==200)
        Toast.show("Thanks for your feedback",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
      else
        Toast.show("Something went wrong.",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     

    }catch(e){
      print(e);
      
    }finally{
      setState((){
        wait=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback/Query"),
      ),
      body:wait==true?Center(child:CircularProgressIndicator()):
      Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          TextFormField(
                    decoration: InputDecoration(
                      hintText: "Feedback/complain/query",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 5,
                    onChanged: (s){
                        feedback=s;
                    },
                ),
          SizedBox(height:20),
          MaterialButton(
            onPressed: (){
              if(feedback!="")
              {
                sendFeedback();
              }
            },
            child: Text("Send"),
            color: Colors.amberAccent,
          )
        ],
      )
    );
  }
}
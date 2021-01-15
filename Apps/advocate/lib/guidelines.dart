import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class Guidelines extends StatefulWidget {
  @override
  _GuidelinesState createState() => _GuidelinesState();
}

class _GuidelinesState extends State<Guidelines> {

  Map map=Map();
  bool wait=false,update=false,visited=false;
  String url="";

  launchUrl()async{
    try{

      if(update==false)
      {
        Toast.show("Your app is already updated",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
        return;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      DateTime now=DateTime.now();
      
      String today=now.year.toString();

      if(now.month<10)
        today=today+"-0"+now.month.toString();
      else
        today=today+"-"+now.month.toString();

      if(now.day<10)
      {
        today=today+"-0"+now.day.toString();
      }
      else
        today=today+"-"+now.day.toString();

      prefs.setString("updateDate", today);
      update=false;


      if(url=="" || url==null)
        url="https://drive.google.com/file/d/1eHwVZwcF_Sc8clYc23aVJWXuVpOAESrG/view?usp=sharing";

      if(await canLaunch(url))
      {
        await launch(url);
      }
      else
        throw "Some error occured";

    }catch(e){
      Toast.show(e,context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);
    }
  }


  @override
  Widget build(BuildContext context) {

    map=ModalRoute.of(context).settings.arguments;
    if(visited==false)
    {
      visited=true;
      update=map['update'];
      url=map['url'];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Guidelines"),
      ),
      body:Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          Text(
            "Do not use the app with the same account alternatively on two different device as it may lead to data loss.",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
          SizedBox(height:30),
          MaterialButton(
            onPressed: (){
              launchUrl();
            },
            child: Text("Update"),
            color: update?Colors.red:Colors.amberAccent,
          )
        ],
      ),
    );
  }
}
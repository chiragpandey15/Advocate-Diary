import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Message"),
      ),
      body: Column(
        children:[
          MaterialButton(
            onPressed:(){
              Navigator.pushNamed(context, '/perticularMessage',arguments: {'ID':1});
            },
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget>[
                Text("Inform Next Date"),
                Icon(Icons.arrow_forward_ios)
              ]
            )
          ),
          MaterialButton(
            onPressed:(){
              Navigator.pushNamed(context, '/perticularMessage',arguments: {'ID':2});
            },
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget>[
                Text("Reminder"),
                Icon(Icons.arrow_forward_ios)
              ]
            )
          ),
          MaterialButton(
            onPressed:(){
              Navigator.pushNamed(context, '/perticularMessage',arguments: {'ID':3});
            },
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget>[
                Text("Call for Metting"),
                Icon(Icons.arrow_forward_ios)
              ]
            )
          ),
        ]
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:advocate/Storage/database.dart';

class PerticularMessage extends StatefulWidget {
  @override
  _PerticularMessageState createState() => _PerticularMessageState();
}

class _PerticularMessageState extends State<PerticularMessage> {

  bool visited=false,wait=false;
  String text="",example="";
  int permission=0,id;
  
  String date="",time="",payment="50",clientName="ClientName";
  List<String>list=List();

  String getExample(String msg){
    String exp="";
    for(int i=0;i<msg.length;i++)
    {
      if(i<msg.length-1 && msg[i]=="#" && (msg[i+1]=='1' || msg[i+1]=='2' || msg[i+1]=='3' || msg[i+1]=='4'))
      {
        exp+=list[int.parse(msg[i+1])-1];
        i++;
      }
      else
        exp=exp+msg[i];
    }
    return exp;
  }

  Future<void>getMessage(int msgID)async {
    setState((){
      wait=true;
    });
    DbHelper dB=DbHelper();
    Map msg=await dB.getMessage(msgID);

    text=msg['textMessage'];
    permission=msg['allowed'];
    example=getExample(text);
    setState((){
      wait=false;
    });
  }

  Future<void>saveMessage()async{
    setState(() {
      wait=true;
    });
    DbHelper dB=DbHelper();
    await dB.updateMessage(id,text,permission);
    setState((){
      wait=false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if(visited==false)
    {
      Map map=ModalRoute.of(context).settings.arguments;
      
      DateTime now=DateTime.now();
      date=now.day.toString()+"-"+now.month.toString()+"-"+now.year.toString();
      
      String minute=now.minute.toString();
      if(int.parse(minute)<10)
        minute="0"+minute;

      time=now.hour.toString()+":"+minute;
      
      list=[date,time,payment,clientName];
      visited=true;
      id=map['ID'];
      getMessage(id);
    }

    return Scaffold(
      appBar: AppBar(
        title:Text("Message"),
      ),
      body:wait==true?Center(child: CircularProgressIndicator()):
       ListView(
        children:[
          Text("Use"),
          Text("#1 for Date"),
          Text("#2 for Time"),
          Text("#3 for payment"),
          Text("#4 for client name"),
          SizedBox(height:30),
          Text("Example Text"),
          Text(example),
          SizedBox(height:50),
          TextFormField(
                    initialValue: text,
                    decoration: InputDecoration(
                      hintText: "Message",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: (s){
                        text=s;
                        setState((){
                          example=getExample(text);
                        });
                    },
                ),
          SizedBox(height:30),
          MaterialButton(
            onPressed: (){
              if(text!="")
              {
                saveMessage();
              }
            },
            child: Text("Save"),
            color: Colors.amberAccent,
          ),

        ]
      ),
    );
  }
}
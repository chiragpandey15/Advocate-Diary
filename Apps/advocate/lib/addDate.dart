import 'package:advocate/Case/case.dart';
import 'package:flutter/material.dart';
import 'package:advocate/Storage/database.dart';
import 'package:advocate/Message/sendSMS.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDate extends StatefulWidget {
  @override
  _AddDateState createState() => _AddDateState();
}

class _AddDateState extends State<AddDate> {

  bool wait=false,visited=false,messagePermission=false;
  String date="Date",previousDate="Previous Date",stage="",extraNote="",paymentDemand="";
  String dateStored="",previousDateStored="",clientMobile="",clientName="";
  int caseId=0;


  Future<void>selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        helpText: "Next Date",
        fieldHintText: "Next Date",
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2032));
    if (picked != null)
      setState(() {
        date=picked.day.toString()+"-";
        date+=picked.month.toString()+"-";
        date+=picked.year.toString();

        String day=picked.day.toString();
        if(picked.day<10)
          day="0"+day;

        String month=picked.month.toString();
        if(picked.month<10)
          month="0"+month;

        dateStored=picked.year.toString()+"-"+month+"-"+day;
      });
  }

  Future<void>selectPreviousDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        helpText: "Next Date",
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2032));
    if (picked != null)
      setState(() {
        previousDate=picked.day.toString()+"-";
        previousDate+=picked.month.toString()+"-";
        previousDate+=picked.year.toString();
        previousDateStored=picked.year.toString()+"-"+picked.month.toString()+"-"+picked.day.toString();
      });
  }

  Future<String>getTime()async{
    String time="";

    var picked=await showTimePicker(
        context: context,
        helpText: "Select TIme for text message",
        initialTime: TimeOfDay(
          hour: 12,
          minute: 0,
        ),
    );

    String minute=picked.minute.toString();
      if(picked.minute<10)
        minute="0"+minute;
      String hr=picked.hour.toString();

      if(picked.hour>12)
      {
        hr=(picked.hour-12).toString();
        minute=minute+" PM";
      }
      else
        minute=minute+" AM";

      time=hr+":"+minute;
    
    
    time=picked.hour.toString()+":"+picked.minute.toString();
    
    return time;
  }

  Future<String> getMessage(String msg) async{
    String exp="";
    
    for(int i=0;i<msg.length;i++)
    {
      if(i<msg.length-1 && msg[i]=="#" && (msg[i+1]=='1' || msg[i+1]=='2' || msg[i+1]=='3' || msg[i+1]=='4'))
      {
        if(msg[i+1]=='1')
          exp+=date;
        else if(msg[i+1]=='3')
          exp=exp+"₹ "+paymentDemand;
        else if(msg[i+1]=='4')
          exp+=clientName;
        else if(msg[i+1]=='2') 
        {
         String time=await getTime();
         exp+=time; 
        }

        i++;
      }
      else
        exp=exp+msg[i];
    }
    return exp;
  }

  Future<void>sendMessage(DbHelper dB)async{
    try{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String expDate=prefs.getString("expDate");
      if(expDate==null)
      {
        Toast.show("Message cannot be saved. Please consult coordinator",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER); 
        return;      
      }
      else
      {
        DateTime lastDate=DateTime.parse(expDate);
        DateTime now=DateTime.now();

        int difference=lastDate.difference(now).inDays;
        if(difference<-1)
        {
          Toast.show("Message cannot be saved. Please consult coordinator",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);       
          return;
        }
      }


      Map msg=await dB.getMessage(1);
      String messageText=msg['textMessage'];
      int allowed=msg['allowed'];
      if(allowed==1)
      {
        String message=await getMessage(messageText);
        SendSMS sms=SendSMS();
        
        var status=await Permission.sms.isGranted;
        if(messagePermission==true && status==true)
        {
          sms.send(message,clientMobile);
          // await showDialog(
          //   context:context,
          //   builder: (context){
          //     return AlertDialog(
          //       title:Text("Message to be sent"),
          //       content:TextFormField(
          //           initialValue: message,
          //           decoration: InputDecoration(
          //             hintText: "Message to be sent",
          //             hintStyle: TextStyle(
          //               fontWeight: FontWeight.bold,
          //             ),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //           ),
          //           maxLines: 3,
          //           onChanged: (s){
          //               message=s;
          //           },
          //       ),
          //       actions: [
          //         FlatButton(
          //           onPressed:(){
          //             Navigator.of(context).pop();
          //           },
          //           child: Text("Cancel"),
          //         ),
          //         FlatButton(
          //           onPressed:(){
          //             sms.send(message,clientMobile);
          //             Navigator.of(context).pop();
          //           },
          //           child: Text("Send"),
          //         ),
          //       ],
          //     );
          //   }
          // );
        }
      }



    }catch(e){
      print(e);
    }
  }


  Future<void>add()async{
    try{
      setState(() {
        wait=true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String expDate=prefs.getString("expDate");
      if(expDate==null)
      {
        Toast.show("Date cannot be added. Please consult with coordinator",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER); 
        return;      
      }
      else
      {
        DateTime lastDate=DateTime.parse(expDate);
        DateTime now=DateTime.now();

        int difference=lastDate.difference(now).inDays;
        if(difference<-1)
        {
          Toast.show("Date cannot be added. Please consult with coordinator",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);       
          return;
        }
      }

      DbHelper dB=DbHelper();

      await dB.addDetails(
              Details(0,dateStored,previousDateStored,stage,extraNote,paymentDemand),
              caseId
            );
      // Toast
      await sendMessage(dB);
      Toast.show("Date successfully added",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
      // Navigate Back
      Navigator.of(context).pop();
    }catch(e){

    }finally{
      setState(() {
        wait=false;
      });
    }
  }
  



  @override
  Widget build(BuildContext context) {
    if(visited==false)
    {
      Map map=ModalRoute.of(context).settings.arguments;
      caseId=map['caseId'];
      clientMobile=map['clientMobile'];
      clientName=map['clientName'];
      messagePermission=map['messagePermission'];
      visited=true;
    }
    return Scaffold(
      appBar: AppBar(
        title:Text("Add Date"),
      ),
      body: wait==true?Center(child:CircularProgressIndicator()):
      ListView(
        children: <Widget>[
          Text(
            "Date*",
            style:TextStyle(
              color:Colors.red,
            )
          ),
          OutlineButton(
            onPressed: (){
              selectDate(context);
            },
            child: Text(date),
          ),
          SizedBox(height:20),
          // Text(
          //   "Previous date",
          //   style:TextStyle(
          //     color:Colors.red,
          //   )
          // ),
          // OutlineButton(
          //   onPressed: (){
          //     selectPreviousDate(context);
          //   },
          //   child: Text(previousDate),
          // ),
          // SizedBox(height:20),
          Text(
            "Stage",
            style:TextStyle(
              color:Colors.red,
            )
          ),
          TextFormField(
                    decoration: InputDecoration(
                      hintText: "Stage",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: (s){
                        stage=s;
                    },
                ),
          SizedBox(height:20),
          Text(
            "Extra Note",
            style:TextStyle(
              color:Colors.red,
            )
          ),
          TextFormField(
                    decoration: InputDecoration(
                      hintText: "Extra Note",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: (s){
                        extraNote=s;
                    },
                ),
          SizedBox(height:20),      
          Text(
            "Payment Demand",
            style:TextStyle(
              color:Colors.red,
            )
          ),
          TextFormField(
                    decoration: InputDecoration(
                      hintText: "Payment demand",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (s){
                        paymentDemand=s;
                    },
                ),
          SizedBox(height:20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                child: MaterialButton(
                  onPressed: (){
                    if(date!="")
                      add();
                    else
                    {
                      Toast.show("Date is required",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
                    }
                  },
                  child: Text("Add"),
                  color: Colors.amberAccent
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
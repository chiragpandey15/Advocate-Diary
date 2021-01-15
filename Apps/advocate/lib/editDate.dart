import 'package:advocate/Case/case.dart';
import 'package:flutter/material.dart';
import 'package:advocate/Storage/database.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDate extends StatefulWidget {
  @override
  _EditDateState createState() => _EditDateState();
}

class _EditDateState extends State<EditDate> {
  
  bool wait=false,visited=false;
  Details details;
  String date="",previousDate="";
  int caseId=0;


  Future<void>selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        helpText: "Next Date",
        fieldHintText: "Abcd",
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

        details.date=picked.year.toString()+"-"+picked.month.toString()+"-"+picked.day.toString();
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
        details.previousDate=picked.year.toString()+"-"+picked.month.toString()+"-"+picked.day.toString();
      });
  }

  Future<void>edit()async{
    try{
      setState(() {
        wait=true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String expDate=prefs.getString("expDate");
      if(expDate==null)
      {
        Toast.show("Date cannot be edited. Please consult with coordinator",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER); 
        return;      
      }
      else
      {
        DateTime lastDate=DateTime.parse(expDate);
        DateTime now=DateTime.now();

        int difference=lastDate.difference(now).inDays;
        if(difference<-1)
        {
          Toast.show("Date cannot be edited. Please consult with coordinator",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);       
          return;
        }
      }

      DbHelper dB=DbHelper();

      await dB.updateDetails(details, details.id, caseId);
      // Toast
      Toast.show("Date successfully added",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
      // Navigate Back
      Navigator.of(context).pop(1);
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
      details=map['details'];
      caseId=map['caseId'];
      visited=true;
    }
    return Scaffold(
      appBar: AppBar(
        title:Text("Edit Date"),
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
          Text(
            "Previous date",
            style:TextStyle(
              color:Colors.red,
            )
          ),
          OutlineButton(
            onPressed: (){
              selectPreviousDate(context);
            },
            child: Text(previousDate),
          ),
          SizedBox(height:20),
          Text(
            "Stage",
            style:TextStyle(
              color:Colors.red,
            )
          ),
          TextFormField(
                    initialValue: details.stage,
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
                        details.stage=s;
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
                    initialValue: details.extraNote,
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
                        details.extraNote=s;
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
                    initialValue: details.paymentDemand,
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
                        details.paymentDemand=s;
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
                      edit();
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
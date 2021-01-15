import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/database.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCase extends StatefulWidget {
  @override
  _AddCaseState createState() => _AddCaseState();
}

class _AddCaseState extends State<AddCase> {

  List<String>option=["Applicant","Respondent"];
  bool wait=false;
  int caseFee,weAre=0;
  String clientName,clientMobile,opponent,opponentAdvocate,courtName,firstDate,description,caseNumber,courtNumber;

  String date="Date",dateStored="",previousDate="Previous Date(if any)",previousDateStored="",stage;

  Future<void>add()async{
    try{

      setState(() {
        wait=true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String expDate=prefs.getString("expDate");
      if(expDate==null)
      {
        Toast.show("Case cannot be added. Please consult with coordinator",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER); 
        return;      
      }
      else
      {
        DateTime lastDate=DateTime.parse(expDate);
        DateTime now=DateTime.now();

        int difference=lastDate.difference(now).inDays;
        if(difference<-1)
        {
          Toast.show("Case cannot be added. Please consult with coordinator",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);       
          return;
        }
      }
      
      DbHelper dB=DbHelper();
      Case newCase=new Case(0,caseNumber,clientName,clientMobile,option[weAre],opponent!=null?opponent:"",opponentAdvocate!=null?opponentAdvocate:"",courtName!=null?courtName:"",courtNumber!=null?courtNumber:"",
        caseFee!=null?caseFee:0,true,description!=null?description:"",0);
      
      newCase.details=List();
      newCase.details.add(
        new Details(0,dateStored,previousDateStored,stage==null?"":stage,"","")
      );

      await dB.addCase(newCase);      

      // Toast
      Toast.show("Case successfully added",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
      Navigator.of(context).pop(0);
      //Navigate back

    }catch(e){
      print(e);
    }finally{
      setState(() {
        wait=false;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Add Case"),
      ),
      body:wait==true?Center(child: CircularProgressIndicator(),):
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 23, 0),
        child: ListView(
          children: <Widget>[
                    Text(
                      "Case Number*",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                    TextFormField(
                    initialValue: caseNumber,
                    decoration: InputDecoration(
                      hintText: "Case Number",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (s){
                        setState(() {
                          caseNumber=s;
                        });
                        
                    },
                ),
                SizedBox(height:20),
                Text(
                      "Client Name*",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                TextFormField(
                  initialValue: clientName,
                    decoration: InputDecoration(
                      hintText: "Client Name",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (s){
                        setState(() {
                          clientName=s;
                        });
                    },
                ),
                SizedBox(height:20),
                Text(
                      "Client Mobile Number*",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                TextFormField(
                    initialValue:clientMobile,
                    decoration: InputDecoration(
                      hintText: "Client Mobile Number",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (s){
                      setState(() {
                          clientMobile=s;
                        });
                        clientMobile=s;
                    },
                ),
                SizedBox(height:20),
                Row(
                  children: <Widget>[
                    Text(
                      "We are? ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 0, 
                          groupValue: weAre, 
                          onChanged: (s){
                            setState(() {
                              weAre=s;
                            });
                          }
                        ),
                        Text(option[0]),
                      ],
                    ),
                    SizedBox(width:20),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 1, 
                          groupValue: weAre, 
                          onChanged: (s){
                            setState(() {
                              weAre=s;
                            });
                          }
                        ),
                        Text(option[1]),
                      ],
                    ),
                  ],
                ),
                SizedBox(height:20),
                Text(
                      "Opponent Name",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                TextFormField(
                    initialValue: opponent,
                    decoration: InputDecoration(
                      hintText: "Opponent Name",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (s){
                      setState(() {
                          opponent=s;
                        });
                        // opponent=s;
                    },
                ),
                SizedBox(height:20),    
                Text(
                      "Opponent Adv.",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                TextFormField(
                  initialValue: opponentAdvocate,
                    decoration: InputDecoration(
                      hintText: "Opponent Adv.",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (s){
                      setState(() {
                          opponentAdvocate=s;
                        });
                        // opponentAdvocate=s;
                    },
                ),
                SizedBox(height:20),    
                Text(
                      "Court Name",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                TextFormField(
                  initialValue: courtName,
                    decoration: InputDecoration(
                      hintText: "Court Name",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (s){
                      setState(() {
                          courtName=s;
                        });
                        // courtName=s;
                    },
                ),
                SizedBox(height:20),
                Text(
                      "Court Number",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                TextFormField(
                  initialValue: courtNumber,
                    decoration: InputDecoration(
                      hintText: "Court Number",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (s){
                      setState(() {
                          courtNumber=s;
                        });
                        // courtNumber=s;
                    },
                ),
                SizedBox(height:20),
                Text(
                      "Case Fee",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                TextFormField(
                  initialValue: caseFee==null?"":caseFee.toString(),
                    decoration: InputDecoration(
                      hintText: "Case Fee(₹)",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (s){
                        setState(() {
                          caseFee=int.parse(s);
                        });
                        // caseFee=int.parse(s);
                    },
                ),
                SizedBox(height:20),
                Text(
                      "Date*",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                OutlineButton(
                  onPressed: (){
                    selectDate(context);
                  },
                  child: Text(date),
                ),
                SizedBox(height:20),
                Text(
                      "Previous Date(if any)",
                      style: TextStyle(
                        color:Colors.red,
                      ),
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
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                TextFormField(
                    initialValue: stage,
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
                      setState(() {
                          stage=s;
                        });
                        // stage=s;
                    },
                ),
                SizedBox(height:20),
                Text(
                      "Description",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                TextFormField(
                    initialValue: description,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: (s){
                        setState(() {
                          description=s;
                        });
                        // description=s;
                    },
                ),
                SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      child: MaterialButton(
                        onPressed: (){
                          if(clientMobile!=null && checkMobile(clientMobile))
                          {
                            if(caseNumber=="" || caseNumber==null)
                              Toast.show("Case Number is required",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
                            else if(clientName=="" || clientName==null)
                              Toast.show("Client Name is required",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
                            else if(dateStored=="" || dateStored==null)
                              Toast.show("Date is required",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
                            else   
                              add();
                          }
                          else
                          {
                            // Toast 
                            Toast.show("Please check the client's mobile number",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
                          }
                        },
                        child: Text("Add"),
                        color: Colors.amberAccent,
                      ),
                    ),
                  ],
                ),    
          ],
        ),
      ),
    );
  }

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

  bool checkMobile(String m)
  {
    if(m.length!=10)
      return false;

    for(int i=0;i<10;i++)
    {
      if(m[i]!='0' && m[i]!='1' && m[i]!='2' && m[i]!='3' && m[i]!='4' && m[i]!='5' && m[i]!='6' && 
      m[i]!='7' && m[i]!='8' && m[i]!='9')
        return false;
    }
    return true;   
  }
}
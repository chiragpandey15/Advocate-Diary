import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/database.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditCase extends StatefulWidget {
  @override
  _EditCaseState createState() => _EditCaseState();
}

class _EditCaseState extends State<EditCase> {

  bool visited=false,wait=false;
  Case caseToEdit;
  List<String>option=["Applicant","Respondent"];
  int weAre=0;

  Future<void>edit()async{
    try{

      setState(() {
        wait=true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String expDate=prefs.getString("expDate");
      if(expDate==null)
      {
        Toast.show("Case cannot be edited. Please consult with coordinator",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER); 
        return;      
      }
      else
      {
        DateTime lastDate=DateTime.parse(expDate);
        DateTime now=DateTime.now();

        int difference=lastDate.difference(now).inDays;
        if(difference<-1)
        {
          Toast.show("Case cannot be edited. Please consult with coordinator",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);       
          return;
        }
      }
      

      DbHelper dB=DbHelper();
      await dB.updateCase(caseToEdit, caseToEdit.id);

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

    if(visited==false)
    {
      Map map=ModalRoute.of(context).settings.arguments;
      caseToEdit=map['case'];
      if(caseToEdit.weAre==option[1])
          weAre=1;

      visited=true;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
      ),
      body: wait==true?Center(child: CircularProgressIndicator()):
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 23, 0),
        child: ListView(
          children: <Widget>[
                    Text(
                      "Case Number",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                    TextFormField(
                    initialValue: caseToEdit.caseNumber,  
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
                        caseToEdit.caseNumber=s;
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
                    initialValue: caseToEdit.clientName,
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
                        caseToEdit.clientName=s;
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
                    initialValue: caseToEdit.clientMobile,
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
                        caseToEdit.clientMobile=s;
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
                            caseToEdit.weAre=option[0];
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
                            caseToEdit.weAre=option[1];
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
                    initialValue: caseToEdit.opponent,
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
                        caseToEdit.opponent=s;
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
                    initialValue: caseToEdit.opponentAdvocate,
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
                        caseToEdit.opponentAdvocate=s;
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
                    initialValue: caseToEdit.courtName,
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
                        caseToEdit.courtName=s;
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
                    initialValue: caseToEdit.courtNumber,
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
                        caseToEdit.courtNumber=s;
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
                    initialValue: caseToEdit.caseFee.toString(),
                    decoration: InputDecoration(
                      hintText: "Case Fee",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (s){
                        caseToEdit.caseFee=int.parse(s);
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
                    initialValue: caseToEdit.description,
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
                        caseToEdit.description=s;
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
                          if(checkMobile(caseToEdit.clientMobile))
                          {
                            if(caseToEdit.caseNumber=="")
                              Toast.show("Case Number is required",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
                            else if(caseToEdit.clientName=="")
                              Toast.show("Client Name is required",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
                            else   
                              edit();
                          }
                          else
                          {
                            // Toast 
                            Toast.show("Please check the client's mobile number",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
                          }
                        },
                        child: Text("Edit"),
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
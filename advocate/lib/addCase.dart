import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/database.dart';
import 'package:toast/toast.dart';

class AddCase extends StatefulWidget {
  @override
  _AddCaseState createState() => _AddCaseState();
}

class _AddCaseState extends State<AddCase> {

  List<String>option=["Applicant","Respondent"];
  bool wait=false;
  int caseFee,weAre=0;
  String clientName="",clientMobile="",opponent="",opponentAdvocate="",courtName="",firstDate="",description="",caseNumber="",courtNumber="";


  Future<void>add()async{
    try{

      setState(() {
        wait=true;
      });
      // Check Payment

      DbHelper dB=DbHelper();
      await dB.addCase(
        Case(0,caseNumber,clientName,clientMobile,option[weAre],opponent,opponentAdvocate,courtName,courtNumber,
        caseFee,true,description)
      );      

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
                      "Case Number",
                      style: TextStyle(
                        color:Colors.red,
                      ),
                    ),
                    TextFormField(
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
                        caseNumber=s;
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
                        clientName=s;
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
                        opponent=s;
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
                        opponentAdvocate=s;
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
                        courtName=s;
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
                        courtNumber=s;
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
                        caseFee=int.parse(s);
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
                        description=s;
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
                          if(checkMobile(clientMobile))
                          {
                            if(caseNumber=="")
                              Toast.show("Case Number is required",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
                            else if(clientName=="")
                              Toast.show("Client Name is required",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
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
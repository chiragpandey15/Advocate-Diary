import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/database.dart';

class AddCase extends StatefulWidget {
  @override
  _AddCaseState createState() => _AddCaseState();
}

class _AddCaseState extends State<AddCase> {

  List<String>option=["Applicant","Respondent"];
  bool wait=false;
  int caseNumber,courtNumber,caseFee,weAre=0;
  String clientName="",clientMobile="",opponent="",courtName="",firstDate="",description="";

  //For Test
  String registeredDate;

  Future<void>add(){
    try{

      setState(() {
        wait=true;
      });
      // Check Payment

      DbHelper dB=DbHelper();
      dB.addCase(
        Case(0,caseNumber,clientName,clientMobile,opponent,option[weAre],courtName,courtNumber,
        caseFee,registeredDate,true,firstDate,description)
      );      

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
                    keyboardType: TextInputType.number,
                    onChanged: (s){
                        caseNumber=int.parse(s);
                    },
                ),
                SizedBox(height:10),
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
                SizedBox(height:10),    
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
                SizedBox(height:10),
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
                SizedBox(height:10),
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
                SizedBox(height:10),    
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
                SizedBox(height:10),
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
                    keyboardType: TextInputType.number,
                    onChanged: (s){
                        courtNumber=int.parse(s);
                    },
                ),
                SizedBox(height:10),

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
                SizedBox(height:10),
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
                          add();
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
}
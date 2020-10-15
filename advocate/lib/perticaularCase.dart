import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/database.dart';

class PerticaularCase extends StatefulWidget {
  @override
  _PerticaularCaseState createState() => _PerticaularCaseState();
}

class _PerticaularCaseState extends State<PerticaularCase> {

  Case thisCase;
  Map map;
  bool visited=false,wait=false;
  DbHelper dB;

  Future<void>deleteCase(int id)async{
    try{
      setState(() {
        wait=true;
      });
      
      await dB.deleteCase(id);
      // Toast
      //Navigate Back

    }catch(e){

    }finally{
      setState(() {
        wait=false;
      });
    }
  }

  Future<void>getDetails()async{
    try{
      setState(() {
        wait=true;
      });

      await dB.getDetails(thisCase.id).then((value){
        thisCase.details=value;
      });

    }catch(e){
      print(e);
    }setState(() {
      wait=false;
    });
  }

  Future<void>deleteDetails(int id)async{
    try{
      setState(() {
        wait=true;
      });
      
      await dB.deleteDetails(id);

    }catch(e){

    }finally{
      setState(() {
        wait=false;
      });
    }
  }

  void editCase(){
    Navigator.pushNamed(context, '/editCase',arguments: {'case':thisCase}); 
  }
  
  void editDetails(int indx){
    Navigator.pushNamed(context, '/editDetails',arguments: {'details':thisCase.details[indx],'caseId':thisCase.id}); 
  }
  
  void addDate(){
   Navigator.pushNamed(context, '/addDetails',arguments: {'caseId':thisCase.id}); 
  }


  Future<void>chenageMessagePermission()async{
    try{
      setState(() {
        wait=true;
      });
      DbHelper dB=DbHelper();
      await dB.updateCase(thisCase, thisCase.id);

    }catch(e){
      print(e);
    }finally{
      setState((){
        wait=false;
      });
    }
  }

  String getDate(String date)
  {
    DateTime temp=DateTime.parse(date);
    String res=temp.day.toString()+"-"+temp.month.toString()+"-"+temp.year.toString();
    return res;
  }

  @override
  void initState() {
    super.initState();
    dB=DbHelper();
  }

  @override
  Widget build(BuildContext context) {

    map=ModalRoute.of(context).settings.arguments;
    
    if(visited==false)
    {
      thisCase=map['case'];
      visited=true;
      getDetails();
    }

    return Scaffold(
      appBar: AppBar(
        title:Text(thisCase.caseNumber.toString())
      ),
      body: wait==true?Center(child: CircularProgressIndicator(),):
      ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  thisCase.clientName+ "  ("+thisCase.clientMobile+")",
                ),
                SizedBox(height:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "opp.: "+thisCase.opponent,
                    ),
                    Text(
                      "Opp. Adv."+thisCase.opponentAdvocate
                    ),
                    SizedBox(width:5),    
                  ],
                ),
                SizedBox(height:10),
                Text(
                  "We are: "+thisCase.weAre,
                ),
                SizedBox(height:10),
                Text(
                  "Court Name: "+thisCase.courtName+ ", "+thisCase.courtNumber.toString(),
                ),
                SizedBox(height:10),
                Text(
                  "Description: "+thisCase.description
                ),

                SizedBox(height:20),
                
                Row(
                  children: <Widget>[
                    Text("Message to Client: "),
                    Switch(
                      value: !thisCase.messagePermission,
                      onChanged: (bool value){
                        setState(() {
                          thisCase.messagePermission=value;
                          // update Case;
                          chenageMessagePermission();
                        });
                      }
                    )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      child: Text("Add Date"),
                      onPressed: (){
                        addDate();
                      },
                      color:Colors.green,
                    ),
                    MaterialButton(
                      child: Text("Edit Case"),
                      onPressed: (){
                        editCase();
                      },
                      color:Colors.orange,
                    ),
                    MaterialButton(
                      child: Text("Delete Case"),
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (context){
                            return AlertDialog(
                              title: Text("Dalete Case "+thisCase.caseNumber),
                              content: Text("All the details of this case will be deleted and you will not be able to reterive it again. Are you sure you want to delete case "+thisCase.caseNumber+"?"),
                              actions: [
                                FlatButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("No"),
                                ),
                                FlatButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                    deleteCase(thisCase.id);            
                                  },
                                  child: Text("Yes"),
                                ),
                              ],
                            );
                          }
                        );
                      },
                      color:Colors.red,
                    ),
                  ],
                ),
                SizedBox(height:10),
                OutlineButton(
                  onPressed: (){},
                  child: Text("Call for meeting"),
                ),
              ],
            ),
          ),
          SizedBox(height:20),
          ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: thisCase.details==null?0:thisCase.details.length,
            itemBuilder: (context,index){
              return Card(
                child: InkWell(
                  onTap: (){
                    // Go to details Page
                    Navigator.pushNamed(context, '/page',arguments: {'case':thisCase,"currentPages":index});
                  },
                  child: Column(
                    children:<Widget>[
                      Text(
                        getDate(thisCase.details[index].date)
                      ),
                      Text(
                        thisCase.details[index].stage
                      ),
                      SizedBox(height:30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete), 
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text("Delete Date"),
                                    content: Text("You will not be able to reterive once you delete this date. Are you sure you want to delete "+thisCase.details[index].date+"?"),
                                    actions: [
                                      FlatButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("No"),
                                      ),
                                      FlatButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                          // Delete Details

                                        },
                                        child: Text("Yes"),
                                      ),
                                    ],
                                  );
                                }
                              );
                            }
                          ),

                          IconButton(
                            icon: Icon(Icons.edit), 
                            onPressed:(){
                              editDetails(index);
                            }
                          ),
                        ],
                      ),
                    ]
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
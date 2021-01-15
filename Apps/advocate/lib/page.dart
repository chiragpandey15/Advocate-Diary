import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/database.dart';

class Pages extends StatefulWidget {
  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> {

  Case thisCase;
  Map map;
  bool visited=false,wait=false;
  int current=0;


  void editDetails(int indx){
    Navigator.pushNamed(context, '/editDetails',arguments: {'details':thisCase.details[indx],'caseId':thisCase.id}).then((value){
      Navigator.of(context).pop();
    });  
  }

  Future<void>deleteDetails(int id)async{
    try{
      setState(() {
        wait=true;
      });
      

      DbHelper dB=DbHelper();
      await dB.deleteDetails(id);
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

    map=ModalRoute.of(context).settings.arguments;
    
    if(visited==false)
    {
      thisCase=map['case'];
      current=map['currentPages'];
      visited=true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(thisCase.caseNumber.toString())
      ),
      body: wait==true?Center(child:CircularProgressIndicator()):
      Column(
        children: <Widget>[
          Card(
            child:Column(
                children:<Widget>[
                  Text(
                      thisCase.caseNumber.toString(),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      Text(
                        thisCase.clientName,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      thisCase.opponent==""?Text(''):
                      Text(
                        "vs "+thisCase.opponent,
                        style: TextStyle(
                          color:Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]
                  ),
                ]
              ),
          ),
          SizedBox(height:20),
          Card(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  "Date: "+thisCase.details[current].date
                ),
                SizedBox(height: 10,),
                SizedBox(height: 10,),
                Text(
                  current==thisCase.details.length-1?thisCase.details[current].previousDate!=""?"Previous Date: "+thisCase.details[current].previousDate:"":"Previous Date: "+thisCase.details[current+1].date
                ),
                SizedBox(height: 10,),
                Text(
                  "Stage: "+thisCase.details[current].stage,
                ),
                SizedBox(height: 10,),
                Text(
                  "Extra Note: "+thisCase.details[current].extraNote,
                ),
                SizedBox(height: 10,),
                Text(
                  "Payment Demand: "+thisCase.details[current].paymentDemand,
                ),
                SizedBox(height: 10,),
                Text(
                  current==0?'':"Next Date: "+thisCase.details[current-1].date
                ),
              ],
            ),
          ),
          SizedBox(height:20),
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: (){
                    showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text("Delete Date"),
                                    content: Text("You will not be able to reterive once you delete this date. Are you sure you want to delete "+thisCase.details[current].date+"?"),
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
                                          deleteDetails(thisCase.details[current].id);
                                          // Delete Details

                                        },
                                        child: Text("Yes"),
                                      ),
                                    ],
                                  );
                                }
                              );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: (){
                    editDetails(current);
                  },
                ),
              ],
            ),
          ),       
          SizedBox(height:20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: current==thisCase.details.length-1?Colors.grey:Colors.black,
                ), 
                onPressed: (){
                  if(current<thisCase.details.length-1)
                  {
                    setState(() {
                      current++;
                    });
                  }
                }
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: current==0?Colors.grey:Colors.black,
                ), 
                onPressed: (){
                  if(current>0)
                  {
                    setState(() {
                      current--;
                    });
                  }
                }
              ),
            ],
          ),  
        ],
      ),
    );
  }
}
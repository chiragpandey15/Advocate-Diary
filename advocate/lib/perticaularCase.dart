import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/database.dart';
import 'package:toast/toast.dart';
import 'package:advocate/Message/sendSMS.dart';
import 'package:permission_handler/permission_handler.dart';

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
      Toast.show("Case successfully deleted",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);     
      Navigator.of(context).pop();
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
      getDetails();

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
    Navigator.pushNamed(context, '/editDetails',arguments: {'details':thisCase.details[indx],'caseId':thisCase.id}).then((value){
      getDetails();
    });  
  }
  
  void addDate(){
   Navigator.pushNamed(context, '/addDetails',arguments: 
   {
    'caseId':thisCase.id,
    'clientMobile':thisCase.clientMobile,
    'clientName':thisCase.clientName,
    'messagePermission':thisCase.messagePermission,
  }).then((value){
      getDetails();
    }); 
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


  Future<String>selectDate()async{
    var date=await showDatePicker(
        context:context,
        initialDate:DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2032),
        helpText: "Date for meeting",
        fieldHintText: "Date for meeting",      
      );
  

    String res="";
    if(date!=null)
      res=date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString();
    return res;
  }

  Future<String>getTime()async{
    var time=await showTimePicker(
      context:context,
      initialTime: TimeOfDay(
        hour:12,
        minute:0,
      ),
      helpText: "Time of meeting", 
    );

    String res="";
    if(time!=null)
      res=time.hour.toString()+":"+time.minute.toString();

    return res;

  }

  Future<String>askPayment()async{
    String amount="";
    try{
      await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title:Text("Enter Payment Amount"),
            content: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Payment Amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    maxLines: 3,
                    onChanged: (s){
                        amount=s;
                    },
                ),
            actions: [
              FlatButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text("Done"),
              )
            ],
          );
        }
      );
      print("AMOUNT");
      print(amount);
      
    }catch(e){
      print(e);
    }
    return amount;
  }

  Future<String> getMessage(String msg) async{
      String exp="";
      
      for(int i=0;i<msg.length;i++)
      {
        if(i<msg.length-1 && msg[i]=="#" && (msg[i+1]=='1' || msg[i+1]=='2' || msg[i+1]=='3' || msg[i+1]=='4'))
        {
          String temp="";
          if(msg[i+1]=='1')
          {
            temp=await selectDate();
            exp+=temp;
          }
          else if(msg[i+1]=='3')
          {
            String paymentDemand=await askPayment();
            exp+=paymentDemand;
          }
          else if(msg[i+1]=='4')
            exp+=thisCase.clientName;
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
  
  void showError(String message)
  {
    showDialog(
      context:context,
      builder:(context){
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("Ok"),
            ),
          ],
        );
      }
    );
  }

  Future<void>callForMeeting()async{
    try{
      DbHelper dB=DbHelper();
      Map msg=await dB.getMessage(3);
      String messageText=msg['textMessage'];
      int allowed=msg['allowed'];
      if(allowed==1)
      {
        String message=await getMessage(messageText);
        SendSMS sms=SendSMS();
        
        var status=await Permission.sms.isGranted;
        if(thisCase.messagePermission==true && status==true)
        {
          sms.send(message,thisCase.clientMobile);
        }
        else if(thisCase.messagePermission==false)
        {
          showError("Message permission is disabled");
        }
        else if(status==false)
        {
          showError("SMS permission is not granted");
        }
        else
        {
          showError("Some error occured");
        }
      }
      else
      {
        showError("Message permissionis disabled");
      }


    }catch(e){
      print(e);
    }
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
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height:10),
                thisCase.opponent=="" &&thisCase.opponentAdvocate==""?Text(''):
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      thisCase.opponent==""?"":"opp.: "+thisCase.opponent,
                    ),
                    Text(
                      thisCase.opponentAdvocate==""?"":"Opp. Adv."+thisCase.opponentAdvocate
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
                  thisCase.courtName==""?"":"Court Name: "+thisCase.courtName+ ", "+thisCase.courtNumber.toString(),
                ),
                SizedBox(height:10),
                Text(
                  thisCase.description==""?"":"Description: "+thisCase.description
                ),

                SizedBox(height:20),
                
                Row(
                  children: <Widget>[
                    Text("Message to Client: "),
                    Switch(
                      value: thisCase.messagePermission,
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
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: [
                    OutlineButton(
                      onPressed: (){
                        callForMeeting();
                      },
                      child: Text("Call for meeting"),
                    ),
                    MaterialButton(
                      onPressed: (){},
                      child: Text("Account"),
                      color: Colors.blue,
                    ),
                  ],
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
                    Navigator.pushNamed(context, '/page',arguments: {'case':thisCase,"currentPages":index}).then((value){
                      getDetails();
                    });
                  },
                  child: Column(
                    children:<Widget>[
                      Text(
                        getDate(thisCase.details[index].date),
                        style:TextStyle(
                          fontSize: 18,
                        )
                      ),
                      Text(
                        thisCase.details[index].stage,
                        style:TextStyle(
                          fontSize: 18,
                        ),
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
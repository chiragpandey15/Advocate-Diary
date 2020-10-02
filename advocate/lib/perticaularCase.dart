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

      dB.getDetails(thisCase.id).then((value){
        thisCase.details=value;
      });

    }catch(e){
      print(e);
    }setState(() {
      wait=false;
    });
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
      print("Hello");
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
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.amberAccent,
                  child: Text(
                    thisCase.caseNumber.toString(),
                  ),
                ),
                SizedBox(height:10),
                Text(
                  "Client Name: "+thisCase.clientName,
                ),
                SizedBox(height:10),
                Text(
                  "Mobile Number: "+thisCase.clientMobile,
                ),
                SizedBox(height:10),
                Text(
                  "opponent: "+thisCase.opponent,
                ),
                SizedBox(height:10),
                Text(
                  "We are: "+thisCase.weAre,
                ),
                SizedBox(height:10),
                Text(
                  "Court Name: "+thisCase.courtName,
                ),
                SizedBox(height:10),
                Text(
                  "Court Number: "+thisCase.courtNumber.toString(),
                ),
                SizedBox(height:10),
                Text(
                  "Case Fee: "+thisCase.caseFee.toString(),
                ),
                SizedBox(height:10),
                Text(
                  "Registered on: "+thisCase.registeredDate,
                ),
                SizedBox(height:10),
                Text(
                  "First Date: "+thisCase.firstDate,
                ),

                SizedBox(height:30),
                
                Row(
                  children: <Widget>[
                    Text("Message to Client: "),
                    Switch(
                      value: thisCase.messagePermission,
                      onChanged: (bool value){
                        setState(() {
                          thisCase.messagePermission=value;
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
                      onPressed: (){},
                      color:Colors.green,
                    ),
                    MaterialButton(
                      child: Text("Edit Case"),
                      onPressed: (){},
                      color:Colors.orange,
                    ),
                    MaterialButton(
                      child: Text("Delete Case"),
                      onPressed: (){
                        deleteCase(thisCase.id);
                      },
                      color:Colors.red,
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
                  },
                  child: Column(
                    children:<Widget>[
                      Text(
                        thisCase.details[index].date
                      ),
                      Text(
                        thisCase.details[index].stage
                      ),
                      SizedBox(height:30),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete), 
                            onPressed: null
                          ),

                          IconButton(
                            icon: Icon(Icons.edit), 
                            onPressed: null
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
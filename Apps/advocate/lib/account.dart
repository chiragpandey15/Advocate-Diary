import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/database.dart';


class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {

  bool wait=false,visited=false;
  int caseFee=0,id=0;
  String addText="";
  List<Fee>list=List();
  Map map;

  Future<void>getAccount()async{
    setState(() {
      wait=true;
    });
    DbHelper dB=DbHelper();
    list=await dB.getAccount(id);
    
    setState(() {
      wait=false;
    });
  }

  Future<void>add()async{

    setState(() {
      wait=true;
    });

    DbHelper dB=DbHelper();  
    // await dB.logAccount();
    await dB.addAcount(
      Fee(0,id,addText)
    );
    addText="";
    await getAccount();
    setState(() {
      wait=false;
    });
  }

  addAccount(){
    showDialog(
      context:context,
      builder: (context){
        return AlertDialog(
          title: Text("Add"),
          content: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 5,
                    onChanged: (s){
                        addText=s;
                    },
                ),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            FlatButton(
              onPressed: (){
                if(addText!="")
                {
                  Navigator.of(context).pop();
                  add();
                }
                else
                {
                  //Toast
                }
              },
              child: Text("Save"),
            )
          ],
        );
      }
      
    );
  }

  Future<void>edit(Fee account)async{
    setState(() {
      wait=true;
    });

    DbHelper dB=DbHelper();

    await dB.updateAccount(
      account
    );
    await getAccount();
    setState(() {
      wait=false;
    });
  }

  Future<void>delete(int accountID)async{
    setState(() {
      wait=true;
    });

    DbHelper dB=DbHelper();

    await dB.deleteAccount(
      accountID
    );
    await getAccount();
    setState(() {
      wait=false;
    });
  }

  deleteAccount(Fee account){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title:Text("DELETE"),
          content: Text("Are you sure you want to delete "+account.text),
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
                delete(account.id);
              },
              child: Text("Yes"),
            ),
          ],
        );
      }
    );
  }


  editAccount(Fee account){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Edit"),
          content: TextFormField(
                    initialValue: account.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 5,
                    onChanged: (s){
                        account.text=s;
                        
                    },
                ),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            FlatButton(
              onPressed: (){
                if(account.text!="")
                {
                  Navigator.of(context).pop();
                  edit(account);
                }
                else
                {
                  Navigator.of(context).pop();
                  //Toast
                }
              },
              child: Text("Edit"),
            )
          ],
        );
      }
      
    );
  }

  @override
  Widget build(BuildContext context) {

    map=ModalRoute.of(context).settings.arguments;
    
    if(visited==false)
    {
      id=map['caseID'];
      caseFee=map['caseFee'];
      visited=true;
      getAccount();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Advocate"),
      ),
      body:wait==true?Center(child: CircularProgressIndicator()):
      ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: [
          Text(
            "CASE FEE: ₹"+caseFee.toString(),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height:20),
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context,index){
              return Card(
                child:Column(
                  children:[
                    Text(
                      list[index].text,
                      style: TextStyle(
                        fontSize:18,
                      ),
                    ),
                    SizedBox(height:20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                            ),
                            onPressed: (){
                              editAccount(list[index]);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                            ),
                            onPressed: (){
                              deleteAccount(list[index]);
                            },
                          ),
                      ]
                    ),
                  ]
                )
              );
            }
          ),
        ],
      ),

      floatingActionButton:FloatingActionButton(
                                  onPressed:(){
                                    addAccount();
                                  },
                                  child: Icon(Icons.add),
                                )
    );
  }
}
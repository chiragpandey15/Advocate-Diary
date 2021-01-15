import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/database.dart';

class Dispose extends StatefulWidget {
  @override
  _DisposeState createState() => _DisposeState();
}

class _DisposeState extends State<Dispose> {

  bool wait=false,visited=false;
  List<Case>disposedCase;


  Future<void>getDisposedCase()async{
    try{
      setState(() {
        wait=true;
      });

      DbHelper dB=DbHelper();
      await dB.getDisposedCase().then((value){
        disposedCase=value;
      });
    }catch(e){
       print(e);
    }finally{
      setState(() {
        wait=false;
      });
    }
  }

  Future<void>openCase(int caseNo)async{
    try{
      DbHelper dB=DbHelper();
      await dB.openCase(caseNo);
      getDisposedCase();
    }catch(e){
      print(e);
    } 
  }


  void askForOpenCase(int caseNo){
    showDialog(
      context:context,
      builder: (context){
        return AlertDialog(
          title: Text("Open Case"),
          content: Text("Are you sure you want to open this Case ?"),
          actions: [
            FlatButton(
              onPressed:(){
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            FlatButton(
              onPressed:(){
                openCase(caseNo);
                Navigator.of(context).pop();
              },
              child: Text("Open Case"),
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    if(visited==false)
    {
      getDisposedCase();
      visited=true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Disposed Case"),
      ),
      body: wait==true?Center(child: CircularProgressIndicator()):
      ListView.builder(
        itemCount: disposedCase.length,
        itemBuilder: (context,index){
          return Card(
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/perticularCase',arguments: {'case':disposedCase[index],'disposed':true}).then((s){
                  getDisposedCase();
                });
              },
              child:Column(
                children:<Widget>[
                  Text(
                      disposedCase[index].caseNumber,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      Text(
                        disposedCase[index].clientName,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      disposedCase[index].opponent==""?Text(''):
                      Text(
                        "vs "+disposedCase[index].opponent,
                        style: TextStyle(
                          color:Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    onPressed: (){
                      askForOpenCase(disposedCase[index].id);
                    },
                    child: Text("Open Case"),
                    color: Colors.green,
                  ),
                ]
              ),
            ),
          );
        }
      ),
    );
  }
}
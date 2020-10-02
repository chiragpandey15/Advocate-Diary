import 'package:advocate/Storage/database.dart';
import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';

class SearchByClient extends StatefulWidget {
  @override
  _SearchByClientState createState() => _SearchByClientState();
}

class _SearchByClientState extends State<SearchByClient> {


  bool wait=false;
  List<Case>cases=List();


  Future<void>getCases()async{
    try{
      setState(() {
        wait=true;
      });

      DbHelper dB=DbHelper();
      await dB.getAllCase().then((value){
        cases=value;
      });
      setState(() {
        wait=false;
      });

    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCases();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cases"),
      ),
      body: wait==true?Center(
        child:CircularProgressIndicator(),
      ):
      ListView.builder(
        itemCount: cases.length,
        itemBuilder: (context,index){
          return Card(
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/perticularCase',arguments: {'case':cases[index]});
              },
              child:Column(
                children:<Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.amberAccent,
                    child: Text(
                      cases[index].caseNumber.toString()
                      )
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      Text(
                        cases[index].clientName,
                        style:TextStyle(
                          fontSize: 18
                        )
                      ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:<Widget>[
                      Text(
                        "vs "+cases[index].opponent,
                        style: TextStyle(
                          color:Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 25,)
                    ]
                  ),
                ]
              ),
            ),
          );
        },
      ),
    );
  }
}
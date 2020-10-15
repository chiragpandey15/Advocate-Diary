import 'package:advocate/Storage/database.dart';
import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';

class CaseByDate extends StatefulWidget {
  @override
  _CaseByDateState createState() => _CaseByDateState();
}

class _CaseByDateState extends State<CaseByDate> {

  Map map;
  bool visited=false,wait=false;
  String date;
  List<Case>casesByDate=List();

  Future<void>getCasesByDate(String perticularDate)async{
    try{
      setState(() {
        wait=true;
      });

      DbHelper dB=DbHelper();
      casesByDate=await dB.getCaseByDate(perticularDate);
      print("Case by Date");
      print(casesByDate.length);
      print(casesByDate[0].clientName);

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
      date=map['date'];
      visited=true;
      getCasesByDate(date);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(date),
      ),
      body: wait==true?Center(child:CircularProgressIndicator()):
      ListView.builder(
        itemCount: casesByDate.length,
        itemBuilder: (context,index){
          return Card(
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/perticularCase',arguments: {'case':casesByDate[index]});
              },
              child:Column(
                children:<Widget>[
                  Text(
                    casesByDate[index].caseNumber.toString()
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      Text(
                        casesByDate[index].clientName,
                      ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:<Widget>[
                      Text(
                        "vs "+casesByDate[index].opponent,
                        style: TextStyle(
                          color:Colors.grey,
                        ),
                      ),
                    ]
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
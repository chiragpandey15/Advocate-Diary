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
      

    }catch(e){

    }finally{
      setState(() {
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
        title: Text(getDate(date)),
      ),
      body: wait==true?Center(child:CircularProgressIndicator()):
      ListView.builder(
        itemCount: casesByDate.length,
        itemBuilder: (context,index){
          return Card(
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/perticularCase',arguments: {'case':casesByDate[index]}).then((s){
                  getCasesByDate(date);
                });
              },
              child:Column(
                children:<Widget>[
                  Text(
                      casesByDate[index].caseNumber.toString(),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      Text(
                        casesByDate[index].clientName,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      casesByDate[index].opponent==""?Text(''):
                      Text(
                        "vs "+casesByDate[index].opponent,
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
          );
        },
      ),
    );
  }
}
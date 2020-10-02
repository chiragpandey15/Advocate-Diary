import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {

  Case thisCase;
  Map map;
  bool visited=false,wait=false;
  int current=0;

  @override
  Widget build(BuildContext context) {

    map=ModalRoute.of(context).settings.arguments;
    
    if(visited==false)
    {
      thisCase=map['case'];
      current=map['currentPage'];
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: Text(
                    thisCase.caseNumber.toString()
                  ),
                  backgroundColor: Colors.amberAccent,
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(thisCase.clientName),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("vs "+thisCase.opponent),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height:20),
          Card(
            child: Column(
              children: <Widget>[
                Text(
                  "Date: "+thisCase.details[current].date
                ),
                SizedBox(height: 10,),
                Text(
                  current==thisCase.details.length-1?'':"Previous Date: "+thisCase.details[current+1].date
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
                  onPressed: null,
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: null,
                ),
              ],
            ),
          ),       
          SizedBox(height:20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back_ios), 
                onPressed: null
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios), 
                onPressed: null
              ),
            ],
          ),  
        ],
      ),
    );
  }
}
import 'package:advocate/Storage/database.dart';
import 'package:flutter/material.dart';
import 'package:advocate/Case/case.dart';

class SearchByClient extends StatefulWidget {
  @override
  _SearchByClientState createState() => _SearchByClientState();
}

List<Case>cases=List();
class _SearchByClientState extends State<SearchByClient> {


  bool wait=false;
  
  Future<void>getCases()async{
    try{
      setState(() {
        wait=true;
      });

      DbHelper dB=DbHelper();
      await dB.getAllCase().then((value){
        cases=value;
      });

    }catch(e){
      print(e);
    }finally{
      setState(() {
        wait=false;
      });
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
        actions: [
          IconButton(
                  icon: Icon(
                          Icons.search,
                          size:45,
                        ), 
                  onPressed:(){
                    showSearch(context: context, delegate: Search());
                  }
          ),
          SizedBox(width: 20),
        ],
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
                Navigator.pushNamed(context, '/perticularCase',arguments: {'case':cases[index]}).then((s){
                  getCases();
                });
              },
              child:Column(
                children:<Widget>[
                  Text(
                      cases[index].caseNumber,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      Text(
                        cases[index].clientName,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      cases[index].opponent==""?Text(''):
                      Text(
                        "vs "+cases[index].opponent,
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
class Search extends SearchDelegate{
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(
                icon: Icon(Icons.clear),
                onPressed: (){
                  query="";
                },   
    )];
  }

  @override
  Widget buildLeading(BuildContext context) {
    
    return IconButton(
              icon: AnimatedIcon(
                          icon: AnimatedIcons.menu_arrow,
                          progress: transitionAnimation,
                    ),
              onPressed: (){
                close(context,null);
              },
        );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    
    List<Case>suggesstion=List();

    if(query!="")
    {
      suggesstion.clear();
      for(int i=0;i<cases.length;i++)
      {
        if((cases[i].clientName.toLowerCase().contains(query.toLowerCase())) || (cases[i].caseNumber.toLowerCase().contains(query.toLowerCase())))
        {
          suggesstion.insert(0, cases[i]);
        }
      }     
    }

    return ListView.builder(
        itemCount: suggesstion.length,
        itemBuilder: (context,index){
          return Card(
            child:InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/perticularCase',arguments: {'case':suggesstion[index]});
              },
              child:Column(
                children:<Widget>[
                  Text(
                      suggesstion[index].caseNumber.toString(),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:<Widget>[
                      Text(
                        suggesstion[index].clientName,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:<Widget>[
                      suggesstion[index].opponent==""?Text(''):
                      Text(
                        "vs "+suggesstion[index].opponent,
                        style: TextStyle(
                          color:Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ]
                  ),
                ]
              ),
            )
          );
        }
      );

  }
}
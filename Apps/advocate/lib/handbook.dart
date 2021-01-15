import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Handbook extends StatefulWidget {
  @override
  _HandbookState createState() => _HandbookState();
}

class _HandbookState extends State<Handbook> {


  Map urls={
    'ipc':"https://www.indiacode.nic.in/handle/123456789/2263?sam_handle=123456789/1362",
    'crpc':"https://www.indiacode.nic.in/handle/123456789/1611?sam_handle=123456789/1362",
    'iea':"https://www.indiacode.nic.in/handle/123456789/2188?locale=en",
    'cpc':"https://www.indiacode.nic.in/handle/123456789/2191?sam_handle=123456789/1362",
    'coi':"https://www.constitutionofindia.net/constitution_of_india",
  };


  launchUrl(String key)async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String url=prefs.getString(key);
      if(url==null)
        url=urls[key];

      if(await canLaunch(url))
      {
        await launch(url);
      }
      else
        throw "Some error occured";

    }catch(e){
      Toast.show(e,context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Handbook"),
      ),
      body: Column(
        children:[
          Card(
              child: InkWell(
                onTap: (){
                    launchUrl("ipc");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width:80,
                            height:60,
                            color: Colors.amberAccent,
                            child:Center(
                              child: Text(
                                      "IPC",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width:20),
                          Text(
                            "Indian Penal Code",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
          Card(
              child: InkWell(
                onTap: (){
                    launchUrl("crpc");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width:80,
                            height:60,
                            color: Colors.amberAccent,
                            child:Center(
                              child: Text(
                                    "CrPC",
                                    style: TextStyle(
                                      fontSize:18,
                                    )
                                  ),
                            ),
                          ),
                          SizedBox(width:20),
                          Text(
                            "Criminal Procedure Code",
                            style: TextStyle(
                                    fontSize:18,
                                  )
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
          Card(
              child: InkWell(
                onTap: (){
                    launchUrl("iea");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width:80,
                            height:60,
                            color: Colors.amberAccent,
                            child:Center(
                                    child: Text(
                                            "IEA",
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          )
                                      ),
                          ),
                          SizedBox(width:20),
                          Text(
                            "Indian Evidence Act",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
          Card(
              child: InkWell(
                  onTap: (){
                    launchUrl("cpc");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width:80,
                            height:60,
                            color: Colors.amberAccent,
                            child:Center(
                              child: Text(
                                      "CPC",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                  ),
                            ),
                          ),
                          SizedBox(width:20),
                          Text(
                            "Code of Civil Procedure",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
          Card(
              child: InkWell(
                  onTap: (){
                     launchUrl("coi");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width:80,
                            height:60,
                            color: Colors.amberAccent,
                            child:Center(
                              child: Text(
                                      "CoI",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width:20),
                          Text(
                            "Constitution of India",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 35,
                      ),
                    ],
                  ),
                ),
              ),
        ]
      ),
    );
  }
}
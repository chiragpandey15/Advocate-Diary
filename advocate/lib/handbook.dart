import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toast/toast.dart';

class Handbook extends StatefulWidget {
  @override
  _HandbookState createState() => _HandbookState();
}

class _HandbookState extends State<Handbook> {

  launchUrl(String url)async{
    try{
      // print(url);
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
                    launchUrl("https://www.indiacode.nic.in/handle/123456789/2263?sam_handle=123456789/1362");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width:50,
                            color: Colors.amberAccent,
                            child:Text("IPC"),
                          ),
                          Text("Indian Penal Code"),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
          Card(
              child: InkWell(
                onTap: (){
                    launchUrl("https://www.indiacode.nic.in/handle/123456789/1611?sam_handle=123456789/1362");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width:50,
                            color: Colors.amberAccent,
                            child:Text("CrPC"),
                          ),
                          Text("Criminal Procedure Code"),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
          Card(
              child: InkWell(
                onTap: (){
                    launchUrl("https://www.indiacode.nic.in/handle/123456789/2188?locale=en");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width:50,
                            color: Colors.amberAccent,
                            child:Text("IEA"),
                          ),
                          Text("Indian Evidence Act"),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
          Card(
              child: InkWell(
                  onTap: (){
                    launchUrl("https://www.indiacode.nic.in/handle/123456789/2191?sam_handle=123456789/1362");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width:50,
                            color: Colors.amberAccent,
                            child:Text("CPC"),
                          ),
                          Text("Code of Civil Procedure"),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
          Card(
              child: InkWell(
                  onTap: (){
                     launchUrl("https://www.constitutionofindia.net/constitution_of_india");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width:50,
                            color: Colors.amberAccent,
                            child:Text("CoI"),
                          ),
                          Text("Constitution of India"),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ),
        ]
      ),
    );
  }
}
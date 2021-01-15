import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {

  bool wait=false,visited=false;
  String name="",mobile="",description="",allowed="1",oldMobile="";
  Map map=Map();

  Future<void>save()async{
    try{
      setState(() {
        wait=true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String auth=prefs.getString("auth");

      Map <String,String>data={
        'auth':auth,
        'mobile':mobile,
        'description':description,
        'name':name,
        'allowed':allowed,
        'oldNumber':oldMobile,
      };
      final url="http://www.bluepapaya.in/AdvocateManager/block.php";

      final response=await http.post(url,body:data);
      // print(response.body);
      if(response.statusCode==200)
      {
        Toast.show("Done",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);            
      }
      else
      {
        Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);            
      }

    }catch(e){
      Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);    
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
      visited=true;
      oldMobile=map['mobile'];
      mobile=oldMobile;
      name=map['name'];
      description=map['description'];
      allowed=map['allowed'];
    }

    return Scaffold(
      appBar: AppBar(
        title:Text("Edit"),
      ),
      body:wait==true?Center(child: CircularProgressIndicator()):
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children:[
            SizedBox(height:10),
            TextFormField(
                        initialValue: name,
                        decoration: InputDecoration(
                          hintText: "Name of Coordinator",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onChanged: (s){
                          setState(() {
                            name=s;
                          });  
                        },
                    ),
            SizedBox(height:20),
            TextFormField(
                        initialValue: mobile,
                        decoration: InputDecoration(
                          hintText: "Mobile Number",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (s){
                          setState(() {
                            mobile=s;
                          });  
                        },
                    ),
            SizedBox(height:20),

            TextFormField(
                        initialValue: description,
                        decoration: InputDecoration(
                          hintText: "Place and Description",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onChanged: (s){
                          setState(() {
                            description=s;
                          });  
                        },
                    ),
            SizedBox(height:20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text("Allow"),
                    Switch(
                      value: allowed=="1"?true:false,
                      onChanged: (s){
                        setState(() {
                          allowed=s?"1":"0";  
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            MaterialButton(
              onPressed: (){
                save();
              },
              child: Text("Save"),
              color:Colors.amberAccent
            )
          ]
        ),
      ),
    );
  }
}
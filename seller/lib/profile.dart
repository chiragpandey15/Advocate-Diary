import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class Seller{
  String name,mobile,passkey,count;
  Seller(this.name,this.mobile,this.passkey,this.count);
}

class _ProfileState extends State<Profile> {

  bool wait=false,edit=false,obsecure=true;
  Seller seller;


  getProfile()async{
    try{
      setState(() {
        wait=true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String auth=prefs.getString("auth");

      Map data={
        'auth':auth,
      };

      final url="http://www.bluepapaya.in/AdvocateManager/profile.php";
      // print(url);
      final response=await http.post(url,body:data);
      // print(response.body);
      if(response.statusCode==200)
      {
        Map res=jsonDecode(response.body);
        seller=Seller(res['name'],res['mobile'],res['passkey'],res['count']);
        
      }

    }catch(e){
      // print(e);
      Toast.show("Something went wrong. Please try after sometime",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);      
    }finally{
      setState(() {
        wait=false;
      });
    }
  }


  save()async{
    try{

      setState((){
        wait=true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String auth=prefs.getString("auth");

      Map data={
        'auth':auth,
        'loginId':seller.passkey,
      };

      final url="http://www.bluepapaya.in/AdvocateManager/changePasskey.php";
      final response=await http.post(url,body:data);
      // print(response.body);
      if(response.statusCode==200)
      {
        Map res=jsonDecode(response.body);

        if(res['ok']=='1')
        {
          Toast.show("Saved.",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);          
          obsecure=true;
          edit=false;
        }
        else
        {
          Toast.show("Something went wrong. Please try after sometime",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);          
        }
      }
      else
        Toast.show("Something went wrong. Please try after sometime",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);      

    }catch(e){
      Toast.show("Something went wrong. Please try after sometime",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);      
    }finally{
      setState(() {
        wait=false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    getProfile();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Profile"),
      ),
      body: wait==true?Center(child: CircularProgressIndicator()):
      seller==null?Center(child: Text("Something went wrong")):
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: "+seller.name,
              style:TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height:15),
            Text(
              "Mobile: "+seller.mobile,
              style:TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height:15),
            edit==false?Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Passkey: "+seller.passkey,
                  style:TextStyle(
                      fontSize: 18,
                    ),
                ),
                IconButton(
                  onPressed:(){
                    setState((){
                      edit=true;
                    });
                  },
                  icon: Icon(Icons.edit),
                )
              ],
            ):Row(
              children: [
                Expanded(
                                child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Passkey",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              obscureText: obsecure,
                              onChanged: (s){
                                setState(() {
                                  seller.passkey=s;
                                });  
                              },
                          ),
                ),
                Container(
                  child: IconButton(
                    onPressed:(){
                      setState((){
                        obsecure=!obsecure;
                      });
                    },
                    icon:Icon(
                      obsecure?Icons.enhanced_encryption:Icons.remove_red_eye,
                    ),
                    color: Colors.blue,
                  )
                )
              ],
            ),
            SizedBox(height:15),
            Text(
              "Count: "+seller.count,
              style:TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height:25),
            edit?Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: (){
                    //save
                    if(seller.passkey.length>=6)
                    {
                      save();
                    }
                    else
                    {
                      Toast.show("Something went wrong. Please try after sometime",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);                     
                    }
                  },
                  child: Text("Save"),
                  color: Colors.amberAccent,
                ),
              ],
            ):Text('')
          ],
        ),
      ),
    );
  }
}
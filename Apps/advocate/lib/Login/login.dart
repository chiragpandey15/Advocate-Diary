import 'dart:convert';

import 'package:advocate/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis_auth/auth_io.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import 'package:googleapis/drive/v3.dart' as ga;
import 'package:advocate/Storage/driveStorage.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
   
  
  final FirebaseMessaging _firebaseMessaging=FirebaseMessaging();
  // FirebaseAuth _auth=FirebaseAuth.instance;
  // FirebaseUser _user;
  User _user;
  GoogleSignIn _googleSignIn=new GoogleSignIn(
    scopes:[ga.DriveApi.DriveAppdataScope],
    clientId: "89441098307-u2id5vv1mf2si64er3c4h3clvtcn56af.apps.googleusercontent.com",
  );
  String mobile="",token="";
  bool wait=false;
  

  Future<void>sendToServer(String accessToken)async{
    try{
      setState(() {
        wait=true;
      });
      await _firebaseMessaging.getToken().then((s){
          token=s;
      });
      if(token==null)
        token="";

      Map<String,String>data={
        'email':_user.email,
        'name':_user.displayName,
        'mobile':mobile,
        'DToken':token,
      };
      
      
      final url="http://www.bluepapaya.in/AdvocateManager/insertUser.php";
      
      final response =await http.post(url,body:data);
      if(response.statusCode==200)
      {
        Map res=jsonDecode(response.body);
        
        if(res['ok']==1)
        {

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("login",res['auth']); 
          
          if(res.containsKey("expDate"))
          {
            prefs.setString("expDate",res['expDate']);
            prefs.setString("allowed", res['allowed']);
          }

          prefs.setString("user_photoUrl",_user.photoURL);
          prefs.setString("user_name",_user.displayName);
          prefs.setString("user_email",_user.email);
          if(prefs.getString("updateDate")==null)
          {
            DateTime now =DateTime.now();
            String today=now.year.toString();
            if(now.month<10)
              today=today+"-0"+now.month.toString();
            else
              today=today+"-"+now.month.toString();
            
            if(now.day<10)
            {
              today=today+"-0"+now.day.toString();
            }
            else
              today=today+"-"+now.day.toString();

            prefs.setString("updateDate", today);
          }
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>MyHomePage()),(Route<dynamic> route)=>false);
             
        }
        else
        {
          Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);    
        }
      }
      else
      {
        Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);  
      }

    }catch(e){
      print(e);
      Toast.show("Something went to wrong. Please try after some time",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER); 
    }finally{
      setState(() {
        wait=false;
      });
    }
  }

  Future<void>handleSignIn()async{
    try{
      // var authClient= await clientViaUserConsent(ClientId(_clientId, _clientSecret), _scopes,(url){});
            
      setState(() {
        wait=true;
      });      
      await Firebase.initializeApp();
      FirebaseAuth _auth=FirebaseAuth.instance;
      GoogleSignInAccount googleSignInAccount= await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;
      // AuthCredential credential=GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
      AuthCredential credential=GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
      
      // AuthResult result=await _auth.signInWithCredential(credential);
      final result=await _auth.signInWithCredential(credential);

      

      DriveStorage dS=DriveStorage();
      Toast.show("Wait while we get your previous saved data. Make sure your internet is working fine.",context,duration: 2,gravity: 4,backgroundColor: Colors.red);
      bool download=await dS.downloadGoogleDriveFile();
      if(download==false)
        return;
      /********************************************************************************** */

      // print("Current User");
      // print(_googleSignIn.currentUser);
      
      // final header=await googleSignInAccount.authHeaders;
      // var client= GoogleHttpClient(header); 
      
      
      // var drive = ga.DriveApi(client);
      
      // File file=File(path);
      // ga.File fileToUpload=ga.File();

      

      // fileToUpload.parents = ["appDataFolder"];
      // fileToUpload.name = file.absolute.path; 
      // var response = await drive.files.create(  
      //   fileToUpload,  
      //   uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
      // );
      // print(response);
      

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String accessToken=googleSignInAuthentication.accessToken;
      
      prefs.setString("forDrive",accessToken);
      /***************************************************************************************/
      // print(result.user.displayName);
      
      _user=result.user;
      // Toast.show(_user.email.toString()+" "+_user.displayName.toString()+" "+_user.photoURL.toString(),context,duration: 4,gravity: 4,backgroundColor: Colors.red);
      // await sleep(Duration(seconds:2));
      if(_user!=null)
        sendToServer(googleSignInAuthentication.accessToken);

    }catch(e){
      print(e);
    }finally{
      setState((){
        wait=false;
      });
    }



  }

  // Future<void>googleSignOut()async{
  //   try{

  //   }catch(e){
  //     await _auth.signOut().then((value){
  //       _googleSignIn.signOut();
  //       // clear shared pref
  //     });
  //   }
  // }

    
  @override
  void initState(){
    super.initState();
    // Firebase.initializeApp();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: wait==true?Center(child:CircularProgressIndicator()):
      Container(
        decoration: BoxDecoration(
          // image:DecorationImage(
          //    image:AssetImage("Images/logo.jpeg"),
          //   fit:BoxFit.cover,
          // )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color:Colors.white,
              
              child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter mobile number",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (s){
                            mobile=s;
                        },
                    ),
            ),
            SizedBox(height:30),


            MaterialButton(
              onPressed: (){
                if(checkMobile(mobile))
                  handleSignIn();
                else
                {
                  Toast.show("Please enter correct mobile number",context, duration: Toast.LENGTH_LONG,gravity:  Toast.CENTER);  
                }  
              },
              child: Text("Next"),
              color: Colors.blue,
            ),
          ]
        ),
      ), 
    );
  }

  bool checkMobile(String m)
  {
    if(m.length!=10)
      return false;

    for(int i=0;i<10;i++)
    {
      if(m[i]!='0' && m[i]!='1' && m[i]!='2' && m[i]!='3' && m[i]!='4' && m[i]!='5' && m[i]!='6' && 
      m[i]!='7' && m[i]!='8' && m[i]!='9')
        return false;
    }
    return true;   
  }
}
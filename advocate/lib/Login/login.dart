import 'dart:convert';
import 'package:advocate/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis_auth/auth_io.dart';


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


  FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseUser _user;
  GoogleSignIn _googleSignIn=new GoogleSignIn(
    scopes:[ga.DriveApi.DriveAppdataScope],
    clientId: "759019737434-qlvr0f8p0v95o8jps24b99mk2orb8ef0.apps.googleusercontent.com",
  );
  String mobile="",token="";
  bool wait=false;
  

  Future<void>sendToServer(String accessToken)async{
    try{
      setState(() {
        wait=true;
      });

      Map<String,String>data={
        'accessToken':accessToken,
        'email':_user.email,
        'name':_user.displayName,
        'mobile':mobile,
        'DToken':token,
      };

      final url="http://192.168.43.235/Advocate/insertUser.php";
      print(url);
      print(data);
      final response =await http.post(url,body:data);

      if(response.statusCode==200)
      {
        Map res=jsonDecode(response.body);
        print(res);
        print(res['ok']);
        if(res['ok']==1)
        {
          print("Done Dona Done");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("login",res['auth']); 
          
          if(res.containsKey("expDate"))
          {
            prefs.setString("expDate",res['expDate']);
            prefs.setString("allowed", res['allowed']);
          }

          prefs.setString("user_photoUrl",_user.photoUrl);
          prefs.setString("user_name",_user.displayName);
          prefs.setString("user_email",_user.email);
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
      print("ERROR");
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
      GoogleSignInAccount googleSignInAccount= await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;
      AuthCredential credential=GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
      
      AuthResult result=await _auth.signInWithCredential(credential);

      

      DriveStorage dS=DriveStorage();
      Toast.show("Wait while we get your previous saved data. Make sure your internet is working fine.",context,duration: 10,gravity: 4,backgroundColor: Colors.red);
      await dS.downloadGoogleDriveFile();
      
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
      
      _user=result.user;
      if(_user!=null)
        sendToServer(googleSignInAuthentication.accessToken);

    }catch(e){
      print("Error");
      print(e);
    }finally{
      setState((){
        wait=false;
      });
    }



  }

  Future<void>googleSignOut()async{
    try{

    }catch(e){
      await _auth.signOut().then((value){
        _googleSignIn.signOut();
        // clear shared pref
      });
    }
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
          image:DecorationImage(
            image:NetworkImage("http://www.bluepapaya.in/Images/image.jpg"),
            fit:BoxFit.cover,
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                MaterialButton(
                  onPressed: (){
                    handleSignIn();
                  },
                  child: Text("Sign in with Google"),
                  color: Colors.blue,
                ),
              ],
            ),
          ]
        ),
      ), 
    );
  }
}
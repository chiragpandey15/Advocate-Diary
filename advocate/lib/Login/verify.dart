import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Verify extends StatefulWidget {
  @override
  _VerifyState createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {

  bool wait=false,visited=false;
  String otp="",error="",verificationID="";
  FirebaseAuth _auth=FirebaseAuth.instance;

  Future<void>verifyOTP()async{
    try{
      
      AuthCredential credential=PhoneAuthProvider.getCredential(verificationId: verificationID, smsCode: otp);
      
      AuthResult result=await _auth.signInWithCredential(credential);

          FirebaseUser user=result.user;
          if(user!=null){
            //Send to Home page after completing process
          }
          else
          {
            print("Error from Manual");
          }

    }catch(e){

    }
  }

  Future<void>sendOTP(String phone)async{
    try{
      _auth.verifyPhoneNumber(
        phoneNumber: phone, 
        timeout: Duration(minutes: 10), 
        verificationCompleted: (AuthCredential credential)async{
          AuthResult result=await _auth.signInWithCredential(credential);

          FirebaseUser user=result.user;
          if(user!=null){
            //Send to Home page after completing process
          }
          else
          {
            print("Error from automatic");
          }
        }, 
        verificationFailed:(AuthException exception){
          setState(() {
            error="Invalid OTP";
          });
        }, 
        codeSent: (String verificationId,[int forcedSendingToken]){
          verificationID=verificationId;
        }, 
        codeAutoRetrievalTimeout: null
      );
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    if(visited==false)
    {
      Map map=ModalRoute.of(context).settings.arguments;
      String mobile=map['mobile'];
      visited=true;
      sendOTP(mobile);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Pay & Verify"),
      ),
      body: wait==true?Center(child: CircularProgressIndicator(),):
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
                      initialValue: otp,
                      decoration: InputDecoration(
                        hintText: "Passkey",
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onChanged: (s){
                        setState(() {
                          otp=s;
                        });
                      },
                  ),
            SizedBox(height:10),
            MaterialButton(
              onPressed: (){
                verifyOTP();
              },
              child: Text("Pay & Verify"),
            ),
            SizedBox(height:30),
        ],
      )
    );
  }
}
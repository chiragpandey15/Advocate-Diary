import 'package:flutter/services.dart';


class SendSMS{

  var methodChannel=MethodChannel("sendSms");

  Future<bool>send(String message,String phone)async{
    Map<String,String>data={
      "msg":message,
      "phone":phone,
    };
    try{
      await methodChannel.invokeMethod("send",data);
      
    }catch(e){
      print(e);
      
    }
  }
  
}
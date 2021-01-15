
import 'dart:io';
// import 'dart:js';
// import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'httpClient.dart';

class DriveStorage{
  
  GoogleSignIn _googleSignIn=new GoogleSignIn(
    scopes:[ga.DriveApi.DriveAppdataScope],
    clientId: "89441098307-u2id5vv1mf2si64er3c4h3clvtcn56af.apps.googleusercontent.com",
  );
  
  // uploadFile(String path)async{

  //   try{
     
  //     GoogleSignInAccount googleSignInAccount= _googleSignIn.currentUser;

  //     if(googleSignInAccount==null)
  //     {
  //       googleSignInAccount=await _googleSignIn.signInSilently();
  //     }

  //     final header=await googleSignInAccount.authHeaders;
  //     var client= GoogleHttpClient(header); 
      
  //     var drive = ga.DriveApi(client);
      
  //     File file=File(path+"/advocate.db");
      
  //     ga.File fileToUpload=ga.File();
      
  //     // String q=await getDatabasesPath();
  //     // List p=Directory(q).listSync();
  //     // print("Files");
  //     // for(final abc in p)
  //     // {
  //     //   print(abc);
  //     //   if(abc.runtimeType=="File")
  //     //     print(abc.path);
  //     // }
  //     // String x="/storage/emulated/0/Download/advocate.pdf";
  //     // await File(x).writeAsString(file.readAsStringSync());
  //     // print("Local Back up done");


  //     fileToUpload.parents = ["appDataFolder"];
  //     fileToUpload.name = "advocate.db"; 
      
  //     var response = await drive.files.create(  
  //       fileToUpload,
  //       uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
  //     );

  //     file=File(path+"/advocate.db-shm");

  //     fileToUpload.name="advocate.db-shm";

  //     response = await drive.files.create(  
  //       fileToUpload,
  //       uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
  //     );

  //     file=File(path+"/advocate.db-wal");
  //     fileToUpload.name="advocate.db-wal";

  //     response = await drive.files.create(  
  //       fileToUpload,
  //       uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
  //     );
      
  //     print(response);
  //     print(response.size);
  //     print("Upload Hogaya");

  //   }catch(e){
  //     print("Drive upload");
  //     print(e);
  //   } 
  // }


  // Future<void>updateToDrive()async{

  //   GoogleSignInAccount googleSignInAccount= _googleSignIn.currentUser;

  //     if(googleSignInAccount==null)
  //     {
  //       googleSignInAccount=await _googleSignIn.signInSilently();
  //     }

  //     final header=await googleSignInAccount.authHeaders;
  //     var client= GoogleHttpClient(header); 
      
  //     var drive = ga.DriveApi(client);


  //     String dirPath=await getDatabasesPath();

  //     drive.files.list(spaces: 'appDataFolder').then((list) {  
  //     for (var i = 0; i < list.files.length; i++) {  
  //       File file=File(dirPath+"/"+list.files[i].name);
  //       ga.File fileToUpload= ga.File();
  //       fileToUpload.name = list.files[i].name; 

  //       drive.files.update(
  //         fileToUpload,
  //         list.files[i].id,
  //         uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
  //       );
  //     }    
  //   }); 

  // }


  Future<void> listGoogleDriveFiles() async {  

    GoogleSignInAccount googleSignInAccount= _googleSignIn.currentUser;

      final header=await googleSignInAccount.authHeaders;
      var client= GoogleHttpClient(header); 
      
      var drive = ga.DriveApi(client);

    
   
   drive.files.list(spaces: 'appDataFolder').then((list) {  
      for (var i = 0; i < list.files.length; i++) {  
        print("Id: ${list.files[i].id} File Name:${list.files[i].name}");  
      }    
    }); 
     
   }


  //  Future<String>getDatabasePath(String dbName) async{
    
  //   final databasePath=await getDatabasesPath();

  //   final path=join(databasePath,dbName);
  //   return path;
    
  // }

  createAndBackUp(var drive)async{
    try{
      ga.File fileToUpload=ga.File();
      fileToUpload.parents = ["appDataFolder"];
      String path=await getDatabasesPath();
      
      File file=File(path+"/advocate.db");

       await drive.files.create(  
        fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
      );

      file=File(path+"/advocate.db-shm");

      fileToUpload.name="advocate.db-shm";

      await drive.files.create(  
        fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
      );

      file=File(path+"/advocate.db-wal");
      fileToUpload.name="advocate.db-wal";

      await drive.files.create(  
        fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
      );

    }catch(e){
      _googleSignIn.requestScopes(
        [ga.DriveApi.DriveAppdataScope]
      );
    }
  }

  update(var drive)async{
    String dirPath=await getDatabasesPath();

    
      
      drive.files.list(spaces: 'appDataFolder').then((list) {  
      for (var i = 0; i < list.files.length; i++) {  
        if(list.files[i].name.contains("advocate")==false)
            continue;
        File file=File(dirPath+"/"+list.files[i].name);
        ga.File fileToUpload= ga.File();
        fileToUpload.name = list.files[i].name; 
        
        drive.files.update(
          fileToUpload,
          list.files[i].id,
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
        );
      }    
    }); 
  }

  Future<void>backUpToDrive()async{
    GoogleSignInAccount googleSignInAccount= _googleSignIn.currentUser;

    if(googleSignInAccount==null)
    {
      googleSignInAccount=await _googleSignIn.signInSilently();
    }

    try{
      final header=await googleSignInAccount.authHeaders;
      var client= GoogleHttpClient(header); 
      
      var drive = ga.DriveApi(client);

      
      drive.files.list(spaces: 'appDataFolder').then((list){
        if(list.files.length==0)
        {
          createAndBackUp(drive);
        }
        else
        {
          update(drive);
        }
      });
    }catch(e){
      print(e);
    }
  }

   Future<void> downloadGoogleDriveFile() async {  
   
   
   GoogleSignInAccount googleSignInAccount= _googleSignIn.currentUser;

    if(googleSignInAccount==null)
    {
      googleSignInAccount=await _googleSignIn.signInSilently();
    }
    await _googleSignIn.signIn();
    final header=await googleSignInAccount.authHeaders;
    var client= GoogleHttpClient(header); 
    
    var drive = ga.DriveApi(client);

    drive.files.list(spaces: 'appDataFolder').then((list) async{
      
      try{
        if(list.files.length==0)
          return;

        String dirPath=await getDatabasesPath();

        for(final x in list.files)
        {
          if(x.name.contains("advocate")==false)
            continue;
          String fileID=x.id;
          ga.Media file = await drive.files  
          .get(fileID, downloadOptions: ga.DownloadOptions.FullMedia);    

          
          String path=dirPath+"/"+x.name;
          
          File saveFile=File(path);
          List<int> dataStore = [];  

          file.stream.listen((data) {  
              
                dataStore.insertAll(dataStore.length, data);  
            }, onDone: () async{  
                saveFile.writeAsBytes(dataStore,flush:true);  
                
                List<int> z=await saveFile.readAsBytes();
                
          }, onError: (error) {  
                print(error);
          });  

        }

      }catch(e){
        print(e);
      }

    });
 }  
   
     

}
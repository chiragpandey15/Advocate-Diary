
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'httpClient.dart';

class DriveStorage{
  
  GoogleSignIn _googleSignIn=new GoogleSignIn(
    scopes:[ga.DriveApi.DriveFileScope],
    clientId: "759019737434-qlvr0f8p0v95o8jps24b99mk2orb8ef0.apps.googleusercontent.com",
  );
  
  uploadFile(String path)async{

    try{
     
      GoogleSignInAccount googleSignInAccount= _googleSignIn.currentUser;

      if(googleSignInAccount==null)
      {
        googleSignInAccount=await _googleSignIn.signInSilently();
      }

      final header=await googleSignInAccount.authHeaders;
      var client= GoogleHttpClient(header); 
      
      var drive = ga.DriveApi(client);
      
      File file=File(path+"/advocate.db");
      
      ga.File fileToUpload=ga.File();
      
      // String q=await getDatabasesPath();
      // List p=Directory(q).listSync();
      // print("Files");
      // for(final abc in p)
      // {
      //   print(abc);
      //   if(abc.runtimeType=="File")
      //     print(abc.path);
      // }
      // String x="/storage/emulated/0/Download/advocate.pdf";
      // await File(x).writeAsString(file.readAsStringSync());
      // print("Local Back up done");


      fileToUpload.parents = ["appDataFolder"];
      fileToUpload.name = "advocate.db"; 
      
      var response = await drive.files.create(  
        fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
      );

      file=File(path+"/advocate.db-shm");

      fileToUpload.name="advocate.db-shm";

      response = await drive.files.create(  
        fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
      );

      file=File(path+"/advocate.db-wal");
      fileToUpload.name="advocate.db-wal";

      response = await drive.files.create(  
        fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
      );
      
      print(response);
      print(response.size);
      print("Upload Hogaya");

    }catch(e){
      print("Drive upload");
      print(e);
    } 
  }


  Future<void>updateToDrive()async{

    GoogleSignInAccount googleSignInAccount= _googleSignIn.currentUser;

      if(googleSignInAccount==null)
      {
        googleSignInAccount=await _googleSignIn.signInSilently();
      }

      final header=await googleSignInAccount.authHeaders;
      var client= GoogleHttpClient(header); 
      
      var drive = ga.DriveApi(client);


      String dirPath=await getDatabasesPath();

      drive.files.list(spaces: 'appDataFolder').then((list) {  
      for (var i = 0; i < list.files.length; i++) {  
        File file=File(dirPath+"/"+list.files[i].name);
        ga.File fileToUpload= ga.File();
        // fileToUpload.parents = ["appDataFolder"];
        fileToUpload.name = list.files[i].name; 

        drive.files.update(
          fileToUpload,
          list.files[i].id,
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()),  
        );
      }    
    }); 

  }


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


   Future<String>getDatabasePath(String dbName) async{
    
    final databasePath=await getDatabasesPath();

    final path=join(databasePath,dbName);
    return path;
    
  }

   Future<void> downloadGoogleDriveFile() async {  
   
   
   GoogleSignInAccount googleSignInAccount= _googleSignIn.currentUser;

    if(googleSignInAccount==null)
    {
      googleSignInAccount=await _googleSignIn.signInSilently();
    }
    print("Download called");
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
          String fileID=x.id;
          ga.Media file = await drive.files  
          .get(fileID, downloadOptions: ga.DownloadOptions.FullMedia);    

          String path=dirPath+"/"+x.name;
          
          File saveFile=File(path);
          List<int> dataStore = [];  

          file.stream.listen((data) {  
              // print("DataReceived: ${data.length}");  
              // print(data);
                dataStore.insertAll(dataStore.length, data);  
            }, onDone: () async{  
                print("Task Done");  
                saveFile.writeAsBytes(dataStore,flush:true);  
                print("Abb read karte hue");
                List<int> z=await saveFile.readAsBytes();
                print(z);
                print("File saved at ${saveFile.path}");  
          }, onError: (error) {  
                print("Some Error");  
                print(error);
          });  

        }

      }catch(e){
        print("Problem hai baka");
        print(e);
      }

    });
 }  
   
     

}
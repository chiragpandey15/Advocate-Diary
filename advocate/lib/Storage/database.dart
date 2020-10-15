
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/driveStorage.dart';

class DbHelper{

  String path;
  Database db;
  static const CaseTable='CaseTable';
  static const caseId='id';
  static const caseNumber='caseNumber';
  static const clientName='clientName';
  static const clientMobile='clientMobile';
  static const weAre='weAre';
  static const opponent='opponent';
  static const opponentAdvocate='opponentAdvocate';
  static const courtName='courtName';
  static const courtNumber='courtNumber';
  static const caseFee='caseFee';
  static const messagePermission='messsagePermission';
  static const description="description";
  
  
  //*********************************************************** */
  
  static const DetailsTable='DetailsTable';
  static const detailsId='id';
  static const caseID='caseID';
  static const date='date';
  static const stage='stage';
  static const extraNote='extraNote';
  static const paymentDemand='paymentDemand';
  static const previousDate='previousDate';


  //***************************************************************** */

  static const MessageTable="MessageTable";
  static const messageId="ID";
  static const message="textMessage";
  static const permission="allowed";


  Future<void>createTable(Database db) async{
    String sql='''CREATE TABLE $CaseTable
    (
      $caseId INTEGER PRIMARY KEY AUTOINCREMENT,
      $caseNumber TEXT,
      $clientName TEXT,
      $clientMobile TEXT,
      $weAre TEXT,
      $opponent TEXT,
      $opponentAdvocate TEXT,
      $courtName TEXT,
      $courtNumber TEXT,
      $caseFee INTEGER DEFAULT 0,
      $messagePermission INTEGER,
      $description TEXT
    )''';

    try{
      await db.execute(sql);
    }catch(e){
      print("CREATE TABLE 1");
      print(e);
    }

    

    sql='''CREATE TABLE $DetailsTable
    (
      $detailsId INTEGER PRIMARY KEY AUTOINCREMENT,
      $caseID INTEGER,
      $date TEXT,
      $stage TEXT,
      $extraNote TEXT,
      $paymentDemand TEXT,
      $previousDate TEXT,
      FOREIGN KEY($caseID) REFERENCES $CaseTable($caseId)
    )''';
    
    try{
      await db.execute(sql);
    }catch(e){
      print("CREATE TABLE 2");
      print(e);
    }

    sql='''CREATE TABLE $MessageTable
    (
      $messageId INTEGER PRIMARY KEY AUTOINCREMENT,
      $message TEXT,
      $permission INTEGER
    )''';

    try{
      await db.execute(sql);
    }catch(e){
      print("CREATE TABLE 3");
      print(e);
    }

    sql='''INSERT INTO $MessageTable Values(1,"Next Date is #1",1)''';
    String sql1='''INSERT INTO $MessageTable Values(2,"Reminder: tomorrow you have case date",1)''';
    String sql2='''INSERT INTO $MessageTable Values(3, "Come for meeting on #1 at #2.",1)''';
    try{
      
      await db.execute(sql);
      await db.execute(sql1);
      await db.execute(sql2);
    }catch(e){
      print(e);
    }


  }

  Future<String>getDatabasePath(String dbName) async{
    
    final databasePath=await getDatabasesPath();
    final path=join(databasePath,dbName);
    try{
      if(await Directory(dirname(path)).exists())
      {
        return path;
      }
      else
      {
        await Directory(dirname(path)).create(recursive: true);
      }
    }catch(e){
      print("Database Path");
      print(e);
    }
    return path;
  }

  Future<void>initDatabse() async{
    path=await getDatabasePath('advocate.db');
    print(path);
    db=await openDatabase(path,version:1,onCreate: onCreate);
    
  }

  Future<void>onCreate(Database db,int version) async {
    await createTable(db);
  }


  Future<void>log()async{
    await initDatabse();

    String dirPath=await getDatabasesPath();

    // DriveStorage ds=DriveStorage();
    // await ds.uploadFile(dirPath);

    // print("Done Sucessfully");
    // await ds.listGoogleDriveFiles();

    String sql='''SELECT * FROM ${DbHelper.CaseTable} where id=2''';
    final data=await db.rawQuery(sql);
    print("Data");
    print(data);
    for(final x in data)
    {
      print(x);
    }
    print("################################################################");
    sql='''SELECT * FROM ${DbHelper.DetailsTable}''';
    final info=await db.rawQuery(sql);
    for(final x in info)
    {
      print(x);
    }

    sql="SELECT * from $MessageTable";
    final result=await db.rawQuery(sql);
    print(result);
  }

  Future<List<Case>>getCaseByDate(String queryDate) async{
    await initDatabse();
    String sql='''SELECT $caseID FROM ${DbHelper.DetailsTable} WHERE $date="$queryDate"''';
    final data=await db.rawQuery(sql);
    print(sql);
    print("Data");
    print(data);
    List<Case>cases =List();

    for(final detail in data)
    {
      int id=detail['caseID'];
      sql='''SELECT * from $CaseTable where $caseId = $id''';
      print(sql);
      final result=await db.rawQuery(sql);
      print(result);
      for(final i in result)
      {
        cases.add(
          new Case(
            id,i['$caseNumber'],i['$clientName'],i['$clientMobile'],i['$weAre'],i['$opponent'],i['$opponentAdvocate'],
            i['$courtName'],i['$courtNumber'],i['$caseFee'],
            i['$messagePermission']=='1'?true:false,i['$description']
          )
        );
      }
    }
    return cases;
  }

  Future<List<Case>>getAllCase() async{
    await initDatabse();
    final  sql='''SELECT * from $CaseTable ORDER BY $caseId''';
    final result=await db.rawQuery(sql);
    print("Result");
    print(result);
    List<Case>cases=List();
    for(final i in result)
    {
      cases.add(
        new Case(
          i['$caseId'],i['$caseNumber'],i['$clientName'],i['$clientMobile'],i['$weAre'],i['$opponent'],i['$opponentAdvocate'],
            i['$courtName'],i['$courtNumber'],i['$caseFee'],
            i['$messagePermission']=='1'?true:false,i['$description']
        )
      );
    }
    return cases;
  }
  
  Future<List<Details>>getDetails(int id) async{
    await initDatabse();
    String sql='''SELECT * FROM ${DbHelper.DetailsTable} WHERE $caseID=$id ORDER BY $detailsId DESC''';
    final data=await db.rawQuery(sql);

    List<Details>details =List();

    for(final detail in data)
    {
      details.add(
        Details(
          detail['$detailsId'],detail['$date'],detail['$previousDate'],detail['$stage'],detail['$extraNote'],
          detail['$paymentDemand']
        )
      );
    }
    return sortByDate(details);
  }


  Future<void>addCase(Case newCase) async{
    await initDatabse();
    final sql='''INSERT INTO ${DbHelper.CaseTable}
    (
      ${DbHelper.caseNumber},
      ${DbHelper.clientName},
      ${DbHelper.clientMobile},
      ${DbHelper.weAre},
      ${DbHelper.opponent},
      ${DbHelper.opponentAdvocate},
      ${DbHelper.courtName},
      ${DbHelper.courtNumber},
      ${DbHelper.caseFee},
      ${DbHelper.messagePermission},
      ${DbHelper.description}
    )  
    VALUES
    (
      "${newCase.caseNumber}",
      "${newCase.clientName}",
      "${newCase.clientMobile}",
      "${newCase.weAre}",
      "${newCase.opponent}",
      "${newCase.opponentAdvocate}",
      "${newCase.courtName}",
      "${newCase.courtNumber}",
      "${newCase.caseFee}",
      "${newCase.messagePermission}",
      "${newCase.description}"
    )''';
    
    final result=await db.rawQuery(sql);
  }


  Future<void>addDetails(Details detail,int id) async{
    await initDatabse();
    
    final sql='''INSERT INTO ${DbHelper.DetailsTable}
    (
      ${DbHelper.caseID},
      ${DbHelper.date},
      ${DbHelper.stage},
      ${DbHelper.extraNote},
      ${DbHelper.paymentDemand},
      ${DbHelper.previousDate}
    )  
    VALUES
    (
      "$id",
      "${detail.date}",
      "${detail.stage}",
      "${detail.extraNote}",
      "${detail.paymentDemand}",
      "${detail.previousDate}"
    )''';
    
    final result=await db.rawQuery(sql);
  }

  Future<void>deleteCase(int id) async{
    await initDatabse();

    String sql='''DELETE FROM ${DbHelper.DetailsTable} WHERE ${DbHelper.caseID}==$id
    ''';
    await db.rawQuery(sql);


    sql='''DELETE FROM ${DbHelper.CaseTable} WHERE ${DbHelper.caseId}==$id
    ''';
    final result=await db.rawQuery(sql);

    
  }

  Future<void>deleteDetails(int id) async{
    await initDatabse();
    final sql='''DELETE FROM ${DbHelper.DetailsTable} WHERE ${DbHelper.detailsId}==$id
    ''';
    final result=await db.rawQuery(sql);
  }

  Future<void>updateCase(Case updatedCase,int id)async{
    await initDatabse();
    final sql='''UPDATE ${DbHelper.CaseTable} SET 
    ${DbHelper.caseNumber}="${updatedCase.caseNumber}"
    ,${DbHelper.clientName}="${updatedCase.clientName}"
    ,${DbHelper.clientMobile}="${updatedCase.clientMobile}"
    ,${DbHelper.weAre}="${updatedCase.weAre}"
    ,${DbHelper.opponent}="${updatedCase.opponent}"
    ,${DbHelper.opponentAdvocate}="${updatedCase.opponentAdvocate}"
    ,${DbHelper.courtName}="${updatedCase.courtName}"
    ,${DbHelper.courtNumber}="${updatedCase.courtNumber}"
    ,${DbHelper.caseFee}="${updatedCase.caseFee}"
    ,${DbHelper.messagePermission}="${updatedCase.messagePermission}"
    ,${DbHelper.description}="${updatedCase.description}"
     WHERE ${DbHelper.caseId}=$id
    ''';
    final result=await db.rawQuery(sql);
  }

  Future<void>updateDetails(Details detail,int id,int _caseID)async{
    await initDatabse();
    final sql='''UPDATE ${DbHelper.DetailsTable} SET 
    ${DbHelper.date}="${detail.date}"
    ,${DbHelper.previousDate}="${detail.previousDate}"
    ,${DbHelper.stage}="${detail.stage}"
    ,${DbHelper.extraNote}="${detail.extraNote}"
    ,${DbHelper.paymentDemand}="${detail.paymentDemand}"
    
     WHERE ${DbHelper.detailsId}=$id AND ${DbHelper.caseID}=$_caseID
    ''';
    final result=await db.rawQuery(sql);
    
  }

  Future<Map>getMessage(int id) async
  {
    await initDatabse();
    String sql="SELECT * from $MessageTable where $messageId=$id";
    print(sql);
    final result=await db.rawQuery(sql);
    return result[0];
  }

  Future<Map>updateMessage(int id,String text,int allowed) async
  {
    await initDatabse();
    String sql="UPDATE $MessageTable set $message='$text', $permission=$allowed where $messageId=$id";
    print(sql);
    final result=await db.rawQuery(sql);
    return result[0];
  }

  List<Details>sortByDate(List<Details>details)
  {
    DateTime now=DateTime.now();
    for(int i=0;i<details.length;i++)
    {
      DateTime thisDate=DateTime.parse(details[i].date);
      details[i].number=now.difference(thisDate).inDays;
    }
    for(int i=0;i<details.length;i++)
    {
      for(int j=i+1;j<details.length;j++)
      {
        if(details[i].number>details[j].number)
        {
          Details temp=details[i];
          details[i]=details[j];
          details[j]=temp;
        }
      }
    }
    return details;
  }

}

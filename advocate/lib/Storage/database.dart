import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:advocate/Case/case.dart';


// Database db;
class DbHelper{
  Database db;
  static const CaseTable='CaseTable';
  static const caseId='id';
  static const caseNumber='caseNumber';
  static const clientName='clientName';
  static const clientMobile='clientMobile';
  static const opponent='opponent';
  static const weAre='weAre';
  static const courtName='courtName';
  static const courtNumber='courtNumber';
  static const caseFee='caseFee';
  static const registeredDate='registeredDate';
  static const messagePermission='messsagePermission';
  static const firstDate='firstDate';
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

  Future<void>createTable(Database db) async{
    String sql='''CREATE TABLE $CaseTable
    (
      $caseId INTEGER PRIMARY KEY AUTOINCREMENT,
      $caseNumber INTEGER,
      $clientName TEXT,
      $clientMobile TEXT,
      $opponent TEXT,
      $weAre TEXT,
      $courtName TEXT,
      $courtNumber INTEGER,
      $caseFee INTEGER DEFAULT 0,
      $registeredDate TEXT,
      $messagePermission INTEGER,
      $firstDate TEXT,
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

  }

  Future<String>getDatabasePath(String dbName) async{
    
    final databasePath=await getDatabasesPath();
    final path=join(databasePath,dbName);
    try{
      if(await Directory(dirname(path)).exists())
      {
        // await deleteDatabase(path);
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
    final path=await getDatabasePath('Case');
    db=await openDatabase(path,version:1,onCreate: onCreate);
    // print (db);
  }

  Future<void>onCreate(Database db,int version) async {
    await createTable(db);
  }


  Future<void>log()async{
    await initDatabse();
    String sql='''SELECT * FROM ${DbHelper.CaseTable}''';
    final data=await db.rawQuery(sql);
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
  }

  Future<List<Case>>getCaseByDate(String queryDate) async{
    await initDatabse();
    String sql='''SELECT $caseID FROM ${DbHelper.DetailsTable} WHERE $date=$queryDate''';
    final data=await db.rawQuery(sql);

    List<Case>cases =List();

    for(final detail in data)
    {
      int id=detail['caseID'];
      sql='''SELECT * from $CaseTable where $caseId= $id''';
      final result=await db.rawQuery(sql);
      for(final i in result)
      {
        cases.add(
          new Case(
            id,i['$caseNumber'],i['$clientName'],i['$clientMobile'],i['$opponent'],
            i['$weAre'],i['$courtName'],i['$courtNumber'],i['$caseFee'],i['$registeredDate'],
            i['$messagePermission']=='1'?true:false,i['$firstDate'],i['$description']
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
    List<Case>cases=List();
    for(final i in result)
    {
      cases.add(
        new Case(
          i['$caseId'],i['$caseNumber'],i['$clientName'],i['$clientMobile'],i['$opponent'],
          i['$weAre'],i['$courtName'],i['$courtNumber'],i['$caseFee'],i['$registeredDate'],
          i['$messagePermission']=='1'?true:false,i['$firstDate'],i['$description']
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
    return details;
  }


  Future<void>addCase(Case newCase) async{
    await initDatabse();
    final sql='''INSERT INTO ${DbHelper.CaseTable}
    (
      ${DbHelper.caseNumber},
      ${DbHelper.clientName},
      ${DbHelper.clientMobile},
      ${DbHelper.opponent},
      ${DbHelper.weAre},
      ${DbHelper.courtName},
      ${DbHelper.courtNumber},
      ${DbHelper.caseFee},
      ${DbHelper.registeredDate},
      ${DbHelper.messagePermission},
      ${DbHelper.firstDate},
      ${DbHelper.description}
    )  
    VALUES
    (
      "${newCase.caseNumber}",
      "${newCase.clientName}",
      "${newCase.clientMobile}",
      "${newCase.opponent}",
      "${newCase.weAre}",
      "${newCase.courtName}",
      "${newCase.courtNumber}",
      "${newCase.caseFee}",
      "${newCase.registeredDate}",
      "${newCase.messagePermission}",
      "${newCase.firstDate}",
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
    String sql='''DELETE FROM ${DbHelper.CaseTable} WHERE ${DbHelper.caseId}==$id
    ''';
    final result=await db.rawQuery(sql);

    sql='''DELETE FROM ${DbHelper.DetailsTable} WHERE ${DbHelper.caseID}==$id
    ''';
    await db.rawQuery(sql);
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
    ,${DbHelper.opponent}="${updatedCase.opponent}"
    ,${DbHelper.weAre}="${updatedCase.weAre}"
    ,${DbHelper.courtName}="${updatedCase.courtName}"
    ,${DbHelper.courtNumber}="${updatedCase.courtNumber}"
    ,${DbHelper.caseFee}="${updatedCase.caseFee}"
    ,${DbHelper.registeredDate}="${updatedCase.registeredDate}"
    ,${DbHelper.messagePermission}="${updatedCase.messagePermission}"
    ,${DbHelper.firstDate}="${updatedCase.firstDate}"
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

}

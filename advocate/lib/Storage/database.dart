
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:advocate/Case/case.dart';
import 'package:advocate/Storage/driveStorage.dart';

class DbHelper{

  String path;
  Database db;
  DriveStorage dS=DriveStorage();
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
  static const dispose="Dispose";
  
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

  //************************************************************************* */
  static const AccountTable="AccountTable";
  static const accountId='ID';
  
  static const text="TextMessage";


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
      print(e);
    }

    sql='''INSERT INTO $MessageTable Values(1,"Next Date is #1",1)''';
    String sql1='''INSERT INTO $MessageTable Values(2,"Tomorrow will be your case hearing.",1)''';
    String sql2='''INSERT INTO $MessageTable Values(3, "Come for meeting on #1 at #2.",1)''';
    String sql3='''INSERT INTO $MessageTable Values(4, "Kindly pay #3 by #1",1)''';
    try{
      
      await db.execute(sql);
      await db.execute(sql1);
      await db.execute(sql2);
      await db.execute(sql3);
    }catch(e){
      print(e);
    }

    sql='''CREATE TABLE $AccountTable(
      $accountId INTEGER PRIMARY KEY AUTOINCREMENT,
      $caseID INTEGER,
      $text TEXT
    )''';

    try{
      await db.execute(sql);
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
      print(e);
    }
    return path;
  }


  Future<void>getUpdate()async{
    String sql='''SELECT ${DbHelper.dispose} FROM ${DbHelper.CaseTable}''';
    final data=await db.rawQuery(sql);
    try{
      if(data.length==0)
      {
        sql='''ALTER TABLE ${DbHelper.CaseTable} Add Column ${DbHelper.dispose} INT(1) DEFAULT 0''';
        await db.rawQuery(sql);
      }
    }catch(e){
      print(e);
    }
    
  }

  Future<void>initDatabse() async{
    path=await getDatabasePath('advocate.db');
    
    db=await openDatabase(path,version:1,onCreate: onCreate);

    await getUpdate();
    
  }

  Future<void>onCreate(Database db,int version) async {
    await createTable(db);
  }


  Future<void>log()async{
    await initDatabse();

    String sql='''SELECT * FROM ${DbHelper.CaseTable} where id=2''';
    final data=await db.rawQuery(sql);
    
    for(final x in data)
    {
      print(x);
    }
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
    
    List<Case>cases =List();

    for(final detail in data)
    {
      int id=detail['caseID'];
      sql='''SELECT * from $CaseTable where $caseId = $id''';
      
      final result=await db.rawQuery(sql);
      
      for(final i in result)
      {
        int fee=0;
        if(i['$caseFee']!='null')
          fee=i['$caseFee'];


        cases.add(
          new Case(
            id,i['$caseNumber'],i['$clientName'],i['$clientMobile'],i['$weAre'],i['$opponent'],i['$opponentAdvocate'],
            i['$courtName'],i['$courtNumber'],fee,
            i['$messagePermission']==1?true:false,i['$description']
          )
        );
      }
    }
    return cases;
  }

  Future<List<Case>>getAllCase() async{
    await initDatabse();
    final  sql='''SELECT * from $CaseTable ORDER BY $caseId DESC''';
    final result=await db.rawQuery(sql);
    
    List<Case>cases=List();
    for(final i in result)
    {
      int fee=0;
      if(i['$caseFee']!='null')
        fee=i['$caseFee'];
      
      cases.add(
        new Case(
          i['$caseId'],i['$caseNumber'].toString(),i['$clientName'].toString(),i['$clientMobile'].toString(),i['$weAre'].toString()
          ,i['$opponent'].toString(),i['$opponentAdvocate'].toString(),i['$courtName'].toString(),i['$courtNumber'].toString(),fee,
            i['$messagePermission']==1?true:false,i['$description'].toString()
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
    
    int id=await db.insert(
        "${DbHelper.CaseTable}",
        {
          "${DbHelper.caseNumber}":"${newCase.caseNumber}",
          "${DbHelper.clientName}":"${newCase.clientName}",
          "${DbHelper.clientMobile}":"${newCase.clientMobile}",
          "${DbHelper.weAre}":"${newCase.weAre}",
          "${DbHelper.opponent}":"${newCase.opponent}",
          "${DbHelper.opponentAdvocate}":"${newCase.opponentAdvocate}",
          "${DbHelper.courtName}":"${newCase.courtName}",
          "${DbHelper.courtNumber}":"${newCase.courtNumber}",
          "${DbHelper.caseFee}":"${newCase.caseFee}",
          "${DbHelper.messagePermission}":(newCase.messagePermission==true)?1:0,
          "${DbHelper.description}":"${newCase.description}",
        }
        
      );
    dS.backUpToDrive();
    await addDetails(newCase.details[0],id);
  }


  Future<void>addDetails(Details detail,int id) async{
    await initDatabse();
    

    await db.insert(
      "${DbHelper.DetailsTable}",
      {
        "${DbHelper.caseID}":"$id",
        "${DbHelper.date}":"${detail.date}",
        "${DbHelper.stage}":"${detail.stage}",
        "${DbHelper.extraNote}":"${detail.extraNote}",
        "${DbHelper.paymentDemand}":"${detail.paymentDemand}",
        "${DbHelper.previousDate}":"${detail.previousDate}",
      }
    );
    dS.backUpToDrive();
    
  }

  Future<void>deleteCase(int id) async{
    await initDatabse();

    String sql='''DELETE FROM ${DbHelper.DetailsTable} WHERE ${DbHelper.caseID}==$id
    ''';
    await db.rawQuery(sql);


    sql='''DELETE FROM ${DbHelper.CaseTable} WHERE ${DbHelper.caseId}==$id
    ''';
    final result=await db.rawQuery(sql);
    
    dS.backUpToDrive();
    
  }

  Future<void>deleteDetails(int id) async{
    await initDatabse();
    final sql='''DELETE FROM ${DbHelper.DetailsTable} WHERE ${DbHelper.detailsId}==$id
    ''';
    final result=await db.rawQuery(sql);
    dS.backUpToDrive();
  }

  Future<void>updateCase(Case updatedCase,int id)async{
    await initDatabse();
    int permission=updatedCase.messagePermission?1:0;
    
    await db.update(
      "${DbHelper.CaseTable}",
      {
        "${DbHelper.caseNumber}":"${updatedCase.caseNumber}"
      ,"${DbHelper.clientName}":"${updatedCase.clientName}"
      ,"${DbHelper.clientMobile}":"${updatedCase.clientMobile}"
      ,"${DbHelper.weAre}":"${updatedCase.weAre}"
      ,"${DbHelper.opponent}":"${updatedCase.opponent}"
      ,"${DbHelper.opponentAdvocate}":"${updatedCase.opponentAdvocate}"
      ,"${DbHelper.courtName}":"${updatedCase.courtName}"
      ,"${DbHelper.courtNumber}":"${updatedCase.courtNumber}"
      ,"${DbHelper.caseFee}":"${updatedCase.caseFee}"
      ,"${DbHelper.messagePermission}":"$permission"
      ,"${DbHelper.description}":"${updatedCase.description}"
      },
      where: "${DbHelper.caseId}=?",
      whereArgs: ["$id"],
    );

    dS.backUpToDrive();

  }

  Future<void>updateDetails(Details detail,int id,int _caseID)async{
    await initDatabse();
    

    await db.update(
      "${DbHelper.DetailsTable}",
      {
        "${DbHelper.date}":"${detail.date}"
      ,"${DbHelper.previousDate}":"${detail.previousDate}"
      ,"${DbHelper.stage}":"${detail.stage}"
      ,"${DbHelper.extraNote}":"${detail.extraNote}"
      ,"${DbHelper.paymentDemand}":"${detail.paymentDemand}"
      },
      where: "${DbHelper.detailsId}=?",
      whereArgs: ["$id"],
    );

    dS.backUpToDrive();
  }

  Future<Map>getMessage(int id) async
  {
    await initDatabse();
    String sql="SELECT * from $MessageTable where $messageId=$id";
    
    final result=await db.rawQuery(sql);
    return result[0];
  }

  Future<void>updateMessage(int id,String text,int allowed) async
  {
    await initDatabse();
    await db.update(
      "${DbHelper.MessageTable}",
      {
        "$message":"$text",
        "$permission":"$allowed"
      },
      where: "$messageId = $id",
      // whereArgs: ["$id"],
    );
    dS.backUpToDrive();
  }

  Future<void>addAcount(Fee account)async{
    await initDatabse();

    await db.insert(
      "$AccountTable",
      {
        "$caseID":account.caseID,
        "$text":account.text
      }
    );
    dS.backUpToDrive();
  }

  Future<void>updateAccount(Fee account)async{
    await initDatabse();
    
    await db.update(
      "$AccountTable",
      {
        "$caseID":account.caseID,
        "$text":account.text
      },
      where: "$accountId = ${account.id}",
    );
    dS.backUpToDrive();
  }

  Future<void>deleteAccount(int id)async{
    await initDatabse();

    await db.delete(
      "$AccountTable",
      where: "$accountId = $id",
    );
    dS.backUpToDrive();
  }

  Future<List<Fee>>getAccount(int id)async{
    await initDatabse();
    List<Fee>list=List();

    String sql="SELECT * from $AccountTable where $caseID=$id ORDER BY $accountId DESC";
    final data=await db.rawQuery(sql);

    for(final x in data)
    {
      list.add(
        Fee(x['$accountId'],x['$caseID'],x['$text'])
      );
    }
    
    return list;
  }

  Future<void>logAccount()async{
    await initDatabse();

    String sql="SELECT * from $AccountTable";
    final data=await db.rawQuery(sql);

    for(final x in data)
    {
      print(x);
    }
  }
  
  Future<void>disposeCase(int caseNo, String disposedMessage)async{
    await initDatabse();
    await db.update(
      "$CaseTable",
      {
        "$dispose":1,
      },
      where: "$caseId = $caseNo",
    );

    DateTime now=DateTime.now();
    String day=now.day.toString();
        if(now.day<10)
          day="0"+day;

        String month=now.month.toString();
        if(now.month<10)
          month="0"+month;

        String dateStored=now.year.toString()+"-"+month+"-"+day;

    await addDetails(
              Details(0,dateStored,"",disposedMessage,"",""),
              caseNo
            );
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

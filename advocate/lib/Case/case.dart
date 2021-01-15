class Fee{
  int id;
  int caseID;
  String text;

  Fee(this.id,this.caseID,this.text);
}



class Details{
  int id;
  int number;
  String date;
  String previousDate;
  String stage;
  String extraNote;
  String paymentDemand;
  


  Details(
    this.id,
    this.date,
    this.previousDate,
    this.stage,
    this.extraNote,
    this.paymentDemand,
    
  );
}


class Case{
  int id;
  String caseNumber;
  String clientName;
  String clientMobile;
  String weAre;
  String opponent;
  String opponentAdvocate;
  String courtName;
  String courtNumber;
  int caseFee;
  bool messagePermission;
  String description;
  List<Details>details;


  Case(
      this.id,
      this.caseNumber,
      this.clientName,
      this.clientMobile,
      this.weAre,
      this.opponent,
      this.opponentAdvocate,
      this.courtName,
      this.courtNumber,
      this.caseFee,
      this.messagePermission,
      this.description
    );
}
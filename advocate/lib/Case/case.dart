class Details{
  int id;
  String date;
  String stage;
  String extraNote;
  String paymentDemand;
  


  Details(
    this.id,
    this.date,
    this.stage,
    this.extraNote,
    this.paymentDemand,
    
  );

  int getID(){
    return this.id;
  }

  String getDate(){
    return this.date;
  }

  String getStage(){
    return this.stage;
  }

  String getExtraNote(){
    return this.extraNote;
  }

  String getPaymentDemand(){
    return this.paymentDemand;
  }

  
}


class Case{
  int id;
  int caseNumber;
  String clientName;
  String clientMobile;
  String opponent;
  String weAre;
  String courtName;
  int courtNumber;
  int caseFee;
  String registeredDate;
  bool messagePermission;
  String firstDate;
  List<Details>details;


  Case(
      this.id,
      this.caseNumber,
      this.clientName,
      this.clientMobile,
      this.opponent,
      this.weAre,
      this.courtName,
      this.courtNumber,
      this.caseFee,
      this.registeredDate,
      this.messagePermission,
      this.firstDate
    );

    Case.fromJson(Map<String,dynamic>json)
    {
      // this.id=json[DbHelper.id];
      // this.topic=json[DbHelper.topic];
      // this.description=json[DbHelper.description];
      // this.startTime=json[DbHelper.startTime];
      // this.endTime=json[DbHelper.endTime];
      // this.day=json[DbHelper.day];
    }

    int getID(){
      return this.id;
    }
  
    String getName(){
      return this.clientName;
    }

    String getNumber(){
      return this.clientMobile;
    } 

    String getOpponent(){
      return this.opponent;
    }

    String getWeAre(){
      return this.weAre;
    } 

    String getCourtName(){
      return this.courtName;
    }

    int getCourtNumber(){
      return this.courtNumber;
    }

    int getCaseNumber(){
      return this.caseNumber;
    }

    int getCaseFee(){
      return this.caseFee;
    }

    String getregisteredDate(){
      return this.registeredDate;
    }

    bool getMessagePermission(){
      return this.messagePermission;
    }

    String getFirstDate(){
      return this.firstDate;
    }

    List<Details>getDetails(){
      return this.details;
    }
    
    void addDetails(Details detail){
      this.details.add(detail);
    }
}
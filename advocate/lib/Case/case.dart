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

    String getCourtNumber(){
      return this.courtNumber;
    }

    String getCaseNumber(){
      return this.caseNumber;
    }

    int getCaseFee(){
      return this.caseFee;
    }

    

    bool getMessagePermission(){
      return this.messagePermission;
    }

    

    

    List<Details>getDetails(){
      return this.details;
    }
    
    void addDetails(Details detail){
      this.details.add(detail);
    }
}
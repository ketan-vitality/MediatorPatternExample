abstract class Command {
  void land();

  void getReadyFor(String name);
}

abstract class IATCMediator {
  void registerRunway(Runway runway);

  void registerFlight(Flight flight);

  bool askForLanding(Flight flight);

  void setIsLanded({required Flight flight, required String runwayName});
}

class ATCMediator extends IATCMediator {
  late List<Flight> flight;
  late List<Runway> runway;

  ATCMediator() {
    flight = [];
    runway = [];
  }

  @override
  void registerRunway(Runway runway) {
    this.runway.add(runway);
  }

  @override
  void registerFlight(Flight flight) {
    this.flight.add(flight);
  }

  @override
  bool askForLanding(Flight flight) {
    var isRunwayAvailable = false;
    for (var item in runway) {
      if (item.bookFor == null) {
        item.getReadyFor(flight.flightName!);
        flight.getReadyFor(item.runwayName);
        isRunwayAvailable = true;
        break;
      }
    }
    return isRunwayAvailable;
  }

  @override
  void setIsLanded({required Flight flight, required String runwayName}) {
    for (var item in runway) {
      if (item.runwayName == runwayName) {
        item.land();
        item.getReadyFor('');
      }
    }
    flight.runwayName = null;
    flight.isLanded = true;
  }
}

class Flight extends Command {
  String? flightName;
  IATCMediator atcMediator;
  String? runwayName;
  bool gotLandingPermission;
  bool isLanded;

  Flight({required this.flightName, required this.atcMediator, this.isLanded = false, this.gotLandingPermission = false});

  @override
  void land() {
    if (atcMediator.askForLanding(this)) {
      gotLandingPermission = true;
    } else {
      print("Flight: $flightName is Waiting for landing due to all runways are occupied");
    }
  }

  @override
  void getReadyFor(String name) {
    runwayName = name;
    print('Fight: $flightName Got the Permission to land on Runway number : $name');
  }

  void setIsLanded(){
    atcMediator.setIsLanded(flight: this, runwayName: runwayName!);
  }
}

class Runway extends Command {
  String runwayName;
  String? bookFor;
  IATCMediator atcMediator;

  Runway({required this.runwayName, required this.atcMediator, this.bookFor});

  @override
  void getReadyFor(String name) {
    if (name.isNotEmpty) {
      bookFor = name;
      print("Runway:$runwayName is Ready for Flight $name");
    } else {
      bookFor = null;
      print('Runway number : $runwayName is Available for next Flight');
    }
  }

  @override
  void land() {
    print('Flight $bookFor is Successfully landed on Runway Number: $runwayName');
  }
}

void main() {
  IATCMediator atcMediator = ATCMediator();
  Flight spiceJet = Flight(flightName: 'spiceJet', atcMediator: atcMediator);
  Flight airAsia = Flight(flightName: 'airAsia', atcMediator: atcMediator);
  Runway runway1 = Runway(runwayName: '1', atcMediator: atcMediator);
  atcMediator.registerFlight(spiceJet);
  atcMediator.registerFlight(airAsia);
  atcMediator.registerRunway(runway1);
  spiceJet.land();
  airAsia.land();
  if(spiceJet.gotLandingPermission){
    spiceJet.setIsLanded();
  }
  if (!airAsia.isLanded) {
    airAsia.land();
  }
  if(airAsia.gotLandingPermission){
    airAsia.setIsLanded();
  }
}

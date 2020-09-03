import 'package:flutter_app/models/review.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecensioneBloc extends Bloc<RecensioneEvent, RecensioneState> {
  RecensioneBloc(String localita) : super(RecensioneState(localita));
  RecensioneProvider _provider = RecensioneProvider();

  @override
  Stream<RecensioneState> mapEventToState(RecensioneEvent event) async* {
    final currentState = state;
    if (event is SearchEvent) {
      SearchEvent search = event;
      try {
        List<dynamic> r = await _provider.search(event.localita);
        yield state.._recensioni = r;
      } catch (error) {
        print(error);
      }
    }
  }
}

class RecensioneState {
  List<dynamic> _recensioni = [];
  String localita;

  List<Recensione> get recensioni => new List.from(_recensioni);

  RecensioneState(this.localita);
}

abstract class RecensioneEvent {}

class SearchEvent extends RecensioneEvent {
  String localita;

  SearchEvent(this.localita);
}

class AddEvent extends RecensioneEvent {
  Recensione r;

  AddEvent(this.r);

  Future<List<Recensione>> add() async {}
}

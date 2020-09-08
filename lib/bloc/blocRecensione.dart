import 'dart:convert';

import 'package:flutter_app/models/review.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class RecensioneBloc extends Bloc<RecensioneEvent, RecensioneState> {
  RecensioneBloc(String localita) : super(RecensioneState(localita));
  RecensioneProvider _provider = RecensioneProvider();

  @override
  Stream<RecensioneState> mapEventToState(RecensioneEvent event) async* {
    final currentState = state;
    if (event is SearchEvent) {
      SearchEvent search = event;
      List<dynamic> r = (await _provider.search(event.localita));
      yield state..recensioni = r;
    } else if (event is AddEvent) {
      Response response = await addRec(event.r);
      if (response.statusCode >= 400) {
        yield RecensioneState(state.localita, false)
          ..recensioni = List<dynamic>.from(state.recensioni);
      } else {
        state.recensioni.insert(0, event.r);
        yield RecensioneState(state.localita, true)
          ..recensioni = List<dynamic>.from(state.recensioni);
      }
    }
  }

  Future<Response> addRec(Recensione r) async {
    var url = Uri.http('agenziaviaggi.ddns.net', '/review');
    var post = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(r));
    return post;
  }
}

class RecensioneState {
  List<dynamic> recensioni = [];
  String localita;
  bool added = false;

  RecensioneState(this.localita, [this.added]);
}

abstract class RecensioneEvent {}

class SearchEvent extends RecensioneEvent {
  String localita;

  SearchEvent(this.localita);
}

class AddEvent extends RecensioneEvent {
  Recensione r;

  AddEvent(this.r);
}

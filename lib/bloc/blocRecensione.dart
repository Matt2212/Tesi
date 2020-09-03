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
      List<dynamic> r = await _provider.search(event.localita);
      yield state.._recensioni = r;
    }
    if (event is AddEvent) {
      Response response = await addRec(event.r);
      if (response.statusCode >= 400) {
        yield state..added = false;
      }
      else {
        print(response.statusCode);
        state.recensioni.add(event.r);
        yield state..added = true;
      }
    }
  }

  Future<Response> addRec(Recensione r) async {
    var url = Uri.http('192.168.0.9:8080', '/review');
    var post = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(r));
    return post;
  }
}

class RecensioneState {
  List<dynamic> _recensioni = [];
  String localita;
  bool added = false;

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
}

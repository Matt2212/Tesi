import 'dart:convert';

import 'package:flutter_app/models/review.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ReiewBloc extends Bloc<ReviewEvent, ReiewState> {
  ReiewBloc(String localita) : super(ReiewState(localita));
  RecensioneProvider _provider = RecensioneProvider();

  @override
  Stream<ReiewState> mapEventToState(ReviewEvent event) async* {
    if (event is SearchEvent) {
      List<dynamic> r = (await _provider.search(event.localita));
      yield state..recensioni = r;
    } else if (event is AddEvent) {
      Response response = await addRec(event.r);
      if (response.statusCode >= 400) {
        yield ReiewState(state.localita, false)
          ..recensioni = List<dynamic>.from(state.recensioni);
      } else {
        state.recensioni.insert(0, event.r);
        yield ReiewState(state.localita, true)
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

class ReiewState {
  List<dynamic> recensioni = [];
  String localita;
  bool added = false;

  ReiewState(this.localita, [this.added]);
}

abstract class ReviewEvent {}

class SearchEvent extends ReviewEvent {
  String localita;

  SearchEvent(this.localita);
}

class AddEvent extends ReviewEvent {
  Recensione r;

  AddEvent(this.r);
}

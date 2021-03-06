import 'dart:convert';

import 'package:flutter_app/models/client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

abstract class ClientState {
  Cliente c;
}

class UnLoggedState extends ClientState {
  bool error = false;

  UnLoggedState() {
    c = Cliente(0, 'Guest', 'Guest', "guest");
  }
}

class LoggedState extends ClientState {
  LoggedState(cl) {
    c = cl;
  }
}

abstract class UserEvent {}

class LoginEvent extends UserEvent {
  String nome, password;

  LoginEvent(this.nome, this.password);
}

class AddAcquisto extends UserEvent {
  AddAcquisto(this._acquisto) {
    _acquisto.data = DateTime.now();
  }

  Acquisto _acquisto;
}

class ClientBloc extends Bloc<UserEvent, ClientState> {
  ClientBloc() : super(UnLoggedState());

  @override
  Stream<ClientState> mapEventToState(UserEvent event) async* {
    if (event is AddAcquisto) {
      state.c.acquisti.insert(0, event._acquisto);
      yield state;
    }
    if (event is LoginEvent) {
      yield await _login(event.nome, event.password);
    }
  }

  Future<ClientState> _login(String nome, String password) async {
    var url = Uri.http('agenziaviaggi.ddns.net', '/user',
        {'user': nome, 'password': password});
    Response response = await http.get(url);
    if (response.statusCode >= 400) {
      return (state as UnLoggedState)..error = true;
    }
    Cliente c = Cliente.fromJson(json.decode(response.body));
    c.acquisti.sort((a1, a2) => a1.data == null
        ? 1
        : a2.data == null
            ? -1
            : a2.data.millisecondsSinceEpoch - a1.data.millisecondsSinceEpoch);
    return LoggedState(c);
  }
}

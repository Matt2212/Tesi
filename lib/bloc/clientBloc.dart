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
  AddAcquisto(String nome, this._acquisto) {
    _acquisto.data = DateTime.now();
  }

  Acquisto _acquisto;
}

class ClientBloc extends Bloc<UserEvent, ClientState> {
  ClientBloc() : super(UnLoggedState());

  @override
  Stream<ClientState> mapEventToState(UserEvent event) async* {
    if (event is AddAcquisto) {
      state.c.acquisti.add(event._acquisto);
      yield state;
    } else if (event is LoginEvent) {
      ClientState user = await _login(event.nome, event.password);
      yield user;
    }
  }

  Future<ClientState> _login(String nome, String password) async {
    var url = Uri.http(
        '192.168.0.9:8080', '/user', {'user': nome, 'password': password});
    Response response = await http.get(url);
    if (response.statusCode >= 400) {
      return (state as UnLoggedState)
        ..error = true;
    }
    Cliente c = Cliente.fromJson(json.decode(response.body));
    return LoggedState(c);
  }

}

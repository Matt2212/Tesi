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

class LoginEvent {
  String nome;

  LoginEvent(this.nome);
}

class ClientBloc extends Bloc<LoginEvent, ClientState> {
  ClientBloc() : super(UnLoggedState());

  @override
  Stream<ClientState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEvent) {
        ClientState user = await _login(event.nome);
        yield user;
    }
  }

  Future<ClientState> _login(String nome) async {
    var url = Uri.http('192.168.0.9:8080', '/user', {'user': nome});
    Response response = await http.get(url);
    if(response.statusCode >= 400) {
      return (state as UnLoggedState)..error = true;
    }

    Cliente c = Cliente.fromJson(json.decode(response.body));
    return LoggedState(c);
  }

}

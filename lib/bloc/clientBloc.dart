import 'dart:convert';

import 'package:flutter_app/models/client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

abstract class ClientState {
  Cliente c;
}

class UnLoggedState extends ClientState {
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
      try {
        Cliente user = await _login(event.nome);
        yield LoggedState(user);
      } catch (error) {
        yield state as UnLoggedState;
      }
    }
  }

  Future<Cliente> _login(String nome) async {
    var url = Uri.http('192.168.0.9:8080', '/user', {'user': nome});
    String body = (await http.get(url)).body;
    print(body);
    return Cliente.fromJson(json.decode(body).cast<Map<String, dynamic>>());
  }
}

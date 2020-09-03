import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/clientBloc.dart';
import 'package:flutter_app/models/pacchettiVacanza.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Cliente {
  int id;
  String nome, cognome, email, username, recapito;
  List<Acquisto> acquisti = [];

  Cliente(this.id, this.nome, this.cognome, this.username);

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cognome = json['cognome'];
    email = json['email'];
    username = json['username'];
    recapito = json['password'];
  }
}

class Acquisto {
  int id, acquirente;
  DateTime data;
  double prezzoTotale;
  List<DettaglioPrenotazione> prenotazioni;

  Acquisto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    acquirente = json['acquirente'];
    data = DateTime.fromMillisecondsSinceEpoch(json['data']);
    prenotazioni = json['prenotazioni']
        .map<dynamic>((json) => DettaglioPrenotazione.fromJson(json))
        .toList();
  }
}

class DettaglioPrenotazione {
  int id, acquisto, postiPrenotati;
  PacchettoVacanza pacchettoVacanza;

  DettaglioPrenotazione(
      this.id, this.acquisto, this.postiPrenotati, this.pacchettoVacanza);

  DettaglioPrenotazione.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    acquisto = json['acquisto'];
    postiPrenotati = json['postiPrenotati'];
    pacchettoVacanza = PacchettoVacanza.fromJson(json[pacchettoVacanza]);
  }
}

class LoginPage extends StatelessWidget {
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 2),
        child: BlocBuilder<ClientBloc, ClientState>(builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textEditingController,
                onChanged: (username) => {},
                decoration: InputDecoration(
                  labelText: 'username',
                  errorText: (true) ? 'username non valido' : null,
                ),
              ),
              const Padding(padding: EdgeInsets.all(1)),
              RaisedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    context
                        .bloc<ClientBloc>()
                        .add(LoginEvent(textEditingController.text));
                  }),
            ],
          );
        }),
      ),
    );
  }
}

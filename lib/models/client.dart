import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/cartBloc.dart';
import 'package:flutter_app/bloc/clientBloc.dart';
import 'package:flutter_app/models/pacchettiVacanza.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Cliente {
  int id;
  String nome, cognome, email, username, recapito, password;
  List<Acquisto> acquisti = [];

  Cliente(this.id, this.nome, this.cognome, this.username);

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cognome = json['cognome'];
    email = json['email'];
    username = json['userName'];
    recapito = json['recapito'];
    password = json['password'];
    acquisti = List<Map<String, dynamic>>.from(json['acquisti'])
        .map((e) => Acquisto.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'cognome': cognome,
        'email': email,
        'userName': username,
        'recapito': recapito,
    'password': password
      };
}

class Acquisto {
  int id, acquirente;
  DateTime data;
  double prezzoTotale;
  List<DettaglioPrenotazione> prenotazioni;

  Acquisto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    acquirente = json['acquirente'];
    data = json['data'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['data']);
    prezzoTotale = json['prezzoTotale'];
    prenotazioni = List<Map<String, dynamic>>.from(json['prenotazioni'])
        .map((e) => DettaglioPrenotazione.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'acquirente': acquirente,
        'data': data == null ? null : data.millisecondsSinceEpoch,
        'prezzoTotale': prezzoTotale,
        'prenotazioni': prenotazioni
      };
}

class DettaglioPrenotazione {
  int id, acquisto, postiPrenotati;
  PacchettoVacanza pacchettoVacanza;

  DettaglioPrenotazione(this.id, this.acquisto, this.postiPrenotati,
      this.pacchettoVacanza);

  DettaglioPrenotazione.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    acquisto = json['acquisto'];
    postiPrenotati = json['postiPrenotati'];
    pacchettoVacanza = PacchettoVacanza.fromJson(json['pacchettoVacanza']);
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'acquisto': acquisto,
        'postiPrenotati': postiPrenotati,
        'pacchettoVacanza': pacchettoVacanza
      };
}

class LoginPage extends StatelessWidget {
  final textEditingControllerUsr = TextEditingController();
  final textEditingControllerPasswd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: BlocBuilder<ClientBloc, ClientState>(
                  buildWhen: (previous, current) => previous == current,
                  builder: (context, state) {
                    return Column(
                      children: [
                        TextField(
                          controller: textEditingControllerUsr,
                          decoration: InputDecoration(
                            labelText: 'username',
                            errorText: ((state as UnLoggedState).error)
                                ? 'username o password non validi'
                                : null,
                          ),
                        ),
                        TextField(
                          obscureText: true,
                          controller: textEditingControllerPasswd,
                          decoration: InputDecoration(
                            labelText: 'password',
                          ),
                        ),
                      ],
                    );
                  }),
            ),
            const Padding(padding: EdgeInsets.all(1)),
            BlocListener<ClientBloc, ClientState>(
              listener: (context, state) {
                if (state is LoggedState)
                  context.bloc<CartBloc>().add(MergeCart(state.c.username));
              },
              child: RaisedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    BlocProvider.of<ClientBloc>(context)
                        .add(LoginEvent(textEditingControllerUsr.text,
                        textEditingControllerPasswd.text));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

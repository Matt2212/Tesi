import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/cartBloc.dart';
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
    username = json['userName'];
    recapito = json['recapito'];
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

  Map<String, dynamic> toJson() =>
      {
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
  final textEditingController = TextEditingController();

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
                    return TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        labelText: 'username',
                        errorText: ((state as UnLoggedState).error)
                            ? 'username non valido'
                            : null,
                      ),
                    );
                  }),
            ),
            const Padding(padding: EdgeInsets.all(1)),
            RaisedButton(
                child: const Text('Login'),
                onPressed: () {
                  // ignore: close_sinks
                  var bloc = BlocProvider.of<ClientBloc>(context);
                  bloc.add(LoginEvent(textEditingController.text));
                  bloc.listen((c) {
                    if (c is LoggedState) {
                      var bloc = context.bloc<CartBloc>();
                      bloc.add(MergeCart(c.c.username));
                      bloc.listen((state) =>
                          Navigator.of(context).popAndPushNamed('/account'));
                    }
                  });
                }),
          ],
        ),
      ),
    );
  }
}

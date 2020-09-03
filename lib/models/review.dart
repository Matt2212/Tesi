import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/blocRecensione.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'client.dart';

class RecensionePK {
  int cliente;
  String localita;
  DateTime data;

  RecensionePK(this.cliente, this.localita, this.data);

  RecensionePK.fromJson(Map<String, dynamic> json) {
    cliente = json['cliente'] as int;
    localita = json['localita'] as String;
    data = DateTime.fromMillisecondsSinceEpoch(json['data']);
  }
}

class Recensione {
  RecensionePK id;
  int valutazione;
  String descrizione;
  Cliente cliente;

  Recensione.fromJson(Map<String, dynamic> json) {
    id = RecensionePK.fromJson(json['id']);
    valutazione = json['valutazione'];
    descrizione = json['descrizione'];
    cliente = Cliente.fromJson(json['cliente']);
  }

  Recensione(
      String localita, this.valutazione, this.descrizione, this.cliente) {
    id.data = DateTime.now();
    id.cliente = cliente.id;
    id.localita = localita;
  }

  @override
  String toString() {
    return 'Recensione{id: $id, valutazione: $valutazione, descrizione: $descrizione, cliente: $cliente}';
  }
}

class RecensioneProvider {
  final String url = 'http://192.168.0.9:8080/review';

  Future<dynamic> search(String localita) async {
    Response r = await http.get("$url/$localita");
    return compute(parseReview, r.body);
  }
}

List<dynamic> parseReview(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<dynamic>((json) => Recensione.fromJson(json)).toList();
}

class RecensioneWD extends StatefulWidget {
  final localita;

  RecensioneWD(this.localita);

  @override
  _RecensioneWDState createState() => _RecensioneWDState();
}

class _RecensioneWDState extends State<RecensioneWD> {
  final TextEditingController textEditingController = TextEditingController();

  RecensioneBloc recensioneBloc;

  _RecensioneWDState() {
    recensioneBloc = RecensioneBloc(widget.localita);
    recensioneBloc.add(SearchEvent(widget.localita));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: 'Inserisci un commento',
              border: OutlineInputBorder(),
            ),
            scrollController: ScrollController(),
            enabled: true,
            //TODO INSERISCI IL CONTROLLO SUL LOGIN,
            maxLines: 4,
          ),
          padding: EdgeInsets.all(10),
        ),
        RaisedButton(
          color: Colors.deepOrange,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          onPressed: () {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text('Commento inviato')));
          },
          child: Text(
            "Invia",
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 300.0,
            minHeight: 100.0,
          ),
          child: BlocBuilder<RecensioneBloc, RecensioneState>(
            cubit: recensioneBloc,
            builder: (BuildContext context, state) => ListView.separated(
              itemBuilder: (context, index) {
                Recensione r = state.recensioni[index];
                return ExpansionTile(
                  title: Text('${r.cliente.nome} ${r.cliente.cognome}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('valutazione: ${r.valutazione}'),
                  children: [
                    Text(r.descrizione, style: TextStyle(fontSize: 16)),
                  ],
                );
              },
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
              itemCount: state.recensioni.length,
              shrinkWrap: true,
            ),
          ),
        )
      ],
    );
  }
}

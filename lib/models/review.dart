import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/blocRecensione.dart';
import 'package:flutter_app/bloc/clientBloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'client.dart';
import 'localita.dart';

@JsonSerializable()
class RecensionePK {
  int cliente;
  String localita;
  DateTime data;

  RecensionePK();

  RecensionePK.complete(this.cliente, this.localita, this.data);

  factory RecensionePK.fromJson(Map<String, dynamic> json) {
    int cliente = json['cliente'] as int;
    String localita = json['localita'] as String;
    DateTime data = DateTime.fromMillisecondsSinceEpoch(json['data']);
    return RecensionePK.complete(cliente, localita, data);
  }

  Map<String, dynamic> toJson() =>
      {'cliente': cliente, 'localita': localita, 'data': data.millisecond};
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
    id = RecensionePK();
    id.data = DateTime.now();
    id.cliente = cliente.id;
    id.localita = localita;
  }

  Map<String, dynamic> toJson() => {
        'id': id.toJson(),
        'cliente': cliente.toJson(),
        'valutazione': valutazione,
        'descrizione': descrizione,
      };

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
  _RecensioneWDState createState() => _RecensioneWDState(localita);
}

class _RecensioneWDState extends State<RecensioneWD> {
  final TextEditingController textEditingController = TextEditingController();

  RecensioneBloc recensioneBloc;
  Localita localita;

  int _counter = 0;

  _RecensioneWDState(this.localita) {
    recensioneBloc = RecensioneBloc(localita.nome);
    recensioneBloc.add(SearchEvent(localita.nome));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => recensioneBloc,
      child: Column(
        children: [
          if (context
              .bloc<ClientBloc>()
              .state is LoggedState) ...[
            Row(
              children: [
                FlatButton(
                  child: Icon(
                    Icons.add,
                  ),
                  onPressed: () {
                    if (_counter < 5) _counter++;
                    setState(() {});
                  },
                ),
                Expanded(
                    child: Text(
                      '$_counter',
                      textAlign: TextAlign.center,
                    )),
                FlatButton(
                  child: Icon(
                    Icons.remove,
                  ),
                  onPressed: () {
                    if (_counter > 0) {
                      _counter--;
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            Container(
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: 'Inserisci un commento',
                  border: OutlineInputBorder(),
                ),
                scrollController: ScrollController(),
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
              onPressed: () async {
                var bloc = context.bloc<ClientBloc>();
                Recensione r = Recensione(localita.nome, _counter,
                    textEditingController.text, bloc.state.c);
                recensioneBloc.add(AddEvent(r));
              },
              child: Text(
                "Invia",
                style: TextStyle(fontSize: 20.0),
              ),
            )
          ] else
            Padding(padding: EdgeInsets.all(10)),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300.0,
              minHeight: 100.0,
            ),
            child: BlocBuilder<RecensioneBloc, RecensioneState>(
              builder: (BuildContext context, state) =>
                  SafeArea(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        Recensione r = state.recensioni[index];
                        return ExpansionTile(
                          title: Text('${r.cliente.nome} ${r.cliente.cognome}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${DateFormat('d/M/yyyy, HH:mm').format(
                                  r.id.data)}\nvalutazione: ${r.valutazione}'),
                          children: [
                            Text(r.descrizione, style: TextStyle(fontSize: 16)),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Divider(
                            color: Colors.black,
                          ),
                      itemCount: state.recensioni.length,
                      shrinkWrap: true,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

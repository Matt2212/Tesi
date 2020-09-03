import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PacchettoVacanzaPK {
  DateTime dataPartenza;
  String localita;

  PacchettoVacanzaPK(this.dataPartenza, this.localita);

  PacchettoVacanzaPK.fromJson(Map<String, dynamic> json) {
    dataPartenza = DateTime.fromMillisecondsSinceEpoch(json['dataPartenza']);
    localita = json['localita'] as String;
  }

  @override
  String toString() {
    return 'PacchettoVacanzaPK{dataPartenza: $dataPartenza, localita: $localita}';
  }
}

class PacchettoVacanza {
  PacchettoVacanzaPK pacchetto;
  int postiDisp, giorniPermanenza;
  double prezzo;
  String descrizione;

  PacchettoVacanza(this.pacchetto, this.postiDisp, this.giorniPermanenza,
      this.prezzo, this.descrizione);

  PacchettoVacanza.fromJson(Map<String, dynamic> json) {
    pacchetto = PacchettoVacanzaPK.fromJson(json['pacchetto']);
    postiDisp = json['postiDisp'] as int;
    giorniPermanenza = json['giorniPermanenza'] as int;
    prezzo = json['prezzo'] as double;
    descrizione = json['descrizione'] as String;
  }

  @override
  String toString() {
    return 'PacchettoVacanza{pacchetto: $pacchetto}';
  }
}

class PacchettoVacanzaProvider {
  var url;

  PacchettoVacanzaProvider(String name) {
    url = Uri.http('192.168.0.9:8080', '/localita/pacchetti', {'l': name});
  }

  Future<dynamic> pacchetti() async {
    Response r = await http.get(url);
    return parsePacchetto(r.body);
  }
}

List<dynamic> parsePacchetto(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<dynamic>((json) => PacchettoVacanza.fromJson(json))
      .toList();
}

class PacchettoVacanzaWd extends StatelessWidget {
  final String _localita;

  PacchettoVacanzaWd(this._localita);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PacchettoVacanzaProvider(_localita).pacchetti(),
      builder: (context, snapshoot) {
        if (snapshoot.connectionState == ConnectionState.done)
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 200.0,
              minHeight: 100.0,
            ),
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
              itemCount: snapshoot.data.length,
              itemBuilder: (context, index) {
                PacchettoVacanza pv = snapshoot.data[index] as PacchettoVacanza;
                return ListTile(
                    title: Text(
                        'Data e ora di partenza: ${DateFormat('d/M/yyyy, HH:mm').format(pv.pacchetto.dataPartenza)}'),
                    onTap: () async {
                      int number = await showDialog(
                        context: context,
                        builder: (_) => SimpleDialog(
                          title:
                              Text('Selezionare il numero di posti prenotare:'),
                          children: [
                            Center(
                                child:
                                    Text('Posti disponibili ${pv.postiDisp}')),
                            Prenotazione(pv.postiDisp)
                          ],
                        ),
                      );

                      if (number == null || number <= 0) return;
                      //TODO add al carrello e crea la prenotazione
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text("$number")));
                    });
              },
              shrinkWrap: true,
            ),
          );
        else if (snapshoot.hasError)
          return Text('errore');
        else
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 200.0,
              minHeight: 100.0,
            ),
            child: Center(child: CircularProgressIndicator()),
          );
      },
    );
  }
}

class Prenotazione extends StatefulWidget {
  final posti;

  Prenotazione(this.posti);

  @override
  _PrenotazioneState createState() => _PrenotazioneState(posti);
}

class _PrenotazioneState extends State<Prenotazione> {
  int _counter = 0;
  int posti;

  _PrenotazioneState(this.posti);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            FlatButton(
              child: Icon(
                Icons.add,
              ),
              onPressed: () {
                if (_counter < posti) _counter++;
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
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, _counter);
          },
          child: const Text('Aggiungi al carrello',
              style: TextStyle(fontWeight: FontWeight.bold)),
          padding: EdgeInsets.all(10),
        ),
      ],
    );
  }
}

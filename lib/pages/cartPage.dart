import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/bloc/cartBloc.dart';
import 'package:flutter_app/bloc/clientBloc.dart';
import 'package:flutter_app/models/client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
        builder: (BuildContext context, state) {
      List<DettaglioPrenotazione> prenotazioni = state.a.prenotazioni;
      return Scaffold(
        appBar: AppBar(
          title: Text('Carrello'),
        ),
        body: (prenotazioni.isEmpty)
            ? Center(child: Text('Carrello vuoto'))
            : ListView.separated(
                itemBuilder: (good, index) {
                  DettaglioPrenotazione prenotazione = prenotazioni[index];
                  return ExpansionTile(
                    key: Key(index.toString()),
                    title: Text(
                      '${prenotazione.pacchettoVacanza.pacchetto.localita} ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    trailing: Text(
                      sprintf('%1.2f €', [
                        prenotazione.postiPrenotati *
                            prenotazione.pacchettoVacanza.prezzo
                      ]),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                      textAlign: TextAlign.end,
                    ),
                    subtitle: Text('Prezzo unitario: ${sprintf('%1.2f €', [
                      prenotazione.pacchettoVacanza.prezzo
                    ])}\n'
                        'Data e ora di partenza: ${DateFormat('d/M/yyyy, HH:mm').format(prenotazione.pacchettoVacanza.pacchetto.dataPartenza)}\n'
                        'Giorni di permanenza: ${prenotazione.pacchettoVacanza.giorniPermanenza}\n'
                        'Posti prenotati:'),
                    children: [
                      ButtonBar(
                        children: [
                          FlatButton(
                            onPressed: () {
                              int counter = prenotazione.postiPrenotati;
                              if (counter <
                                  prenotazione.pacchettoVacanza.postiDisp) {
                                counter++;
                                context
                                    .bloc<CartBloc>()
                                    .add(SetDettaglio(index, counter));
                              }
                            },
                            child: Icon(Icons.add),
                          ),
                          Text('${prenotazione.postiPrenotati}'),
                          FlatButton(
                            onPressed: () {
                              int counter = prenotazione.postiPrenotati;
                              if (counter > 1) {
                                counter--;
                                context
                                    .bloc<CartBloc>()
                                    .add(SetDettaglio(index, counter));
                              }
                            },
                            child: Icon(Icons.remove),
                          ),
                          RaisedButton(
                            child: Row(
                              children: [
                                Text('Rimuovi'),
                                Icon(Icons.delete),
                              ],
                            ),
                            onPressed: () {
                              good.bloc<CartBloc>().add(RemoveCart(index));
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.black),
                itemCount: prenotazioni.length,
              ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
              height: 70.0,
              child: BlocBuilder<CartBloc, CartState>(
                  builder: (that, statex) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                sprintf(
                                    'Totale: %1.2f €', [statex.a.prezzoTotale]),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            BlocListener<CartBloc, CartState>(
                              listener: (context, state) {
                                Scaffold.of(that).showSnackBar(SnackBar(
                                    content: Text((state.a.prenotazioni.isEmpty)
                                        ? 'Acquisto effettuato con successo!'
                                        : 'Qualcosa è andato storto, non è stato possibile effettuare l\'acquisto')));
                              },
                              child: BlocBuilder<ClientBloc, ClientState>(
                                buildWhen: (previous, next) =>
                                    previous is LoggedState,
                                builder: (contextz, state) => RaisedButton(
                                  onPressed: () {
                                    context.bloc<CartBloc>().add(BuyCart());
                                  },
                                  child: Text('Acquista'),
                                  color: Colors.deepOrange,
                                ),
                              ),
                            )
                          ],
                        ),
                      ))),
        ),
      );
    });
  }
}

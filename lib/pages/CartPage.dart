import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/cartBloc.dart';
import 'package:flutter_app/models/client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrello'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (BuildContext context, state) {
          var bloc = context.bloc<CartBloc>();
          List<DettaglioPrenotazione> prenotazioni = bloc.state.a.prenotazioni;
          return (prenotazioni.isEmpty)
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
                                  bloc.add(SetDettaglio(index, counter));
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
                                  bloc.add(SetDettaglio(index, counter));
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
                  itemCount: prenotazioni.length);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          child: Text('hi'),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/models/client.dart';
import 'package:flutter_app/models/pacchettiVacanza.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'clientBloc.dart';

class CartState {
  Acquisto a;
  bool bougth;

  CartState([this.a, this.bougth = false]);
}

abstract class CartEvent {}

class GetCart extends CartEvent {}

class SaveCart extends CartEvent {}

class BuyCart extends CartEvent {}

class MergeCart extends CartEvent {
  String username;

  MergeCart(this.username);
}

class PutCart extends CartEvent {
  PacchettoVacanza pv;
  int posti;

  PutCart(this.pv, this.posti);
}

class RemoveCart extends CartEvent {
  int index;

  RemoveCart(this.index);
}

class SetDettaglio extends CartEvent {
  int index, posti;

  SetDettaglio(this.index, this.posti);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  final ClientBloc clientBloc;

  CartBloc(this.clientBloc) : super(CartState());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is GetCart) {
      var url = Uri.http('agenziaviaggi.ddns.net', '/cart');
      state.a = Acquisto.fromJson(json.decode((await http.get(url)).body));
      yield CartState(state.a);
    } else if (event is SaveCart) {
      await saveCart();
      yield CartState(state.a);
    } else if (event is BuyCart) {
      var url = Uri.http('agenziaviaggi.ddns.net', 'cart/acquisto');
      Response r = await http.put(
        url,
        body: json.encode(state.a.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      if (r.statusCode >= 400)
        yield CartState(state.a, true);
      else {
        clientBloc.add(AddAcquisto(state.a));
        yield CartState(Acquisto.fromJson(json.decode(r.body)), true);
      }
    } else if (event is PutCart) {
      PacchettoVacanza pv = event.pv;
      bool toAdd = true;
      state.a.prenotazioni.forEach((element) {
        if (element.pacchettoVacanza.pacchetto == pv.pacchetto) {
          toAdd = false;
          element.postiPrenotati += event.posti;
          if (element.postiPrenotati > pv.postiDisp)
            element.postiPrenotati = pv.postiDisp;
          state.a.prezzoTotale += element.postiPrenotati * pv.prezzo;
        }
      });
      if (toAdd) {
        var dettaglioPrenotazione =
            DettaglioPrenotazione(0, state.a.id, event.posti, pv);
        dettaglioPrenotazione.acquisto = state.a.id;
        state.a.prenotazioni.add(dettaglioPrenotazione);
        state.a.prezzoTotale += event.posti * pv.prezzo;
      }
      await saveCart();
      yield CartState(state.a);
    } else if (event is MergeCart) {
      var url = Uri.http(
          'agenziaviaggi.ddns.net', '/cart/${state.a.id}/${event.username}');
      var body2 = (await http.put(url)).body;
      state.a = Acquisto.fromJson(json.decode(body2));
      yield CartState(state.a);
    } else if (event is RemoveCart) {
      Acquisto cart = state.a;
      cart.prezzoTotale -= cart.prenotazioni[event.index].postiPrenotati *
          cart.prenotazioni[event.index].pacchettoVacanza.prezzo;
      cart.prenotazioni.removeAt(event.index);
      await saveCart();
      yield CartState(state.a);
    } else if (event is SetDettaglio) {
      DettaglioPrenotazione dp = state.a.prenotazioni[event.index];
      dp.postiPrenotati = event.posti;
      state.a.prezzoTotale = event.posti * dp.pacchettoVacanza.prezzo;
      saveCart();
      yield CartState(state.a);
    }
  }

  Future<void> saveCart() async {
    var url = Uri.http('agenziaviaggi.ddns.net', '/cart/save');
    await http.put(
      url,
      body: json.encode(state.a),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
  }
}

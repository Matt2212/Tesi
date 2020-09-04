import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/models/client.dart';
import 'package:flutter_app/models/pacchettiVacanza.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class CartState {
  Acquisto a;

  CartState([this.a]);
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
  CartBloc() : super(CartState());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is GetCart) {
      var url = Uri.http('192.168.0.9:8080', '/cart');
      state.a = Acquisto.fromJson(json.decode((await http.get(url)).body));
    } else if (event is SaveCart) {
      await saveCart();
      yield CartState(state.a);
    } else if (event is BuyCart) {
      var url = Uri.http('192.168.0.9:8080', 'cart/acquisto');
      Response r = await http.put(
        url,
        body: state.a.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
      );
      print(r.body);
      yield CartState(Acquisto.fromJson(json.decode(r.body)));
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
      var url =
          Uri.http('192.168.0.9:8080', '/cart/${state.a.id}/${event.username}');
      state.a = Acquisto.fromJson(json.decode((await http.put(url)).body));
      yield CartState(state.a);
    } else if (event is RemoveCart) {
      Acquisto cart = state.a..prenotazioni.removeAt(event.index);
      await saveCart();
      yield CartState(cart);
    } else if (event is SetDettaglio) {
      DettaglioPrenotazione dp = state.a.prenotazioni[event.index];
      dp.postiPrenotati = event.posti;
      state.a.prezzoTotale = event.posti * dp.pacchettoVacanza.prezzo;
      saveCart();
      yield CartState(state.a);
    }
  }

  Future<void> saveCart() async {
    var url = Uri.http('192.168.0.9:8080', '/cart/save');
    await http.put(
      url,
      body: json.encode(state.a),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
    );
  }
}

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_app/models/client.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class CartState {
  Acquisto a;

  CartState([this.a]);
}

abstract class CartEvent {}

class GetCart extends CartEvent {}

class SaveCart extends CartEvent {}

class MergeCart extends CartEvent {}

class BuyCart extends CartEvent {}

class PutCart extends CartEvent {
  DettaglioPrenotazione dp;

  PutCart(this.dp);
}

class RemoveCart extends CartEvent {
  DettaglioPrenotazione dp;

  RemoveCart(this.dp);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is GetCart) {
      var url = Uri.http('192.168.0.9:8080', '/cart');
      Response response = await http.get(url);
      Acquisto a = Acquisto.fromJson(json.decode(response.body));
      yield CartState(a);
    }
    if (event is SaveCart) {
      var url = Uri.http('192.168.0.9:8080', '/save');
      await http.put(
        url,
        body: state.a.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
  }
}

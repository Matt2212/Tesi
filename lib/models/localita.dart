import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Localita {
  String nome, descrizione, url;
  int numeroValutazioni;
  double valutazioneMedia;

  Localita(this.nome, this.descrizione, this.numeroValutazioni,
      this.valutazioneMedia, this.url);

  Localita.fromJson(Map<String, dynamic> json) {
    nome = json['nome'] as String;
    descrizione = json['descrizione'] as String;
    valutazioneMedia = json['valutazioneMedia'] as double;
    numeroValutazioni = json['numeroValutazioni'] as int;
    url = json['url'] as String;
  }

  @override
  String toString() {
    return 'Localita{nome: $nome, descrizione: $descrizione, numeroValutazioni: $numeroValutazioni, valutazioneMedia: $valutazioneMedia}';
  }
}

class CatalogProvider {
  final String url = 'http://192.168.0.9:8080/localita';

  Future<dynamic> localita() async {
    Response r = await http.get(url);
    return compute(parseLocalita, r.body);
  }
}

List<dynamic> parseLocalita(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<dynamic>((json) => Localita.fromJson(json)).toList();
}

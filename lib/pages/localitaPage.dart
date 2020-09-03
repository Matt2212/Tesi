import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/models/localita.dart';
import 'package:flutter_app/models/pacchettiVacanza.dart';
import 'package:flutter_app/models/review.dart';

class LocalitaPage extends StatelessWidget {
  final Localita localita;

  LocalitaPage(this.localita);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
              localita.url,
              width: 150,
              height: 150,
              fit: BoxFit.fill,
            )),
            title: Text(localita.nome),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                child:
                    Text(localita.descrizione, style: TextStyle(fontSize: 16)),
                padding: EdgeInsets.all(10),
              ),
              Padding(
                child: Text(
                  'Pacchetti vacanza disponibili:',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.all(10),
              ),
              PacchettoVacanzaWd(localita.nome),
              RecensioneWD(localita.nome),
            ]),
          )
        ],
      ),
    );
  }
}

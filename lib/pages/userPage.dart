import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/clientBloc.dart';
import 'package:flutter_app/models/client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Cliente c = context.bloc<ClientBloc>().state.c;
    return Scaffold(
      appBar: AppBar(
        title: Text(c.username),
      ),
      body: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nome: ${c.nome}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Cognome: ${c.cognome}',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Email: ${c.email}',
                style: TextStyle(fontSize: 15.0),
              ),
              Text(
                'Recapito: ${c.recapito}',
                style: TextStyle(fontSize: 15.0),
              ),
              Padding(
                padding: EdgeInsets.all(50),
              ),
              Text(
                'Acquisti: ',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Acquisto a = c.acquisti[index];
                    return ExpansionTile(
                      title: Text(
                          'Data di acquisto: ${DateFormat('d/M/yyyy, HH:mm').format(a.data)}'),
                      subtitle: Text('Prezzo totale: '),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                  itemCount: c.acquisti.length)
            ],
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/models/localita.dart';

class CatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () {
            Navigator.of(context).pushNamed('/account');
          },
        ),
        title: Center(child: Text('Catalogo')),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: CatalogProvider().localita(),
          builder: (context, snapshoot) {
            if (snapshoot.connectionState == ConnectionState.done)
              return ListView.builder(
                itemCount: snapshoot.data.length,
                itemBuilder: (context, index) =>
                    LocalitaWidget(snapshoot.data[index]),
              );
            else if (snapshoot.hasError)
              return Text('errore');
            else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ),
    );
  }
}

class LocalitaWidget extends StatelessWidget {
  final _localita;

  LocalitaWidget(this._localita);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_localita.nome),
      onTap: () {
        Navigator.of(context).pushNamed('/localita', arguments: _localita);
      },
    );
  }
}

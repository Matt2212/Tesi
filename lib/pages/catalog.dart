import 'package:flutter/material.dart';
import 'package:flutter_app/models/localita.dart';

class CatalogPage extends StatelessWidget {
  final timeout = CatalogProvider()
      .localita()
      .timeout(Duration(minutes: 1), onTimeout: () => Future.error(Error()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FutureBuilder(
              future: timeout,
              builder: (context, snapshoot) {
                if (snapshoot.connectionState == ConnectionState.done &&
                    !snapshoot.hasError)
                  return IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/cart');
                    },
                  );
                else
                  return Container();
              }),
        ],
        leading: FutureBuilder(
            future: timeout,
            builder: (context, snapshoot) {
              if (snapshoot.connectionState == ConnectionState.done &&
                  !snapshoot.hasError)
                return IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/account');
                  },
                );
              else
                return Container();
            }),
        title: Center(
            child: Text(
          'Catalogo',
          textAlign: TextAlign.end,
        )),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: timeout,
          builder: (context, snapshoot) {
            if (snapshoot.hasError) {
              return Center(
                  child: Text('Non è stato possibile contattare il serever.'));
            } else if (snapshoot.connectionState == ConnectionState.done)
              return ListView.builder(
                itemCount: snapshoot.data.length,
                itemBuilder: (context, index) =>
                    LocalitaWidget(snapshoot.data[index]),
              );
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

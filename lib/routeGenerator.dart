import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/client.dart';
import 'package:flutter_app/pages/catalog.dart';
import 'package:flutter_app/pages/localitaPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/clientBloc.dart';
import 'models/localita.dart';

class RouteGenerator {
  static ClientBloc _clientBloc = ClientBloc();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    //permette di ricevere gli argomenti passati al metodo pushnamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => CatalogWidget());
      case '/localita':
        if (args is Localita) {
          return MaterialPageRoute(builder: (_) => LocalitaPage(args));
        }
        break;
      case '/account':
        return MaterialPageRoute(
            builder: (_) => BlocProvider<ClientBloc>(
                  create: (context) => _clientBloc,
                  child: LoginPage(),
                ));
        //in caso di errore ritorniamo all'homepage
        return MaterialPageRoute(builder: (_) => CatalogWidget());
      default:
        return MaterialPageRoute(builder: (_) => CatalogWidget());
    }
  }
}
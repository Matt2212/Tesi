import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/client.dart';
import 'package:flutter_app/pages/CartPage.dart';
import 'package:flutter_app/pages/catalog.dart';
import 'package:flutter_app/pages/localitaPage.dart';
import 'package:flutter_app/pages/userPage.dart';
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
        return MaterialPageRoute(builder: (_) => CatalogPage());
      case '/localita':
        if (args is Localita) {
          return MaterialPageRoute(builder: (_) => LocalitaPage(args));
        }
        break;
      case '/account':
        return MaterialPageRoute(builder: (context) {
          return context.bloc<ClientBloc>().state is UnLoggedState
              ? LoginPage()
              : UserPage();
        });
      case '/cart':
        return MaterialPageRoute(builder: (_) => CartPage());
      //in caso di errore ritorniamo all'homepage
      default:
        return MaterialPageRoute(builder: (_) => CatalogPage());
    }
  }
}

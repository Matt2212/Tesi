import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/clientBloc.dart';
import 'package:flutter_app/routeGenerator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
    providers: [
      BlocProvider<ClientBloc>(
        create: (_) => ClientBloc(),
      ),
    ],
      child: MaterialApp(
        title: 'Agenzia viaggi',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

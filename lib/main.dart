import 'package:Currency_Conversion/blocs/currency_bloc.dart';
import 'package:Currency_Conversion/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => CurrencyBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Conversion',
      debugShowCheckedModeBanner: false,
      home: const CurrencyScreen(),
    );
  }
}

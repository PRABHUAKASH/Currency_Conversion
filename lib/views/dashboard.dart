import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/currency_bloc.dart';
import '../views/currency_form.dart';
import '../views/history_list.dart';
import '../models/conversion_history.dart';

class CurrencyScreen extends StatelessWidget {
  const CurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const CurrencyForm(), // ⬅️ Form stays at the top
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<CurrencyBloc, CurrencyState>(
                builder: (context, state) {
                  List<ConversionHistory> history = [];

                  if (state is CurrencyConverted) {
                    history = state.historyList;
                  }

                  return HistoryList(history: history);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

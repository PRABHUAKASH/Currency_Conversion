import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/currency_bloc.dart';

class CurrencyForm extends StatefulWidget {
  const CurrencyForm({super.key});

  @override
  State<CurrencyForm> createState() => _CurrencyFormState();
}

class _CurrencyFormState extends State<CurrencyForm> {
  String from = 'USD';
  String to = 'INR';
  double amount = 0.0;
  final currencies = ['USD', 'EUR', 'INR', 'GBP', 'JPY'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: from,
          isExpanded: true,
          items: currencies
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => from = val!),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Amount'),
          keyboardType: TextInputType.number,
          onChanged: (val) => amount = double.tryParse(val) ?? 0,
        ),
        DropdownButton<String>(
          value: to,
          isExpanded: true,
          items: currencies
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) => setState(() => to = val!),
        ),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<CurrencyBloc>(context)
                .add(ConvertCurrency(from: from, to: to, amount: amount));
          },
          child: Text('Convert'),
        ),
        BlocBuilder<CurrencyBloc, CurrencyState>(
          builder: (context, state) {
            if (state is CurrencyLoading) return CircularProgressIndicator();
            if (state is CurrencyConverted) {
              return Text(
                  '${state.history.convertedAmount.toStringAsFixed(2)} ${state.history.to}');
            }
            if (state is CurrencyError)
              return Text(state.message, style: TextStyle(color: Colors.red));
            return Container();
          },
        ),
      ],
    );
  }
}

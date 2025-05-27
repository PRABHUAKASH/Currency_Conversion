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

  final TextEditingController fromAmountController = TextEditingController();
  final TextEditingController toAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButton<String>(
                  value: from,
                  isExpanded: true,
                  items: currencies
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => from = val!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: fromAmountController,
                  decoration: const InputDecoration(
                      labelText: 'Amount', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    amount = double.tryParse(val) ?? 0;
                  },
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              Icon(Icons.swipe_down_alt, color: Colors.blue),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButton<String>(
                  value: to,
                  isExpanded: true,
                  items: currencies
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => to = val!),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: toAmountController,
                  decoration: const InputDecoration(
                      labelText: 'Converted', border: OutlineInputBorder()),
                  enabled: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              amount = 0.0;
              fromAmountController.clear();
              FocusScope.of(context).unfocus();
              BlocProvider.of<CurrencyBloc>(context)
                  .add(ConvertCurrency(from: from, to: to, amount: amount));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Convert',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 20),

          /// Bloc Result
          BlocListener<CurrencyBloc, CurrencyState>(
            listener: (context, state) {
              if (state is CurrencyConverted) {
                setState(() {
                  toAmountController.text =
                      state.history.convertedAmount.toStringAsFixed(2);
                });
              }
            },
            child: BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                if (state is CurrencyLoading)
                  return CircularProgressIndicator();
                if (state is CurrencyError) {
                  return Text(state.message,
                      style: const TextStyle(color: Colors.red));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

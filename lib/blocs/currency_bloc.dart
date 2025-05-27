import 'package:Currency_Conversion/models/conversion_history.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

// Events
abstract class CurrencyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ConvertCurrency extends CurrencyEvent {
  final String from;
  final String to;
  final double amount;

  ConvertCurrency({
    required this.from,
    required this.to,
    required this.amount,
  });

  @override
  List<Object> get props => [from, to, amount];
}

// States
abstract class CurrencyState extends Equatable {
  @override
  List<Object> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyConverted extends CurrencyState {
  final ConversionHistory history;
  final List<ConversionHistory> historyList;

  CurrencyConverted(this.history, this.historyList);

  @override
  List<Object> get props => [history, historyList];
}

class CurrencyError extends CurrencyState {
  final String message;

  CurrencyError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final List<ConversionHistory> _historyList = [];

  CurrencyBloc() : super(CurrencyInitial()) {
    on<ConvertCurrency>(_onConvertCurrency);
  }

  Future<void> _onConvertCurrency(
      ConvertCurrency event, Emitter<CurrencyState> emit) async {
    emit(CurrencyLoading());
    try {
      const accessKey = '683201f3945be71e90154241bb3b99c5';
      final url = Uri.parse(
        'http://data.fixer.io/api/latest?access_key=$accessKey&base=EUR&symbols=${event.from},${event.to}',
      );
      final dio = Dio();
      final response = await dio.get(url.toString());
      final data =
          response.data is String ? json.decode(response.data) : response.data;
      if (data['success'] == true) {
        final fromRate = data['rates'][event.from];
        final toRate = data['rates'][event.to];
        final eurAmount = event.amount / fromRate;
        final converted = eurAmount * toRate;

        final history = ConversionHistory(
          from: event.from,
          to: event.to,
          amount: event.amount,
          convertedAmount: converted,
          date: DateTime.now(),
        );

        _historyList.add(history);

        emit(CurrencyConverted(history, List.from(_historyList)));
      } else {
        emit(CurrencyError('Conversion failed: ${data['error']['info']}'));
      }
    } catch (e) {
      emit(CurrencyError('Something went wrong: $e'));
    }
  }
}

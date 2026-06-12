import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/helpers/currency.helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrencyText extends StatelessWidget {
  final double amount;
  final TextStyle? style;

  const CurrencyText(this.amount, {super.key, this.style});

  String _symbolFor(String? code) {
    switch (code) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'BRL':
        return 'R\$';
      case 'INR':
        return '₹';
      case 'JPY':
        return '¥';
      default:
        return '¤';
    }
  }

  @override
  Widget build(BuildContext context) {
    final code = context.select((AppCubit cubit) => cubit.state.currencyCode);
    final symbol = _symbolFor(code);
    return Text(
      CurrencyHelper.format(amount, symbol: symbol),
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

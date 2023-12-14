import 'package:flutter/services.dart';

class LimitRangeInput extends TextInputFormatter {
  LimitRangeInput(
    this.minRange,
    this.maxRange,
  ) : assert(
          minRange < maxRange,
        );

  final int minRange;
  final int maxRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') {
      return const TextEditingValue(text: '');
    }
    var value = int.tryParse(newValue.text);
    if (value != null) {
      if (value < minRange) {
        return TextEditingValue(text: minRange.toString());
      } else if (value > maxRange) {
        return TextEditingValue(text: maxRange.toString());
      }
    } else {
      return TextEditingValue(text: 0.toString());
    }
    return newValue;
  }
}

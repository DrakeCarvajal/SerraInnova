import 'package:flutter/material.dart';

import 'field_error_text.dart';

class RangeFilter extends StatelessWidget {
  const RangeFilter({
    super.key,
    required this.title,
    required this.values,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.label,
    this.errorText,
  });

  final String title;
  final RangeValues values;
  final double min;
  final double max;
  final int divisions;
  final void Function(RangeValues) onChanged;
  final String Function(RangeValues) label;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
          const SizedBox(height: 10),
          RangeSlider(
            min: min,
            max: max,
            values: values,
            divisions: divisions,
            onChanged: onChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [Text('Min'), Text('Max')],
          ),
          Align(
            alignment: Alignment.center,
            child: Text(label(values),
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          FieldErrorText(errorText),
        ],
      ),
    );
  }
}

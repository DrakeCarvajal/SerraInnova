import 'package:flutter/material.dart';

class CheckboxList<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final bool Function(T) isChecked;
  final String Function(T) labelOf;
  final void Function(T, bool) onChanged;

  const CheckboxList({
    super.key,
    required this.title,
    required this.items,
    required this.isChecked,
    required this.labelOf,
    required this.onChanged,
  });

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
          const SizedBox(height: 8),
          for (final item in items)
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: isChecked(item),
              title: Text(labelOf(item), style: const TextStyle(fontSize: 16)),
              onChanged: (v) => onChanged(item, v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
        ],
      ),
    );
  }
}

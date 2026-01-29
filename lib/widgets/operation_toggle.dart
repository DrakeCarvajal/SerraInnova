import 'package:flutter/material.dart';

import '../models/enums.dart';
import 'app_theme.dart';

class OperationToggle extends StatelessWidget {
  const OperationToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final OperationType value;
  final void Function(OperationType) onChanged;

  @override
  Widget build(BuildContext context) {
    Widget button(OperationType type) {
      final selected = value == type;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(type),
          child: Container(
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.selectedYellow : Colors.white,
              border: Border.all(color: AppColors.borderCyan, width: 2),
            ),
            child: Text(
              type.label,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 260,
      child: Row(
        children: [
          button(OperationType.comprar),
          button(OperationType.alquilar),
        ],
      ),
    );
  }
}

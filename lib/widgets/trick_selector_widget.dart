import 'package:flutter/material.dart';

class TrickSelectorWidget extends StatelessWidget {
  final int value;
  final void Function(int) onChanged;

  const TrickSelectorWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    Widget trickSelectorWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (i) {
        final number = i;
        final selected = number == value;

        return GestureDetector(
          onTap: () => onChanged(number),
          child: Container(
            height: 35,
            width: 35,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              border: Border.all(color: selected ? Colors.blue : Colors.black),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text(
              textAlign: TextAlign.center,
              number.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: selected ? Colors.blue : Colors.black,
              ),
            ),
          ),
        );
      }),
    );

    return trickSelectorWidget;
  }
}
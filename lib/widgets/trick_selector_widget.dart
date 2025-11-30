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
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
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
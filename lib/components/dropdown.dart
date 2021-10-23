import 'package:flutter/material.dart';

// TODO: Fix the warning
class Dropdown extends StatefulWidget {
  Dropdown(
      {Key? key,
        required this.items,
        required this.value,
        required this.onSelect})
      : super(key: key);

  final List<String> items;
  String value;
  final void Function(String) onSelect;

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.value,
      iconSize: 24,
      elevation: 16,
      style: Theme.of(context).textTheme.bodyText2,
      onChanged: (String? newValue) {
        setState(() {
          widget.value = newValue!;
          widget.onSelect(newValue);
        });
      },
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

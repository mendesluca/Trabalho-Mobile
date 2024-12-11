import 'package:flutter/material.dart';

class DigitInputSelector extends StatefulWidget {
  final int maxDigits;
  final void Function(String) onTextChanged;

  const DigitInputSelector(
      {super.key, required this.maxDigits, required this.onTextChanged});

  @override
  _DigitInputSelectorState createState() => _DigitInputSelectorState();
}

class _DigitInputSelectorState extends State<DigitInputSelector> {
  final TextEditingController _controller = TextEditingController();

  void _onTextChanged(String value) {
    if (value.length > widget.maxDigits) {
      _controller.text = value.substring(0, widget.maxDigits);
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
    widget.onTextChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: 'Digite o número',
        hintText: 'Máx ${widget.maxDigits} dígitos',
      ),
      keyboardType: TextInputType.number,
      onChanged: _onTextChanged,
    );
  }
}

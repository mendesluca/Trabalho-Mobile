import 'package:flutter/material.dart';

class PrizeSelector extends StatefulWidget {
  final void Function(List<int>) onSelectionChanged;

  const PrizeSelector({super.key, required this.onSelectionChanged});

  @override
  _PrizeSelectorState createState() => _PrizeSelectorState();
}

class _PrizeSelectorState extends State<PrizeSelector> {
  final List<int> _selectedPrizes = [];

  void _togglePrizeSelection(int prize) {
    setState(() {
      if (_selectedPrizes.contains(prize)) {
        _selectedPrizes.remove(prize);
      } else {
        _selectedPrizes.add(prize);
      }
    });
    widget.onSelectionChanged(_selectedPrizes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prêmio(s)',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0), // Espaço entre o texto e os quadrados
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            final prizeNumber = index + 1;
            final isSelected = _selectedPrizes.contains(prizeNumber);

            return GestureDetector(
              onTap: () => _togglePrizeSelection(prizeNumber),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 179, 179, 179)),
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                              color: Colors.green.withOpacity(0.5),
                              blurRadius: 6)
                        ]
                      : [],
                ),
                width: 50,
                height: 50,
                child: Center(
                  child: Text(
                    '$prizeNumberº',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/animal.dart';

class AnimalGridSelector extends StatefulWidget {
  final void Function(List<Animal>) onSelectionChanged;

  const AnimalGridSelector({super.key, required this.onSelectionChanged});

  @override
  _AnimalGridSelectorState createState() => _AnimalGridSelectorState();
}

class _AnimalGridSelectorState extends State<AnimalGridSelector> {
  final List<Animal> _selectedAnimals = [];

  void _toggleAnimalSelection(Animal animal) {
    setState(() {
      if (_selectedAnimals.contains(animal)) {
        _selectedAnimals.remove(animal);
      } else if (_selectedAnimals.length < 2) {
        _selectedAnimals.add(animal);
      }
    });
    widget.onSelectionChanged(_selectedAnimals);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: animals.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 0.75,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemBuilder: (context, index) {
        final animal = animals[index];
        final isSelected = _selectedAnimals.contains(animal);
        return GestureDetector(
          onTap: () => _toggleAnimalSelection(animal),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(animal.imagePath, height: 40),
                const SizedBox(height: 4),
                Text(
                  '${animal.name}\n(${animal.number})',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

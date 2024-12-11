import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../models/bet_modes.dart';
import '../models/animal.dart';
import '../utils/bet_screen/animal_grid_selector.dart';
import '../utils/bet_screen/digit_input_selector.dart';
import '../utils/bet_screen/prize_selector.dart';

class BetScreen extends StatefulWidget {
  const BetScreen({super.key});

  @override
  _BetScreenState createState() => _BetScreenState();
}

class _BetScreenState extends State<BetScreen> {
  final TextEditingController _betValueController = TextEditingController();
  BetMode? _selectedMode = BetModes.group;
  double _betValue = 0.0;
  String? _errorText;
  List<Animal> _selectedAnimals = [];
  String _inputDigits = "";
  List<int> _selectedPrizes = [];

  double _calculatePrize() {
    if (_selectedMode == null || _betValue <= 0) return 0.0;
    int prizesCount =
        (_selectedMode!.isFullPrizeRequired || _selectedPrizes.isEmpty)
            ? 5
            : _selectedPrizes.length;
    return (_betValue * _selectedMode!.multiplier / prizesCount);
  }

  bool get _isFormValid {
    return _betValue > 0 &&
        _selectedMode != null &&
        (_selectedMode == BetModes.group
            ? _selectedAnimals.length == 2
            : _inputDigits.isNotEmpty) &&
        (_selectedPrizes.isNotEmpty || _selectedMode!.isFullPrizeRequired) &&
        (_errorText == null);
  }

  void _onBetValueChanged(String value) {
    setState(() {
      _betValue = double.tryParse(value) ?? 0.0;
      if (_betValue > Provider.of<Account>(context, listen: false).balance) {
        _errorText = "Saldo insuficiente";
      } else {
        _errorText = null;
      }
    });
  }

  void _onModeChanged(BetMode? mode) {
    setState(() {
      _selectedMode = mode;
      _selectedAnimals.clear();
      _inputDigits = "";
      _selectedPrizes.clear();
    });
  }

  void _generateTicket() {
    final account = Provider.of<Account>(context, listen: false);

    final betNumbers = _selectedMode == BetModes.group
        ? _selectedAnimals
            .map((animal) => '${animal.name} (${animal.number})')
            .join(', ')
        : _inputDigits;

    account.placeBet(
      _betValue,
      _selectedMode!.name,
      betNumbers,
      _selectedPrizes.isEmpty ? [1, 2, 3, 4, 5] : _selectedPrizes,
      _calculatePrize(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sucesso"),
          content: const Text("O ticket foi gerado com sucesso!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text("Voltar ao menu inicial"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aposta'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<Account>(
              builder: (context, account, child) {
                return RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Saldo: ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${account.balance.toStringAsFixed(6)} SOL',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _betValueController,
              decoration: InputDecoration(
                labelText: 'Valor',
                prefixText: 'SOL ',
                errorText: _errorText,
              ),
              keyboardType: TextInputType.number,
              onChanged: _onBetValueChanged,
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<BetMode>(
              value: _selectedMode,
              decoration: const InputDecoration(labelText: 'Modalidade'),
              items: BetModes.allModes.map((mode) {
                return DropdownMenuItem<BetMode>(
                  value: mode,
                  child: Text(mode.name),
                );
              }).toList(),
              onChanged: _onModeChanged,
            ),
            const SizedBox(height: 20.0),
            _selectedMode == BetModes.group
                ? Expanded(
                    child: AnimalGridSelector(
                      onSelectionChanged: (selectedAnimals) {
                        setState(() {
                          _selectedAnimals = selectedAnimals;
                        });
                      },
                    ),
                  )
                : DigitInputSelector(
                    maxDigits: _selectedMode?.maxDigits ?? 0,
                    onTextChanged: (value) {
                      setState(() {
                        _inputDigits = value;
                      });
                    },
                  ),
            const SizedBox(height: 20.0),
            // Prize Selector
            PrizeSelector(
              onSelectionChanged: (selectedPrizes) {
                setState(() {
                  _selectedPrizes = selectedPrizes;
                });
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                const Text(
                  'Premiação:',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(width: 8.0),
                Text(
                  'SOL ${_calculatePrize().toStringAsFixed(4)}',
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: _isFormValid ? _generateTicket : null,
              icon: Icon(
                Icons.monetization_on,
                color: _isFormValid ? Colors.black : Colors.white,
              ),
              label: Text(
                'Gerar Ticket',
                style: TextStyle(
                    color: _isFormValid ? Colors.black : Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormValid ? Colors.green : Colors.grey,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

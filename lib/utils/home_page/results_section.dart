import 'package:flutter/material.dart';

class ResultsSection extends StatelessWidget {
  const ResultsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                SizedBox(width: 8.0),
                Text(
                  'Último Resultado:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            _buildResultCard('Segunda-feira, 04/11/2024'),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: _buildResultsTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTable() {
    return Column(
      children: [
        _buildTableRow('Prêmio', 'Milhar', 'Grupo', 'Bicho', isHeader: true),
        const Divider(color: Colors.white54),
        _buildTableRow('1º Prêmio', '1276', '19', 'Pavão'),
        _buildTableRow('2º Prêmio', '6346', '12', 'Elefante'),
        _buildTableRow('3º Prêmio', '3528', '07', 'Carneiro'),
        _buildTableRow('4º Prêmio', '9367', '17', 'Macaco'),
        _buildTableRow('5º Prêmio', '6730', '08', 'Camelo'),
      ],
    );
  }

  Widget _buildTableRow(String prize, String milhar, String group, String bicho,
      {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTableCell(prize, isHeader),
          _buildTableCell(milhar, isHeader),
          _buildTableCell(group, isHeader),
          _buildTableCell(bicho, isHeader),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, bool isHeader) {
    return Expanded(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isHeader ? Colors.white : Colors.white70,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 16.0 : 14.0,
        ),
      ),
    );
  }
}

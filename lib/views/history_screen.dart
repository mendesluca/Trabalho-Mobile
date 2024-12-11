import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../models/transaction.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _selectedType;
  DateTimeRange? _dateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _dateRange = picked);
      await _filterTransactions();
    }
  }

  Future<void> _filterTransactions() async {
    final account = Provider.of<Account>(context, listen: false);
    await account.loadFilteredTransactions(
      type: _selectedType,
      startDate: _dateRange?.start,
      endDate: _dateRange?.end,
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Account>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico Detalhado'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            tooltip: 'Filtrar',
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Filtro por tipo
            DropdownButton<String>(
              hint: const Text('Selecione o Tipo'),
              value: _selectedType,
              items: const [
                DropdownMenuItem(value: 'ENTRADA', child: Text('Entradas')),
                DropdownMenuItem(value: 'SAÍDA', child: Text('Saídas')),
              ],
              onChanged: (value) {
                setState(() => _selectedType = value);
                _filterTransactions();
              },
            ),
            const SizedBox(height: 16.0),

            Expanded(
              child: account.filteredTransactions.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma transação encontrada',
                        style: TextStyle(fontSize: 16.0, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: account.filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction =
                            account.filteredTransactions[index];
                        return ListTile(
                          leading: Icon(
                            transaction.color == Colors.green
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: transaction.color,
                          ),
                          title: Text(transaction.description),
                          subtitle: Text(
                            '${transaction.type} - ${transaction.amount}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                          onTap: () => _showDetails(context, transaction),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Exibe os detalhes de uma transação
  void _showDetails(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${transaction.type} Detalhes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${transaction.description}'),
            Text('Valor: ${transaction.amount}'),
            Text('Data: ${transaction.date.toLocal()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

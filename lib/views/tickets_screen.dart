import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../models/ticket.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Account>(context);

    // Separação de tickets
    final currentDate = DateTime.now();
    final currentTickets = account.tickets.where(
      (ticket) => ticket.resultDate.isAfter(currentDate),
    ).toList();

    final expiredTickets = account.tickets.where(
      (ticket) => ticket.resultDate.isBefore(currentDate),
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilhetes de Aposta'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apostas Atuais',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            _buildTicketsList(currentTickets, 'Nenhuma aposta atual encontrada.'),
            const SizedBox(height: 20.0),
            const Text(
              'Apostas Vencidas',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            _buildTicketsList(expiredTickets, 'Nenhuma aposta vencida.'),
          ],
        ),
      ),
    );
  }

  // Constrói a lista de bilhetes
  Widget _buildTicketsList(List<Ticket> tickets, String emptyMessage) {
    if (tickets.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 16.0, color: Colors.black54),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(
              ticket.resultDate.isAfter(DateTime.now())
                  ? Icons.pending_actions
                  : Icons.check_circle,
              color: ticket.resultDate.isAfter(DateTime.now())
                  ? Colors.orange
                  : Colors.green,
            ),
            title: Text(
              '${ticket.mode} - ${ticket.numbers}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Valor Apostado: SOL ${ticket.betValue.toStringAsFixed(2)}'),
                Text(
                    'Premiação: SOL ${ticket.prizeAmount.toStringAsFixed(2)}'),
                Text(
                  'Data do Resultado: ${ticket.resultDate.day}/${ticket.resultDate.month}/${ticket.resultDate.year}',
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        );
      },
    );
  }
}

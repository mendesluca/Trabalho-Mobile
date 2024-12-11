import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id; // ID do Firestore
  final double betValue;
  final String mode;
  final String numbers;
  final List<int> prizes;
  final double prizeAmount;
  final DateTime resultDate;

  Ticket({
    required this.id,  // Agora o ID é obrigatório
    required this.betValue,
    required this.mode,
    required this.numbers,
    required this.prizes,
    required this.prizeAmount,
    required this.resultDate,
  });

  // Conversão para Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      'betValue': betValue,
      'mode': mode,
      'numbers': numbers,
      'prizes': prizes,
      'prizeAmount': prizeAmount,
      'resultDate': Timestamp.fromDate(resultDate),
    };
  }

  // Conversão de Map para Objeto
  static Ticket fromMap(String id, Map<String, dynamic> map) {
    return Ticket(
      id: id,  // ID atribuído ao ticket
      betValue: map['betValue'],
      mode: map['mode'],
      numbers: map['numbers'],
      prizes: List<int>.from(map['prizes']),
      prizeAmount: map['prizeAmount'],
      resultDate: (map['resultDate'] as Timestamp).toDate(),
    );
  }
}

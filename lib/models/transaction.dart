import 'package:flutter/material.dart';

class Transaction {
  final String type;      // Tipo de transação: ENTRADA ou SAÍDA
  final String description;  // Descrição da transação
  final String amount;    // Valor formatado da transação
  final Color color;      // Cor associada à transação
  final DateTime date;    // Data da transação

  Transaction({
    required this.type,
    required this.description,
    required this.amount,
    required this.color,
    required this.date,   // Incluído
  });
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import 'transaction.dart';
import 'ticket.dart';

class Account with ChangeNotifier {
  double _balance = 0.0;  
  final List<Transaction> _transactions = [];
  final List<Ticket> _tickets = [];
  List<Transaction> _filteredTransactions = [];

  final FirestoreService _firestoreService = FirestoreService();
  String? _uid = FirebaseAuth.instance.currentUser?.uid;

  // Getters
  double get balance => _balance;
  List<Transaction> get transactions => _transactions;
  List<Ticket> get tickets => _tickets;
  List<Transaction> get filteredTransactions => _filteredTransactions;

  // Sincroniza todos os dados ao logar
  Future<void> syncAccount() async {
    _uid = FirebaseAuth.instance.currentUser?.uid;
    if (_uid == null) return;

    await Future.wait([
      _loadBalance(),
      loadTransactions(),
      loadTickets(),
    ]);

    notifyListeners();
  }

  // Carrega o saldo do Firestore
  Future<void> _loadBalance() async {
    if (_uid == null) return;

    final userData = await _firestoreService.getUser(_uid!);
    if (userData != null && userData['balance'] != null) {
      _balance = (userData['balance'] as num).toDouble(); 
    } else {
      _balance = 0.210000;  
      await _firestoreService.updateUserBalance(_uid!, _balance);
    }
    notifyListeners();  
  }

  // Atualiza o saldo no Firestore
  Future<void> _updateBalance() async {
    if (_uid == null) return;
    await _firestoreService.updateUserBalance(_uid!, _balance);
  }

  // Adiciona uma aposta e atualiza transações
  Future<void> placeBet(double amount, String mode, String numbers, List<int> prizes, double prizeAmount) async {
    if (amount > _balance || _uid == null) return;

    _balance -= amount;  

    final ticket = Ticket(
      id: '',  
      betValue: amount,
      mode: mode,
      numbers: numbers,
      prizes: prizes,
      prizeAmount: prizeAmount,
      resultDate: DateTime.now().add(const Duration(days: 2)),
    );

    await _firestoreService.addTicket(_uid!, ticket);

    await addTransaction(
      type: 'SAÍDA',
      description: 'Aposta realizada: $mode - Números: $numbers',
      amount: -amount,
      color: Colors.red,
    );

    await _updateBalance();  
    _tickets.add(ticket);
    notifyListeners();
  }

  // Adiciona uma transação
  Future<void> addTransaction({
    required String type,
    required String description,
    required double amount,
    required Color color,
  }) async {
    if (_uid == null) return;

    await _firestoreService.addTransaction(_uid!, amount, description);

    _transactions.add(Transaction(
      type: type,
      description: description,
      amount: 'SOL ${amount.toStringAsFixed(6)}',
      color: color,
      date: DateTime.now(),
    ));

    notifyListeners();
  }

  // Carrega transações do Firestore
  Future<void> loadTransactions() async {
    if (_uid == null) return;

    final firestoreTransactions = await _firestoreService.getTransactions(_uid!).first;

    _transactions.clear();
    for (var trans in firestoreTransactions) {
      _transactions.add(Transaction(
        type: trans['amount'] >= 0 ? 'ENTRADA' : 'SAÍDA',
        description: trans['description'],
        amount: 'SOL ${trans['amount'].toStringAsFixed(6)}',
        color: trans['amount'] >= 0 ? Colors.green : Colors.red,
        date: (trans['createdAt'] as firestore.Timestamp).toDate(),
      ));
    }

    notifyListeners();
  }

  // Carrega transações filtradas
  Future<void> loadFilteredTransactions({
    String? type,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_uid == null) return;

    final firestoreTransactions = await _firestoreService.getTransactions(_uid!).first;

    _filteredTransactions = firestoreTransactions
        .map((trans) => Transaction(
              type: trans['amount'] >= 0 ? 'ENTRADA' : 'SAÍDA',
              description: trans['description'],
              amount: 'SOL ${trans['amount'].toStringAsFixed(6)}',
              color: trans['amount'] >= 0 ? Colors.green : Colors.red,
              date: (trans['createdAt'] as firestore.Timestamp).toDate(),
            ))
        .where((trans) {
      final matchesType = type == null || trans.type == type;
      final matchesDate = (startDate == null || trans.date.isAfter(startDate)) &&
          (endDate == null || trans.date.isBefore(endDate));
      return matchesType && matchesDate;
    }).toList();

    notifyListeners();
  }

  // Carrega tickets do Firestore
  Future<void> loadTickets() async {
    if (_uid == null) return;

    final ticketStream = _firestoreService.getTickets(_uid!);
    ticketStream.listen((ticketList) {
      _tickets
        ..clear()
        ..addAll(ticketList);
      notifyListeners();
    });
  }
}

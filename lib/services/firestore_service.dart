import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Cria um novo usuário com saldo inicial
  Future<void> addUser(String uid, String email) async {
    await _db.collection('users').doc(uid).set({
      'email': email,
      'balance': 0.210000,  // Saldo inicial definido
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Lê dados do usuário do Firestore
  Future<Map<String, dynamic>?> getUser(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('users').doc(uid).get();
    return snapshot.data();
  }

  // Atualiza saldo do usuário de forma segura
  Future<void> updateUserBalance(String uid, double balance) async {
    await _db.collection('users').doc(uid).set(
      {
        'balance': balance,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),  // Atualiza sem sobrescrever todos os campos
    );
  }

  // Atualiza email do usuário
  Future<void> updateUserEmail(String uid, String newEmail) async {
    await _db.collection('users').doc(uid).update({
      'email': newEmail,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Gerenciamento de Transações
  Future<void> addTransaction(String uid, double amount, String description) async {
    await _db.collection('users').doc(uid).collection('transactions').add({
      'amount': amount,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteTransaction(String uid, String transactionId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }

  Future<void> updateTransaction(
    String uid,
    String transactionId,
    double amount,
    String description,
  ) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(transactionId)
        .update({
      'amount': amount,
      'description': description,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Lê transações com ordenação por data de criação
  Stream<List<Map<String, dynamic>>> getTransactions(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList());
  }

  // Gerenciamento de Tickets
  Future<void> addTicket(String uid, Ticket ticket) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tickets')
        .add(ticket.toMap());
  }

  Stream<List<Ticket>> getTickets(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('tickets')
        .orderBy('resultDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Ticket.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<void> deleteTicket(String uid, String ticketId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tickets')
        .doc(ticketId)
        .delete();
  }

  Future<void> updateTicket(String uid, String ticketId, Ticket ticket) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tickets')
        .doc(ticketId)
        .update(ticket.toMap());
  }
}

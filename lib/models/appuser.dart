import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AppUser with ChangeNotifier {
  User? _firebaseUser;  // Agora armazena o usuário do Firebase
  final String _walletToken = '123-456-ABC-DEF';  // Mantém o token da carteira como uma constante ou algo que você possa atualizar

  User? get user => _firebaseUser;

  // Dados do Firebase
  String? get name => _firebaseUser?.displayName;
  String? get email => _firebaseUser?.email;
  String? get uid => _firebaseUser?.uid;

  // Token da carteira (walletToken)
  String get walletToken => _walletToken;  // Retorna o walletToken fixo ou você pode alterá-lo dinamicamente

  // Atualiza o usuário com as informações do Firebase
  void setUser(User? firebaseUser) {
    _firebaseUser = firebaseUser;
    notifyListeners();  // Notifica os ouvintes quando o estado mudar
  }

  // Método para verificar se o usuário está autenticado
  bool get isAuthenticated => _firebaseUser != null;

  // Método para deslogar o usuário
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _firebaseUser = null;
    notifyListeners();
  }
}

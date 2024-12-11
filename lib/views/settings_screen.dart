import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _updateName() async {
    setState(() => _isLoading = true);

    try {
      await _auth.currentUser!.updateDisplayName(_nameController.text.trim());
      await _auth.currentUser!.reload();
      setState(() => _errorMessage = 'Nome atualizado com sucesso!');
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateEmail() async {
    setState(() => _isLoading = true);

    try {
      await _auth.currentUser!.updateEmail(_emailController.text.trim());
      await _auth.currentUser!.reload();
      setState(() => _errorMessage = 'E-mail atualizado com sucesso!');
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updatePassword() async {
    setState(() => _isLoading = true);

    try {
      await _auth.currentUser!.updatePassword(_passwordController.text.trim());
      await _auth.currentUser!.reload();
      setState(() => _errorMessage = 'Senha redefinida com sucesso!');
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: _errorMessage!.contains('sucesso')
                        ? Colors.green
                        : Colors.red,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            _buildTextField(
              controller: _nameController,
              label: 'Nome de Exibição',
              icon: Icons.person,
              onSave: _updateName,
            ),
            _buildTextField(
              controller: _emailController,
              label: 'Novo E-mail',
              icon: Icons.email,
              onSave: _updateEmail,
            ),
            _buildTextField(
              controller: _passwordController,
              label: 'Nova Senha',
              icon: Icons.lock,
              obscureText: true,
              onSave: _updatePassword,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Future<void> Function() onSave,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          suffixIcon: _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : IconButton(
                  icon: const Icon(Icons.save, color: Colors.green),
                  onPressed: onSave,
                ),
        ),
      ),
    );
  }
}

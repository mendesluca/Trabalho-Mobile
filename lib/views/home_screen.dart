import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/appuser.dart';
import '../utils/home_page/bet_button.dart';
import '../utils/home_page/user_info.dart';
import '../utils/home_page/results_section.dart';
import '../utils/home_page/balance_section.dart';
import '../utils/home_page/action_buttons_row.dart';
import 'settings_screen.dart';  // Tela de Configurações

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appUser = Provider.of<AppUser>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text(
          'Jogo do Bicho',
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Botão de Configurações
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configurações',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),

          // Botão de Informações do Usuário
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Informações do Usuário',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const UserInfoSection(),
              );
            },
          ),

          // Botão de Logout
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () async {
              await appUser.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 20.0),
            BalanceSection(),  // Exibe o saldo atual
            SizedBox(height: 20.0),
            ActionButtonsRow(),  // Ações de navegação
            SizedBox(height: 20.0),
            BetButton(),  // Botão para apostar
            SizedBox(height: 20.0),
            ResultsSection(),  // Últimos resultados
          ],
        ),
      ),
    );
  }
}

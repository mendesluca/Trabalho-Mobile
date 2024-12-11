import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jogo_do_bicho/views/history_screen.dart';
import 'package:jogo_do_bicho/views/news_screen.dart';
import 'package:jogo_do_bicho/views/tickets_screen.dart';
import 'package:provider/provider.dart';
import 'models/appuser.dart';
import 'models/account.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Inicializa o Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppUser()),
        ChangeNotifierProvider(create: (_) => Account()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
       routes: {
          '/': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/history': (context) => const HistoryScreen(),
          '/tickets': (context) => const TicketsScreen(),
          '/news': (context) => const NewsScreen(),
        }


      ),
    );
  }
}

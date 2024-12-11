// lib/views/news_screen.dart

import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String today = '04/11/2024';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notícias'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNewsCard(
              context,
              title: 'Bitcoin bate recorde histórico',
              date: today,
              content:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed in rutrum lectus. Aliquam eu luctus nibh, eu molestie leo. Donec volutpat nunc vitae odio rhoncus cursus...',
              fullContent:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed in rutrum lectus. Aliquam eu luctus nibh, eu molestie leo. Donec volutpat nunc vitae odio rhoncus cursus. Fusce tempus, libero eget facilisis congue, mauris lacus auctor turpis, a auctor metus justo ut felis.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context,
      {required String title,
      required String date,
      required String content,
      required String fullContent}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            date,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8.0),
          GestureDetector(
            onTap: () {
              _showFullContentDialog(context, title, date, fullContent);
            },
            child: const Text(
              'Ler mais',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullContentDialog(
      BuildContext context, String title, String date, String fullContent) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                fullContent,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}

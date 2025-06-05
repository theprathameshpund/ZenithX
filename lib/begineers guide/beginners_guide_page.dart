// lib/beginners_guide_page.dart
import 'package:flutter/material.dart';
import 'chapter1_page.dart';
import 'chapter2_page.dart';
import 'chapter3_page.dart';
import 'chapter4_page.dart';
import 'chapter5_page.dart';

class BeginnersGuidePage extends StatelessWidget {
  const BeginnersGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beginner\'s Guide'),
      ),
      body: ListView(
        children: [
          _buildChapterTile(context, 'Chapter 1: Understanding the Stock Market', const Chapter1Page()),
          _buildChapterTile(context, 'Chapter 2: Building a Solid Foundation', Chapter2Page()),
          _buildChapterTile(context, 'Chapter 3: Crafting Your Investment Plan', Chapter3Page()),
          _buildChapterTile(context, 'Chapter 4: Stock Market Strategies', Chapter4Page()),
          _buildChapterTile(context, 'Chapter 5: Managing Your Portfolio', Chapter5Page()),
        ],
      ),
    );
  }

  Widget _buildChapterTile(BuildContext context, String title, Widget page) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}

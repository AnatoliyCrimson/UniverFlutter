import 'package:flutter/material.dart';

class InfinityList extends StatelessWidget {
  const InfinityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Бесконечный список')),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Text('Строка $index');
        },
      ),
    );
  }
}

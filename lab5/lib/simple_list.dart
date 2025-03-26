import 'package:flutter/material.dart';

class SimpleList extends StatelessWidget {
  const SimpleList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Простой список')),
      body: ListView.separated(
        itemCount: 3,
        separatorBuilder:
            (context, index) => Divider(
              color: Color.fromARGB(77, 158, 158, 158),
              height: 1,
              thickness: 1,
            ),
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              ['Первая строка', 'Вторая строка', 'Третья строка'][index],
            ),
          );
        },
      ),
    );
  }
}

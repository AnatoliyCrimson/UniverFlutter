import 'package:flutter/material.dart';

void main() => runApp(const AreaCalculatorApp());

class AreaCalculatorApp extends StatelessWidget {
  const AreaCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор площади',
      home: Scaffold(
        appBar: AppBar(title: const Text('Калькулятор площади')),
        body: const MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  double? _width;
  double? _height;
  String _result = '';

  void _calculateArea() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        final area = _width! * _height!;
        _result = 'S = $_width * $_height = $area (мм²)';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Расчёт выполнен успешно'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ширина (мм):', style: TextStyle(fontSize: 16)),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Задайте ширину';
                }
                final number = double.tryParse(value);
                if (number == null) {
                  return 'Введите число';
                }
                return null;
              },
              onSaved: (value) => _width = double.parse(value!),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),

            const Text('Высота (мм):', style: TextStyle(fontSize: 16)),
            TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Задайте высоту';
                }
                final number = double.tryParse(value);
                if (number == null) {
                  return 'Введите число';
                }
                return null;
              },
              onSaved: (value) => _height = double.parse(value!),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: _calculateArea,
                child: const Text('Вычислить'),
              ),
            ),
            const SizedBox(height: 20),

            if (_result.isNotEmpty)
              Center(
                child: Text(_result, style: const TextStyle(fontSize: 18)),
              ),
          ],
        ),
      ),
    );
  }
}

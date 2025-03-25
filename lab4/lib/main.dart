import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'КубГАУ Общежития',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const DormitoryScreen(),
    );
  }
}

class DormitoryScreen extends StatelessWidget {
  const DormitoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Общежития КубГАУ'),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              '../assets/images/kubsau.png',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Общежитие №20',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),
                          Text(
                            'Краснодар, ул. Калинина, 13',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: const [
                          Icon(Icons.favorite, color: Colors.red),
                          SizedBox(width: 8),
                          Text('27', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      ActionButton(icon: Icons.phone, text: 'ПОЗВОНИТЬ'),
                      ActionButton(icon: Icons.directions, text: 'МАРШРУТ'),
                      ActionButton(icon: Icons.share, text: 'ПОДЕЛИТЬСЯ'),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Основной текст
                  const Text(
                    'Студенческий городок или так называемый кампус Кубанского ГАУ состоит из двадцати общежитий, в которых проживает более 8000 студентов, что составляет 96% от всех нуждающихся. Студенты первого курса обеспечены местами в общежитии полностью. В соответствии с Положением о студенческих общежитиях университета, при поселении между администрацией и студентами заключается договор найма жилого помещения. Воспитательная работа в общежитиях направлена на улучшение быта, соблюдение правил внутреннего распорядка, отсутствия асоциальных явлений в молодежной среде. Условия проживания в общежитиях университетского кампуса полностью отвечают санитарным нормам и требованиям: наличие оборудованных кухонь, душевых комнат, прачечных, читальных залов, комнат самоподготовки, помещений для заседаний студенческих советов и наглядной агитации. С целью улучшения условий быта студентов активно работает система студенческого самоуправления - студенческие советы организуют всю работу по самообслуживанию.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String text;

  const ActionButton({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 32),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(color: Colors.green)),
      ],
    );
  }
}

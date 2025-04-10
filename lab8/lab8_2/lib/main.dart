import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CustomHttp extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, __, ___) => true;
  }
}

Future<List<NewsArticle>> getNewsArticles() async {
  final response = await http
      .get(
        Uri.parse(
          'https://kubsau.ru/api/getNews.php?key=6df2f5d38d4e16b5a923a6d4873e2ee295d0ac90',
        ),
      )
      .timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) throw Exception('Ошибка сервера');
  return _parseNews(response.body);
}

List<NewsArticle> _parseNews(String body) {
  final List<dynamic> data = jsonDecode(body);
  return data.map((json) => NewsArticle.fromJson(json)).toList();
}

String _cleanHtml(String html) {
  return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
}

class NewsArticle {
  final String id;
  final DateTime date;
  final String title;
  final String summary;
  final String imageUrl;
  final String url;

  const NewsArticle({
    required this.id,
    required this.date,
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String dateString) {
      try {
        return DateFormat('dd.MM.yyyy HH:mm:ss').parse(dateString);
      } catch (e) {
        try {
          return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateString);
        } catch (_) {
          return DateTime.now().subtract(const Duration(days: 365));
        }
      }
    }

    return NewsArticle(
      id: json['ID'].toString(),
      date: parseDate(json['ACTIVE_FROM']),
      title: _cleanHtml(json['TITLE']),
      summary: _cleanHtml(json['PREVIEW_TEXT']),
      imageUrl: json['PREVIEW_PICTURE_SRC'] ?? '',
      url: json['DETAIL_PAGE_URL'],
    );
  }
}

void main() {
  HttpOverrides.global = CustomHttp();
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ru_RU').then((_) => runApp(const NewsApp()));
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Новости КубГАУ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      home: const NewsFeedPage(),
    );
  }
}

class NewsFeedPage extends StatelessWidget {
  const NewsFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Последние новости'), centerTitle: true),
      body: FutureBuilder<List<NewsArticle>>(
        future: getNewsArticles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.green),
            );
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          }
          return _buildNewsList(snapshot.data!);
        },
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.red),
          const SizedBox(height: 16),
          Text('Ошибка: $error', style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  Widget _buildNewsList(List<NewsArticle> articles) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: articles.length,
      itemBuilder: (context, index) => _NewsCard(article: articles[index]),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsArticle article;

  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green,
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.imageUrl.isNotEmpty) _buildImageWithGradient(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd MMMM yyyy', 'ru_RU').format(article.date),
                      style: TextStyle(
                        color: Colors.green[800],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Divider(color: Colors.grey[300], height: 1),
                const SizedBox(height: 12),
                Text(
                  article.summary,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Chip(
                    label: const Text('Подробнее'),
                    backgroundColor: Colors.green[50],
                    labelStyle: TextStyle(
                      color: Colors.green[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithGradient() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Image.network(
            article.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

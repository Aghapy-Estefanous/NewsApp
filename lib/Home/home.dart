import 'dart:convert';
import 'package:app1/Home/details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/all.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'News App',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: NewPage(),
    );
  }
}

class NewPage extends StatelessWidget {
  Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=e1c13ee19b5d4f38b9dff84c2b491c71'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List articles = jsonResponse['articles'];
      return articles.map((article) => News.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>>(
      future: fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final newsItem = snapshot.data![index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        newsItem: newsItem,
                      ),
                    ),
                  );
                },
                title: Text(
                  newsItem.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // subtitle: Text(newsItem.description ?? 'No description'),
                subtitle: SizedBox(
                  width: 100, // Limit the width of the trailing widget
                  child: Text(
                    newsItem.content != null
                        ? (newsItem.content!.length > 50
                            ? '${newsItem.content!.substring(0, 50)}...'
                            : newsItem.content!)
                        : 'No content',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                leading: newsItem.urlToImage != null ||
                        newsItem.urlToImage!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          newsItem.urlToImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image_not_supported);
                          },
                        ),
                      )
                    : const Icon(Icons.image),
              );
            },
          );
        }
      },
    );
  }
}

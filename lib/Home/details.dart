import 'package:flutter/material.dart';

import '../Models/all.dart';

class DetailsPage extends StatelessWidget {
  final News newsItem;
  const DetailsPage({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Center(
          child: ListView(
            children: [
              Row(
                children: [
                  Container(
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        newsItem.urlToImage!,
                        width: 200,
                        height: 200,
                        // width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    
                    child: Container(
                      margin: EdgeInsets.all(8),
                      child: Column(
                        
                        children: [
                          Text(
                            newsItem.title,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(newsItem.description ?? 'No description'),
                          Text(newsItem.content ?? 'No description'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

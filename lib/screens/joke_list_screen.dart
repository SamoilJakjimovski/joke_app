import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/joke.dart';
import '../services/api_service.dart';

class JokeListScreen extends StatelessWidget {
  final String type;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ApiService apiService = ApiService();

  JokeListScreen({required this.type});

  void addFavorite(BuildContext context, String setup, String punchline) async {
    await firestore.collection('favorites').add({
      'type': type,
      'setup': setup,
      'punchline': punchline,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to Favorites!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$type Jokes'),
      ),
      body: FutureBuilder<List<Joke>>(
        future: apiService.fetchJokesByType(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No jokes available.'));
          } else {
            final jokes = snapshot.data!;
            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                final joke = jokes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(joke.setup),
                    subtitle: Text(joke.punchline),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {
                        addFavorite(context, joke.setup, joke.punchline);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

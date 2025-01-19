import 'package:flutter/material.dart';
import '../models/joke.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesScreen extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Jokes')),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('favorites').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final jokes = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Joke(
                type: data['type'],
                setup: data['setup'],
                punchline: data['punchline'],
              );
            }).toList();

            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(jokes[index].setup),
                  subtitle: Text(jokes[index].punchline),
                );
              },
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'joke_list_screen.dart';
import 'random_joke_screen.dart';
import 'favorites_screen.dart';
import '../widgets/joke_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<String>> jokeTypes;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    jokeTypes = apiService.fetchJokeTypes();
  }

  void addFavorite(String type, String setup, String punchline) async {
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
        title: Text('Joke Types'),
        actions: [
          // Navigate to Random Joke Screen
          IconButton(
            icon: Icon(Icons.casino),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RandomJokeScreen()),
              );
            },
          ),
          // Navigate to Favorites Screen
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: jokeTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final types = snapshot.data!;
            return ListView.builder(
              itemCount: types.length,
              itemBuilder: (context, index) {
                return JokeCard(
                  title: types[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            JokeListScreen(type: types[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/fullscreenWallpaper.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List wallpapers = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  Future<void> fetchApi() async {
    final response = await http.get(
      Uri.parse('https://api.pexels.com/v1/curated?per_page=30'),
      headers: {
        'Authorization':
            '3KJFcSStYn6VyiYsDGhRTz6BSUaSmx6j0Viy5f5hbr1m07PyK5fzPiCK',
      },
    );

    final result = jsonDecode(response.body);

    setState(() {
      wallpapers = result['photos'];
    });
  }

  Future<void> loadMore() async {
    page++;

    final response = await http.get(
      Uri.parse('https://api.pexels.com/v1/curated?per_page=30&page=$page'),
      headers: {
        'Authorization':
            '3KJFcSStYn6VyiYsDGhRTz6BSUaSmx6j0Viy5f5hbr1m07PyK5fzPiCK',
      },
    );

    final result = jsonDecode(response.body);

    setState(() {
      wallpapers.addAll(result['photos']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wallpaper App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 48, 55, 95),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: wallpapers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 2 / 3,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullscreenWallpaper(
                          imageUrl: wallpapers[index]['src']['large2x'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[100], // Background color of the item
                      border: Border.all(
                        // Define the border
                        color: Color.fromARGB(255, 48, 55, 95),
                        width: 3.0,
                      ),
                      // Optional: Add rounded corners
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        wallpapers[index]['src']['tiny'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // FIXED BUTTON
          InkWell(
            onTap: () => loadMore(),
            child: Container(
              color: const Color.fromARGB(255, 48, 55, 95),
              height: 60,
              width: double.infinity,
              child: const Center(
                child: Text(
                  'Load More',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

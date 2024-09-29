import 'package:flutter/material.dart';
import 'package:mathmind/patient/Kids_screens/shapes_reading/shape_page.dart';
import 'Reading_pages/Reading.dart';
import 'Setting/settings_page.dart';
import 'games/games_page.dart';

class KidsHome extends StatefulWidget {
  final String username; // Corrected username parameter

  const KidsHome(
      {super.key, required this.username}); // Ensure 'username' is passed

  @override
  State<KidsHome> createState() => _KidsHomeState();
}

class _KidsHomeState extends State<KidsHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back button
        // Display the user's username
        title:
            Text('Hello ${widget.username}'), // Using 'username' correctly here
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Action for menu
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: [
            buildGridItem(context, Icons.looks_one, 'Numbers', 'números',
                const NumbersPage(), Colors.blue.shade200),
            buildGridItem(context, Icons.book, 'Reading', 'Leer',
                const ReadingPage(), Colors.green.shade300),
            buildGridItem(context, Icons.category, 'Shapes', 'Formas',
                const ShapesPage(), Colors.purple.shade100),
            buildGridItem(context, Icons.settings, 'Settings', 'Ajustes',
                const SettingsPage(), Colors.pink.shade100),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, IconData icon, String title,
      String subtitle, Widget page, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(1, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

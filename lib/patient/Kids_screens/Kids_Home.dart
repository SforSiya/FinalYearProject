import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mathmind/patient/Kids_screens/profile/profile_kid.dart';
import 'package:mathmind/patient/Kids_screens/shapes_reading/shape_page.dart';
import 'Progress_page/progress_screen.dart';
import 'Reading_pages/Reading.dart';
import 'games/games_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// KidsHome screen with BottomNavigationBar
class KidsHome extends StatefulWidget {
  final String username; // Corrected username parameter

  const KidsHome({Key? key, required this.username}) : super(key: key); // Ensure 'username' is passed

  @override
  State<KidsHome> createState() => _KidsHomeState();
}

class _KidsHomeState extends State<KidsHome> {
  int _selectedIndex = 0; // For keeping track of the selected tab

  // List of screens to display
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    // Initialize screens with KidsHome and ProfileScreen
    _screens.add(buildHomeScreen());
    _screens.add(KidsProfilePage());
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildHomeScreen() {
    return SingleChildScrollView( // Makes the whole page scrollable
      child: Padding(
        padding: const EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/kids/raccoon.png'), // Replace with your image
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Good Morning,',
                    style: TextStyle(fontSize: 18, color: Color(0xFFFF9F29)),
                  ),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9F29),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Grid section
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              shrinkWrap: true, // Allows the GridView to take only necessary space
              physics: const NeverScrollableScrollPhysics(), // Prevents inner scrolling within GridView
              children: [
                buildGridItem(
                  context,
                  'assets/kids/games_icon.png',
                  'Numbers',
                  'All about number',
                  const NumbersPage(),
                  const Color(0xFFE1F5E7),
                ),
                buildGridItem(
                  context,
                  'assets/kids/reading_icon.png',
                  'Reading',
                  'Reading some word',
                  const ReadingPage(),
                  const Color(0xFFFFF5E5),
                ),
                buildGridItem(
                  context,
                  'assets/kids/Progress_icon.png',
                  'Progress',
                  'Arranging puzzle',
                  ProgressGraphScreen(userId: 'userId'),
                  const Color(0xFFFFF5F5),
                ),
                buildGridItem(
                  context,
                  'assets/kids/shapes_icon.png',
                  'Shapes',
                  'Coloring a picture',
                  const ShapesPage(),
                  const Color(0xFFEDEAFF),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(BuildContext context, String imagePath, String title, String subtitle, Widget page, Color color) {
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
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 60, height: 60), // Add your icons here
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get the current user ID from FirebaseAuth
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Displays either Home or Profile screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFFFF9F29),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}



/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mathmind/patient/Kids_screens/shapes_reading/shape_page.dart';
import 'Progress_page/progress_screen.dart';
import 'Reading_pages/Reading.dart';
import 'Setting/settings_page.dart';
import 'games/games_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KidsHome extends StatefulWidget {
  final String username; // Corrected username parameter

  const KidsHome({Key? key, required this.username}) : super(key: key); // Ensure 'username' is passed

  @override
  State<KidsHome> createState() => _KidsHomeState();
}

class _KidsHomeState extends State<KidsHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // This removes the back button
        // Display the user's username
        title: Text('Hello ${widget.username}'),
        // Using 'username' correctly here
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
            buildGridItem(
                context, Icons.book, 'Reading', 'Leer', const ReadingPage(),
                Colors.green.shade300),
            buildGridItem(context, Icons.category, 'Progress', 'Formas',
                ProgressGraphScreen(userId: 'userId'), Colors.purple.shade100),
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
              style: const TextStyle(fontSize: 12,
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

  // Function to get the current user ID from FirebaseAuth
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
}*/

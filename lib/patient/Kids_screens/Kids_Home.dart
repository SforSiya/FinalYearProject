import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathmind/patient/Kids_screens/profile/profile_kid.dart';
import 'package:mathmind/patient/Kids_screens/shapes_reading/shape_page.dart';
import 'Progress_page/progress_screen.dart';
import 'Reading_pages/Reading.dart';
import 'games/games_page.dart';

class KidsHome extends StatefulWidget {
  const KidsHome({Key? key}) : super(key: key);

  @override
  State<KidsHome> createState() => _KidsHomeState();
}

class _KidsHomeState extends State<KidsHome> {
  int _selectedIndex = 0; // For keeping track of the selected tab
  String? _username;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _fetchProfileData(); // Fetch profile data on initialization
  }

  // Function to fetch kid's profile from Firestore
  Future<void> _fetchProfileData() async {
    try {
      // Get the currently logged-in user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the user's subcollection for kids
      CollectionReference kidsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('kids');

      // Fetch the document for the kid
      DocumentSnapshot kidDoc = await kidsCollection.doc('kid info').get();

      if (kidDoc.exists) {
        Map<String, dynamic> kidData = kidDoc.data() as Map<String, dynamic>;
        setState(() {
          _username = kidData['name'] ?? 'Guest'; // Set the username or default to "Guest"
          _avatarUrl = kidData['avatar'] ?? 'assets/kids/raccoon.png'; // Set the avatar or default avatar
        });
      } else {
        print("Kid profile not found");
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  // List of screens to display in Bottom Navigation Bar
  List<Widget> _screens() {
    return [
      buildHomeScreen(),
      KidsProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildHomeScreen() {
    return SingleChildScrollView(
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
                    backgroundImage: _avatarUrl != null
                        ? NetworkImage(_avatarUrl!)
                        : const AssetImage('assets/kids/raccoon.png')
                    as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Good Morning,',
                    style: TextStyle(fontSize: 18, color: Color(0xFFFF9F29)),
                  ),
                  Text(
                    _username ?? 'Loading...',
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
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                  'Reading some words',
                  const ReadingPage(),
                  const Color(0xFFFFF5E5),
                ),
                buildGridItem(
                  context,
                  'assets/kids/Progress_icon.png',
                  'Progress',
                  'See your progress',
                  ProgressGraphScreen(userId: 'userId'),
                  const Color(0xFFFFF5F5),
                ),
                buildGridItem(
                  context,
                  'assets/kids/shapes_icon.png',
                  'Shapes',
                  'Learn shapes',
                  ShapesPage(),
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
            Image.asset(imagePath, width: 60, height: 60),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens()[_selectedIndex], // Displays either Home or Profile screen
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

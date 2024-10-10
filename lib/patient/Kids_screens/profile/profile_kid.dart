import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth package

class KidsProfilePage extends StatefulWidget {
  @override
  _KidsProfilePageState createState() => _KidsProfilePageState();
}

class _KidsProfilePageState extends State<KidsProfilePage> {
  bool isEditing = false;

  // Controllers for text fields
  final nameController = TextEditingController();
  final hobbyController = TextEditingController();

  // New field for gender and age
  String selectedGender = 'Male';
  int selectedAge = 5;

  @override
  void initState() {
    super.initState();
    fetchKidsProfile();
  }

  // Function to fetch kid's profile from Firestore
  Future<void> fetchKidsProfile() async {
    try {
      // Get the currently logged-in user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the user's subcollection for kids
      CollectionReference kidsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // Use the logged-in user's ID
          .collection('kids');

      // Fetching the document for the kid
      DocumentSnapshot kidDoc = await kidsCollection.doc('kid info').get();

      if (kidDoc.exists) {
        Map<String, dynamic> kidData = kidDoc.data() as Map<String, dynamic>;
        // Update the controllers and fields with fetched data
        nameController.text = kidData['name'] ?? 'Charlie'; // Default name if not found
        hobbyController.text = kidData['hobby'] ?? 'Playing puzzles'; // Default hobby if not found
        selectedGender = kidData['gender'] ?? 'Male'; // Default gender if not found
        selectedAge = kidData['age'] ?? 5; // Default age if not found
        setState(() {}); // Refresh UI
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
    }
  }

  // Function to save kid's profile to Firestore
  Future<void> saveKidsProfile() async {
    try {
      // Get the currently logged-in user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the user's subcollection for kids
      CollectionReference kidsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId) // Use the logged-in user's ID
          .collection('kids');

      // Data to be stored
      Map<String, dynamic> kidData = {
        'name': nameController.text,
        'age': selectedAge,
        'gender': selectedGender,
        'hobby': hobbyController.text,
      };

      // Storing the kid's data with a unique document ID (or custom ID)
      await kidsCollection.doc('kid info').set(kidData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'ComicSans',
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.04),
            Container(
              width: screenWidth * 0.4,
              height: screenWidth * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.yellow[200]!, width: 5),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/kids_profile.png', // Profile image
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            isEditing
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: TextFormField(
                controller: nameController,
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  fontFamily: 'ComicSans',
                ),
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
            )
                : Text(
              nameController.text,
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
                fontFamily: 'ComicSans',
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              '',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.blue[600],
                fontFamily: 'ComicSans',
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.cake, color: Colors.pink, size: screenWidth * 0.08),
                      title: Text('Age', style: TextStyle(fontSize: screenWidth * 0.045)),
                      trailing: isEditing
                          ? DropdownButton<int>(
                        value: selectedAge,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedAge = newValue!;
                          });
                        },
                        items: List.generate(12, (index) => index + 1)
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                      )
                          : Text('$selectedAge years old'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.green, size: screenWidth * 0.08),
                      title: Text('Gender', style: TextStyle(fontSize: screenWidth * 0.045)),
                      trailing: isEditing
                          ? DropdownButton<String>(
                        value: selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                          : Text(selectedGender),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.sports_esports, color: Colors.orange, size: screenWidth * 0.08),
                      title: isEditing
                          ? TextFormField(
                        controller: hobbyController,
                        decoration: InputDecoration(
                          labelText: 'Hobby',
                          border: OutlineInputBorder(),
                        ),
                      )
                          : Text('Hobby'),
                      trailing: isEditing ? null : Text(hobbyController.text),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.2),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                ),
                onPressed: () {
                  setState(() {
                    if (isEditing) {
                      saveKidsProfile(); // Save data when leaving edit mode
                    }
                    isEditing = !isEditing;
                  });
                },
                icon: Icon(isEditing ? Icons.save : Icons.edit, color: Colors.white, size: screenWidth * 0.07),
                label: Text(
                  isEditing ? 'Save' : 'Edit',
                  style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth package

// Define the KidsProfilePage widget
class KidsProfilePage extends StatefulWidget {
  @override
  _KidsProfilePageState createState() => _KidsProfilePageState();
}

class _KidsProfilePageState extends State<KidsProfilePage> {
  // The rest of your existing code for the KidsProfilePage class
  bool isEditing = false;

  // Controllers for text fields
  final nameController = TextEditingController();
  final hobbyController = TextEditingController();

  // New field for gender and age
  String selectedGender = 'Male';
  int selectedAge = 5;

  // Avatar selection field
  String selectedAvatar = 'assets/kids_profile.png'; // Default avatar path

  @override
  void initState() {
    super.initState();
    fetchKidsProfile();
  }


  // Rest of the code...
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
        selectedAvatar = kidData['avatar'] ?? 'assets/kids/reading_icon.png.png'; // Fetch avatar or use default

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
        'avatar': selectedAvatar, // Include the avatar field here
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


  void _showAvatarSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an Avatar'),
          content: Container(
            width: double.maxFinite,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 avatars per row
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 9, // Number of avatars
              itemBuilder: (BuildContext context, int index) {
                String avatarUrl = 'assets/kids/avatars/avatar_$index.png'; // Avatar image path
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAvatar = avatarUrl; // Update avatar path with the selected one
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Image.asset(avatarUrl), // Display the avatar image
                );
              },
            ),
          ),
        );
      },
    );
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
            Stack(
              children: [
                Container(
                  width: screenWidth * 0.4,
                  height: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.yellow[200]!, width: 5),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      selectedAvatar, // Display selected avatar
                      fit: BoxFit.cover,
                    ),
                  ),

                ),
                if (isEditing) Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, size: 30),
                    onPressed: () {
                      _showAvatarSelectionDialog(context); // Trigger dialog to select new avatar
                    },
                  ),
                ),
              ],
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
                color: Colors.blue[50],
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
              child: ElevatedButton(
                onPressed: () {
                  if (isEditing) {
                    saveKidsProfile();
                  }
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(isEditing ? 'Save' : 'Edit'),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
/*
class PatientsListScreen extends StatelessWidget {
  final String parentEmail;

  PatientsListScreen({required this.parentEmail});

  Stream<QuerySnapshot> getPatientsForParent(String parentEmail) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('parentEmail', isEqualTo: parentEmail)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getPatientsForParent(parentEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No patients found.'));
          }

          final patients = snapshot.data!.docs;

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              final patientName = patient['username']; // Assuming 'username' field exists

              return ListTile(
                title: Text(patientName),
                subtitle: Text(patient['email']), // Assuming 'email' field exists
                onTap: () {
                  // Handle tap, e.g., navigate to patient details page
                },
              );
            },
          );
        },
      ),
    );
  }
}*/

class ParentHomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> childrenData;

  const ParentHomeScreen({super.key, required this.childrenData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Home'),
      ),
      body: ListView.builder(
        itemCount: childrenData.length,
        itemBuilder: (context, index) {
          final child = childrenData[index];
          return ListTile(
            title: Text(child['username'] ?? 'Unknown'),
            subtitle: Text('Email: ${child['email'] ?? 'N/A'}'),
          );
        },
      ),
    );
  }
}

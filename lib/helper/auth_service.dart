import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpParent(String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Save the role as "Guardian" in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'role': 'Guardian',
        });
      }

      return user;
    } catch (e) {
      print('Error signing up parent: $e');
      return null;
    }
  }

  Future<User?> signUpPatient(String username, String email, String password, String parentEmail) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Save the role as "Patient" in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'parentEmail': parentEmail,
          'role': 'Patient',
        });
      }

      return user;
    } catch (e) {
      print('Error signing up patient: $e');
      return null;
    }
  }

  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc['role'] as String?;
    } catch (e) {
      print('Error fetching user role: $e');
      return null;
    }
  }
}
*/
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Parent sign-up
  Future<User?> signUpParent(
      String username, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'role': 'Guardian',
          'children': [], // Initialize with empty list
        });
      }

      return user;
    } catch (e) {
      print('Error signing up parent: $e');
      return null;
    }
  }

  // Child sign-up with reference to parent's email
  Future<User?> signUpPatient(String username, String email, String password,
      String parentEmail) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Save child info in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'email': email,
          'parentEmail': parentEmail,
          'role': 'Patient',
        });

        // Add child's email to the parent's document
        QuerySnapshot parentSnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: parentEmail)
            .limit(1)
            .get();
        if (parentSnapshot.docs.isNotEmpty) {
          String parentId = parentSnapshot.docs.first.id;
          await _firestore.collection('users').doc(parentId).update({
            'children': FieldValue.arrayUnion(
                [email]), // Add child's email to the parent's children list
          });
        }
      }

      return user;
    } catch (e) {
      print('Error signing up patient: $e');
      return null;
    }
  }

  // Fetch parent's children data
  Future<List<Map<String, dynamic>>> fetchParentChildrenData(
      String parentEmail) async {
    try {
      // Get the parent document
      QuerySnapshot parentSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: parentEmail)
          .limit(1)
          .get();

      if (parentSnapshot.docs.isNotEmpty) {
        DocumentSnapshot parentDoc = parentSnapshot.docs.first;
        List<String> childrenEmails =
            List<String>.from(parentDoc['children'] ?? []);

        // Fetch data of all children linked to the parent
        List<Map<String, dynamic>> childrenData = [];
        for (String childEmail in childrenEmails) {
          QuerySnapshot childSnapshot = await _firestore
              .collection('users')
              .where('email', isEqualTo: childEmail)
              .limit(1)
              .get();
          if (childSnapshot.docs.isNotEmpty) {
            childrenData
                .add(childSnapshot.docs.first.data() as Map<String, dynamic>);
          }
        }

        return childrenData;
      }

      return [];
    } catch (e) {
      print('Error fetching children data: $e');
      return [];
    }
  }
}

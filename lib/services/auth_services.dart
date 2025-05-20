import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (authResult.user != null &&
          authResult.user!.email != null &&
          authResult.user!.email!.endsWith("@cmscollege.ac.in")) {
        // Check if the user document exists in the "users" collection
        final userDoc = await _database
            .ref()
            .child('users')
            .child(authResult.user!.uid)
            .once();

        if (userDoc.snapshot.value == null) {
          // If the user document doesn't exist, create it
          await addUserToDatabase(
              authResult.user!.uid, authResult.user!.email!);
        }

        return authResult.user;
      } else {
        await FirebaseAuth.instance.signOut();
        return null;
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = authResult.user;
      return user;
    } catch (error) {
      print('Error signing in: $error');
      return null;
    }
  }

  String? getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null ? user.email : null;
  }

  // Add a new user to the database
  Future<void> addUserToDatabase(String userId, String email) async {
    try {
      await _database.ref().child('users').child(userId).set({
        'email': email,
        // Add other user-related data if needed
      });
    } catch (error) {
      print('Error adding user to database: $error');
    }
  }

  // Send a message to the database
  Future<void> sendMessageToDatabase(String userId, String message) async {
    try {
      await _database.ref().child('messages').push().set({
        'userId': userId,
        'message': message,
        'timestamp': ServerValue.timestamp,
      });
    } catch (error) {
      print('Error sending message: $error');
    }
  }
}

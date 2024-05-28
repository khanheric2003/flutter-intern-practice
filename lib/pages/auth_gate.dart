import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  Future<void> createUserDocument(User? user) async {
    if (user != null) {
      final usersCollection = FirebaseFirestore.instance.collection('userList');
      final docRef = usersCollection.doc(user.uid);

      // Check if doc exists, if not create it
      var doc = await docRef.get();
      if (!doc.exists) {
        await docRef.set({
          // Your fields here
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            key: const Key("login_key"),
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                  clientId:
                      "1029381441351-in8nhr22phdqrmgdq3pl9tutuui618gp.apps.googleusercontent.com"),
            ],
            headerBuilder: (context, constraints, shrinkOffset) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Icon(
                    Icons.calendar_month_outlined,
                    size: 80,
                  ),
                ),
              );
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: action == AuthAction.signIn
                    ? const Text('Welcome to Uremind, please sign in!')
                    : const Text('Welcome to Uremind, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/lutterfire_300x.png'),
                ),
              );
            },
          );
        }

        return const HomeScreen();
      },
    );
  }
}

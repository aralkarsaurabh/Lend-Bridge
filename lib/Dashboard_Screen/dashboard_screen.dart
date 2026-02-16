import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = false;
  User? user;
  Map<String, dynamic>? data;

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  Future<void> getUserDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      setState(() {
        user = currentUser;
      });

      if (currentUser != null) {
        DocumentSnapshot? snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (snapshot.exists) {
          data = snapshot.data() as Map<String, dynamic>;
        }
      }

      setState(() {
        user = currentUser;
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Dashboard'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.black)
            : Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    SizedBox(
                      height: 100,
                      width: double.infinity,

                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),

                        color: Colors.white,
                        shadowColor: Colors.black26,
                        elevation: 4,

                        child: Text('UID: ${user!.uid}'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

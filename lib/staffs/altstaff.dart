import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:serenadepalace/screens/welcome_screen.dart';

class AltstaffHomePage extends StatefulWidget {
  const AltstaffHomePage({super.key});

  @override
  _AltstaffHomePageState createState() => _AltstaffHomePageState();
}

class _AltstaffHomePageState extends State<AltstaffHomePage> {
  String? userName;
  String? job;
  String? workingHours;
  String? profileImageBase64;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStaffDetails();
  }

  Future<void> _loadStaffDetails() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('error.')),
        );
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('Staff')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('error: $userId');
      }

      final data = userDoc.data();
      if (data == null) {
        throw Exception('error.');
      }

      setState(() {
        userName = data['userName'] ?? 'Bilinmiyor';
        job = data['job'] ?? 'Bilinmiyor';
        profileImageBase64 = data['profileImageBase64'];
        workingHours = data['workingHours'] ?? '08:00 - 18:00';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: const Text(
            'Serenade Palace',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white, size: 40),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(255, 143, 115, 94),
                      title: const Text(
                        "Log out",
                        style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      content: const Text(
                        "Are you sure you want to log out?",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => const WelcomeScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Log out",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/wl.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Positioned(
                top: 150.0,
                left: 20.0,
                right: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (profileImageBase64 != null && profileImageBase64!.isNotEmpty)
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: MemoryImage(base64Decode(profileImageBase64!)),
                      )
                    else
                      const CircleAvatar(
                        radius: 70,
                        child: Icon(Icons.person, size: 70),
                      ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Hello! $userName',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Positioned(
              top: 400.0,
              left: 20.0,
              right: 20.0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 143, 115, 94).withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: const Text(
                  'Welcome to Serenade Palace Hotel! We are delighted to have you as part of our team. Click the "Request" button to see your tasks and get started. Together, we make every guest\'s stay unforgettable!',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.1,
              maxChildSize: 0.2,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (e) => const HousekeepingTaskPage(),
                                    ),
                                  );*/
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.message,
                                      size: 50,
                                      color: Color.fromARGB(255, 143, 115, 94),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'See the requests',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 143, 115, 94),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
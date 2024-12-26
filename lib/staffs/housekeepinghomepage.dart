import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:serenadepalace/screens/editprofile.dart';
import 'package:serenadepalace/screens/welcome_screen.dart';

class HouseKeepingHomePage extends StatefulWidget {
  const HouseKeepingHomePage({super.key});

  @override
  _HouseKeepingHomePageState createState() => _HouseKeepingHomePageState();
}

class _HouseKeepingHomePageState extends State<HouseKeepingHomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<void> completeHousekeeping(String userId) async {
    try {
      await _firestore.collection('Person').doc(userId).update({'housekeeping': false});
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Housekeeping completed.')),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred.')),
      );
    }
  }

  void showCompletionDialog(String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Is the housekeeping completed?',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 163, 140, 122),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                completeHousekeeping(userId);
              },
              child: const Text('Yes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
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
              icon: const Icon(Icons.exit_to_app_sharp, color: Colors.white, size: 30),
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
          drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 143, 115, 94),
                ),
                child: Text(
                  'View and Set',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Set Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 143, 115, 94),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const EditProfilePage(),
                                ),
                              );
                },
              ),
            ],
          ),
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
                top: 100.0,
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
              top: 300.0,
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
                  'Welcome to Serenade Palace Hotel! We are delighted to have you as part of our team. Here you can see "Requests" and get started. Together, we make every guest\'s stay unforgettable!',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.66,
              minChildSize: 0.45,
              maxChildSize: 0.7, // Increased max size for better display
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
                      const SizedBox(height: 20),
                      const Text(
                        'Housekeeping Request',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 143, 115, 94),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Person')
                                .where('housekeeping', isEqualTo: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }

                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No guests with housekeeping requests.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 143, 115, 94),
                                    ),
                                  ),
                                );
                              }

                              final guests = snapshot.data!.docs;

                              return Column(
                                children: guests.map((doc) {
                                  final data = doc.data() as Map<String, dynamic>;
                                  final userName = data['userName'] ?? 'Unknown';
                                  final roomNumber = data['roomNumber'] ?? 'Unknown';
                                  final housekeepingTime = (data['housekeepingTime'] as Timestamp?)?.toDate() ?? DateTime.now();
                                  final userId = doc.id;

                                  final localTime = housekeepingTime.toLocal();
                                  final correctedTime = localTime.add(Duration(hours: 3));

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: GestureDetector(
                                      onTap: () => showCompletionDialog(userId),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        padding: const EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 163, 140, 122),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '$userName requested housekeeping service',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Room No: $roomNumber',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '${correctedTime.hour}:${correctedTime.minute < 10 ? '0' : ''}${correctedTime.minute}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
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

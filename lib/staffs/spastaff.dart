import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:serenadepalace/screens/welcome_screen.dart';
class SpastaffHomePage extends StatefulWidget {
  const SpastaffHomePage({super.key});

  @override
  _SpastaffHomePageState createState() => _SpastaffHomePageState();
}

class _SpastaffHomePageState extends State<SpastaffHomePage> {
  String? userName;
  String? job;
  String? workingHours;
  String? profileImageBase64;

  bool _isLoading = true;
  List<QueryDocumentSnapshot> _reservations = [];

  @override
  void initState() {
    super.initState();
    _loadStaffDetails();
    _loadReservations();
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




Future<void> _loadReservations() async {
  try {
    final today = DateTime.now();
    final formattedToday = DateFormat('yyyy-MM-dd').format(today);  // Bugün tarihini doğru formatta alıyoruz

    // Firestore'dan sadece bugünün tarihine ait rezervasyonları alıyoruz
    final querySnapshot = await FirebaseFirestore.instance
        .collection('SpaReservations')
        .where('date', isEqualTo: formattedToday) // 'date' bugüne eşit olanları al
        .get();

    setState(() {
      _reservations = querySnapshot.docs;  // Gelen rezervasyonları listeye alıyoruz
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error loading reservations: $e')),
    );
  }
}






  Future<void> _markAsFinished(String reservationId) async {
    try {
      final reservationRef = FirebaseFirestore.instance.collection('SpaReservations').doc(reservationId);
      await reservationRef.update({'finished': true});
      _loadReservations();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error: $e')),
      );
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
                  'Welcome to Serenade Palace Hotel! We are delighted to have you as part of our team. Scroll the screen, show the rezervations and get started. Together, we make every guest\'s stay unforgettable!',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.1,
              maxChildSize: 0.7,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        // Title for the Reservations section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Reservations",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown[700],
                            ),
                          ),
                        ),
                        // List of reservations
                        ..._reservations.map((reservation) {
                          final reservationData = reservation.data() as Map<String, dynamic>;
                          final finished = reservationData['finished'] ?? false;
                          final reservationId = reservation.id;
                          final time = reservationData['time'];
                          final userName = reservationData['userName'];
                          
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                if (!finished) {
                                  _markAsFinished(reservationId);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: finished ? Colors.green : Colors.brown,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.person, size: 30, color: Colors.white),
                                      const SizedBox(width: 10),
                                      Text(
                                        userName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    time,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
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

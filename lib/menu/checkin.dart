/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({Key? key}) : super(key: key);

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  String? userName;
  int? roomNumber;
  DateTime? startDate;
  DateTime? endDate;
  double? cost;
  bool confirmed = false; // Onay durumu
  bool isLoading = false; // Yüklenme durumu

  @override
  void initState() {
    super.initState();
    _loadReservationData();
  }

  Future<void> _loadReservationData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        isLoading = true;
      });

      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Person')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['userName'] ?? 'Unknown';
            roomNumber = userDoc['roomNumber'] ?? 0;
            startDate = (userDoc['startDate'] as Timestamp?)?.toDate();
            endDate = (userDoc['endDate'] as Timestamp?)?.toDate();
            cost = (userDoc['cost'] as num?)?.toDouble() ?? 0.0;
            confirmed = userDoc['confirmed'] ?? false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No reservation found')),
          );
        }
      } catch (e) {
        print('Error fetching reservation data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _confirmReservation() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && startDate != null) {
      try {
        await FirebaseFirestore.instance
            .collection('Person')
            .doc(currentUser.uid)
            .update({'confirmed': true});

        setState(() {
          confirmed = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reservation confirmed!')),
        );
      } catch (e) {
        print('Error confirming reservation: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _checkOut() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && endDate != null) {
      try {
        DateTime today = DateTime.now();

        await FirebaseFirestore.instance
            .collection('Person')
            .doc(currentUser.uid)
            .update({
          'endDate': today,
          'confirmed': false, // Check-out sonrası onay kaldırılır
        });

        setState(() {
          endDate = today;
          confirmed = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checked out successfully!')),
        );
      } catch (e) {
        print('Error during check-out: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool canConfirm = startDate != null &&
        DateTime.now().difference(startDate!).inDays == -1;

    return CustomScaffold(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (roomNumber != null) ...[
                            Text(
                              'Room Number: $roomNumber',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            if (startDate != null && endDate != null) ...[
                              Text(
                                'Check-in Date: ${DateFormat('yyyy-MM-dd').format(startDate!)} at 12:00 PM',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Check-out Date: ${DateFormat('yyyy-MM-dd').format(endDate!)} at 12:00 PM',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                            const SizedBox(height: 20),
                            if (cost != null) ...[
                              Text(
                                'Total Cost: \$${cost!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 143, 115, 94),
                                ),
                              ),
                            ],
                          ],
                          const SizedBox(height: 40),
                          Text(
                            'Please confirm your arrival a day before the check-in date.',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: canConfirm && !confirmed
                                ? _confirmReservation
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Confirm Arrival'),
                          ),
                          const SizedBox(height: 20),
                          if (confirmed)
                            ElevatedButton(
                              onPressed: _checkOut,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Check Out'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:serenadepalace/home2.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckScreen extends StatefulWidget {
  const CheckScreen({Key? key}) : super(key: key);

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  String? userName;
  int? roomNumber;
  DateTime? startDate;
  DateTime? endDate;
  double? cost;
  bool confirmed = false;
  bool isCheckedOut = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReservationData();
  }

  Future<void> _loadReservationData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
            .collection('Person')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic>? data = userDoc.data();

          final today = DateTime.now();
          final todayDate = DateTime(today.year, today.month, today.day);
          final fetchedEndDate = (data?['endDate'] as Timestamp?)?.toDate();
          final isEndToday = fetchedEndDate != null &&
              DateTime(fetchedEndDate.year, fetchedEndDate.month, fetchedEndDate.day) ==
                  todayDate;

          if (isEndToday && !(data?['isCheckedOut'] ?? false)) {
            // End date bugüne eşitse ve isCheckedOut hala false ise otomatik check-out yap
            await FirebaseFirestore.instance
                .collection('Person')
                .doc(currentUser.uid)
                .update({'isCheckedOut': true});
          }

          setState(() {
            userName = data?['userName'];
            roomNumber = data?['roomNumber'];
            startDate = (data?['startDate'] as Timestamp?)?.toDate();
            endDate = fetchedEndDate;
            cost = (data?['cost'] as num?)?.toDouble();
            confirmed = data?['confirmed'] ?? false;
            isCheckedOut = data?['isCheckedOut'] ?? false || isEndToday;
          });
        }
      } catch (e) {
        print('Error fetching reservation data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching reservation data')),
        );
      }
    }
  }

  Future<void> _confirmReservation() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('Person')
            .doc(currentUser.uid)
            .update({'confirmed': true});

        setState(() {
          confirmed = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check in succes')),
        );
      } catch (e) {
        print('Error confirming reservation: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error confirming reservation.')),
        );
      }
    }
  }

  Future<void> _checkOut() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final today = DateTime.now();

        await FirebaseFirestore.instance.collection('Person').doc(currentUser.uid).update({
          
          'endDate': today,
        });

        setState(() {
          isCheckedOut = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check out succes.')),
        );
      } catch (e) {
        print('Error during checkout: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error during checkout.')),
        );
      }
    }
  }

  bool _isCheckInButtonEnabled() {
    if (startDate != null && !confirmed && !isCheckedOut) {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final startDateOnly = DateTime(startDate!.year, startDate!.month, startDate!.day);

      // Eğer startDate bir gün önce ise, Check In butonu aktif olacak
      return startDateOnly.difference(todayDate).inDays == 1;
    }
    return false;
  }

  bool _isCheckOutButtonEnabled() {
    if (confirmed && !isCheckedOut) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (roomNumber != null) ...[
                      Text(
                        'Room Number: $roomNumber',
                        style: const TextStyle(fontSize: 16, color: Color.fromARGB(255, 143, 115, 94),fontWeight: FontWeight.w900,),
                      ),
                      const SizedBox(height: 20),
                      if (startDate != null && endDate != null) ...[
                        Text(
                          'Check-in Date: ${DateFormat('yyyy-MM-dd').format(startDate!)} at 12:00 PM',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Check-out Date: ${DateFormat('yyyy-MM-dd').format(endDate!)} at 12:00 PM',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                      const SizedBox(height: 20),
                      if (cost != null) ...[
                        Text(
                          'Total Cost: \$${cost!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 143, 115, 94),
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 40),
                    // Onay mesajı sadece confirmed false ise görünecek
                    if (!confirmed)
                      const Text(
                        'You need to confirm your reservation one day before your start date.',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          
                          color: Color.fromARGB(255, 143, 115, 94),
                          fontStyle: FontStyle.italic
                        ),
                      ),
                      if (isCheckedOut==true)
                      const Text(
                        'It hard to see you go.',
                         style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          
                          color: Color.fromARGB(255, 143, 115, 94),
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    const SizedBox(height: 40),
                    
                   Column(
  children: [
    SizedBox(
      width: double.infinity, // Ekran genişliği kadar uzatmak için
      child: ElevatedButton(
        onPressed: _isCheckInButtonEnabled() && !isLoading
      ? () async {
          setState(() {
            isLoading = true; // Yükleme başladığında
          });
          
          await _confirmReservation(); // Rezervasyon işlemi (asenkron)
          
          // Yükleme bittikten sonra, yönlendirme yapılacak
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage2()),
              );
            });
          }
          
          setState(() {
            isLoading = false; // Yükleme bitince
          });
        }
      : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            _isCheckInButtonEnabled()
                ? const Color.fromARGB(255, 143, 115, 94)
                : Colors.grey,
          ),
        ),
        child: const Text(
          'Check In',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
    const SizedBox(height: 20),
    SizedBox(
      width: double.infinity, // Ekran genişliği kadar uzatmak için
      child: ElevatedButton(
        onPressed: _isCheckOutButtonEnabled() ? _checkOut : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            _isCheckOutButtonEnabled()
                ? const Color.fromARGB(255, 143, 115, 94)
                : Colors.grey,
          ),
        ),
        child: const Text(
          'Check Out',
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),
  ],
),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


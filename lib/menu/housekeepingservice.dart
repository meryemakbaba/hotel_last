import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class HousekeepingServicePage extends StatefulWidget {
  const HousekeepingServicePage({Key? key}) : super(key: key);

  @override
  State<HousekeepingServicePage> createState() =>
      _HousekeepingServicePageState();
}

class _HousekeepingServicePageState extends State<HousekeepingServicePage> {
  bool isHousekeepingRequested = false;
  DateTime? housekeepingTime;

  @override
  void initState() {
    super.initState();
    _checkHousekeepingStatus();
  }

  Future<void> _checkHousekeepingStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        final userDoc = await FirebaseFirestore.instance
            .collection('Person')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          final housekeepingStatus = userDoc.data()?['housekeeping'] ?? false;
          final housekeepingTimeStamp = userDoc.data()?['housekeepingTime'];

          // Eğer housekeeping true ise ve time mevcutsa, durumu güncelle
          if (housekeepingStatus && housekeepingTimeStamp != null) {
            DateTime fetchedTime = (housekeepingTimeStamp as Timestamp).toDate();
            DateTime threeHoursAgo = DateTime.now().subtract(Duration(hours: 3));

            // Eğer housekeepingTime, 3 saatten daha eski değilse, güncelle
            if (fetchedTime.isAfter(threeHoursAgo)) {
              setState(() {
                isHousekeepingRequested = true;
                housekeepingTime = fetchedTime;
              });
              print('Housekeeping requested at: $housekeepingTime');
            } else {
              // Eğer housekeepingTime 3 saatten eski ise, gösterme
              setState(() {
                housekeepingTime = null;
              });
            }
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> requestHousekeeping() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        final currentTime = Timestamp.now();  // Firestore timestamp

        await FirebaseFirestore.instance
            .collection('Person')
            .doc(userId)
            .update({
          'housekeeping': true,
          'housekeepingTime': currentTime, // Time'ı güncelle
        });

        setState(() {
          isHousekeepingRequested = true;
          housekeepingTime = currentTime.toDate();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Your request was confirmed.")),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text("Error: $e"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Okey"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
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
                  children: [
                    if (isHousekeepingRequested) 
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Waiting for Housekeeping Services...",
                            style: TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          GestureDetector(
                            onTap: requestHousekeeping,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.water_damage_outlined,
                                  size: 100,
                                  color: Color.fromARGB(255, 143, 115, 94),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Click for Housekeeping Service",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 143, 115, 94),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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

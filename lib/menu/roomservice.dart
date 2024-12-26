import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class RoomServicePage extends StatefulWidget {
  const RoomServicePage({Key? key}) : super(key: key);

  @override
  State<RoomServicePage> createState() => _RoomServicePageState();
}

class _RoomServicePageState extends State<RoomServicePage> {
  final List<String> roomServiceOptions = [
    "Breakfast",
    "Launch",
    "Dinner",
    "Snack",
    "Mini Bar Refill",
    "Extra Towel",
    "Extra Pillow",
    "Special Request",
  ];
  final Set<String> selectedServices = {};
  bool isLoading = false;
  bool isRoomServiceActive = false;

  @override
  void initState() {
    super.initState();
    _checkRoomServiceStatus();
  }

  // Kullanıcının roomService durumu kontrol ediliyor
  Future<void> _checkRoomServiceStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        final userDoc = await FirebaseFirestore.instance
            .collection('Person')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          final roomServiceStatus = userDoc.data()?['roomservice'] ?? false;

          setState(() {
            isRoomServiceActive = roomServiceStatus;
            // Eğer roomService aktifse, mevcut hizmetler çekilir
            if (isRoomServiceActive) {
              selectedServices.addAll(List<String>.from(userDoc.data()?['services'] ?? []));
            }
          });
        }
      }
    } catch (e) {
      print("Error checking room service status: $e");
    }
  }

  // Odanın servis talebini gönderme fonksiyonu
  Future<void> submitRoomServiceRequest() async {
    if (selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one service!")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        // Firestore'da yeni servisleri mevcut listeye ekle
        final userDoc = await FirebaseFirestore.instance
            .collection('Person')
            .doc(userId)
            .get();

        if (userDoc.exists && userDoc.data()?['services'] != null) {
        }

        final updatedServices = [ ...selectedServices];

        await FirebaseFirestore.instance.collection('Person').doc(userId).update({
          'roomservice': true,
          'services': updatedServices, // Güncellenmiş hizmetler
          'roomserviceTime': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Room service request submitted successfully!")),
        );

        setState(() {
          isRoomServiceActive = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> updateRoomServiceRequests() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        await FirebaseFirestore.instance.collection('Person').doc(userId).update({
          'roomservice': false,
          'services': [], // Servisleri sıfırla
        });

        setState(() {
          isRoomServiceActive = false;
          selectedServices.clear(); // Seçilen hizmetleri sıfırla
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Room service requests reset successfully!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
  // Room service sıfırlama fonksiyonu
  Future<void> resetRoomServiceRequests() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        await FirebaseFirestore.instance.collection('Person').doc(userId).update({
          'roomservice': false,
          'services': [], // Servisleri sıfırla
        });

        setState(() {
          isRoomServiceActive = false;
          selectedServices.clear(); // Seçilen hizmetleri sıfırla
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Room service requests reset successfully!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // Kullanıcının seçtiği servislerin görüntülenmesi
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Select Room Services",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 143, 115, 94),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 143, 115, 94),
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 143, 115, 94),
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: roomServiceOptions.map((service) {
                          return CheckboxListTile(
                            activeColor: Color.fromARGB(255, 77, 37, 0),
                            title: Text(
                              service,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            value: selectedServices.contains(service),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedServices.add(service);
                                } else {
                                  selectedServices.remove(service);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isRoomServiceActive)
                      Column(
                        children: const [
                          SizedBox(height: 20),
                          Text(
                            "Last request is being processed...",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 143, 115, 94),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Center(
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 143, 115, 94),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: isRoomServiceActive
                                  ? submitRoomServiceRequest
                                  
                                  : submitRoomServiceRequest,
                              child: Text(
                                isRoomServiceActive ? "Update Requests" : "Submit Request",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class RoomserviceTaskPage extends StatefulWidget {
  const RoomserviceTaskPage({Key? key}) : super(key: key);

  @override
  State<RoomserviceTaskPage> createState() => _RoomserviceTaskPageState();
}

class _RoomserviceTaskPageState extends State<RoomserviceTaskPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Servis tamamlandığında roomservice'i false yapıp, services dizisini sıfırlıyoruz
  Future<void> completeRoomservice(String userId) async {
    try {
      await _firestore.collection('Person').doc(userId).update({
        'roomservice': false, // Servisin tamamlandığını işaret ediyoruz
        'services': [] // Servisleri sıfırlıyoruz
      });

      // State'i güncelliyoruz
      setState(() {});

      // Başarı mesajı
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Roomservice completed.'),
        ),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred.'),
        ),
      );
    }
  }

  // Tamamlanma diyalogunu gösteriyoruz
  void showCompletionDialog(String userId, List<dynamic> services) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Is the roomservice completed?',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color.fromARGB(255, 163, 140, 122), // Dialogun arka plan rengini ayarlıyoruz
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Requested Services:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Servis listesindeki her öğeyi ekrana yazdırıyoruz
              ...services.map((service) {
                return Text(
                  service,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                );
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'No',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                completeRoomservice(userId); // Servisi tamamlamak için çağırıyoruz
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Person')
                      .where('roomservice', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No guests with roomservice requests.',
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
                        final roomserviceTime = (data['roomserviceTime'] as Timestamp?)?.toDate() ?? DateTime.now();
                        final userId = doc.id;
                        final services = List<String>.from(data['services'] ?? []); // Firestore'dan servis listesi alınıyor

                        // Zamanı yerel saat dilimine düzeltmek için 3 saat ekliyoruz
                        final localTime = roomserviceTime.toLocal();
                        final correctedTime = localTime.add(Duration(hours: 3));

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: GestureDetector(
                            onTap: () => showCompletionDialog(userId, services),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 163, 140, 122),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  // Müşteri ikonu
                                  Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  // Misafir bilgileri
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '$userName requested room service',
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
                                  // İstek saati
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
          ),
        ],
      ),
    );
  }
}

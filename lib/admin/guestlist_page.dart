import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class GuestListPage extends StatelessWidget {
  const GuestListPage({Key? key}) : super(key: key);

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
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'CONFIRMED GUESTS',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 143, 115, 94),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Person')
                          .where('confirmed', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('An error occurred while loading guests.'),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No confirmed guests found.'),
                          );
                        }

                        List<QueryDocumentSnapshot> guestList = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: guestList.length,
                          itemBuilder: (context, index) {
                            var guest = guestList[index];
                            String userName = guest['userName']?.toString() ?? 'N/A';
                            String email = guest['email']?.toString() ?? 'N/A';
                            String roomNumber = guest['roomNumber']?.toString() ?? 'N/A';
                            Timestamp startDate = guest['startDate'] ?? Timestamp.now();
                            Timestamp endDate = guest['endDate'] ?? Timestamp.now();

                            String startDateFormatted = _formatDate(startDate);
                            String endDateFormatted = _formatDate(endDate);

                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              color: const Color.fromARGB(255, 163, 140, 122),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Name: $userName',
                                            style: const TextStyle(
                                              color: Color.fromARGB(255, 255, 255, 255),
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Email: $email',
                                            style: const TextStyle(
                                              color: Color.fromARGB(255, 255, 255, 255),
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          Text(
                                            'Room: $roomNumber',
                                            style: const TextStyle(
                                              color: Color.fromARGB(255, 255, 255, 255),
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          Text(
                                            'Start Date: $startDateFormatted',
                                            style: const TextStyle(
                                              color: Color.fromARGB(255, 255, 255, 255),
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          Text(
                                            'End Date: $endDateFormatted',
                                            style: const TextStyle(
                                              color: Color.fromARGB(255, 255, 255, 255),
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Color.fromARGB(255, 255, 255, 255),
                                      ),
                                      onPressed: () async {
                                        bool confirmDelete =
                                            await _showDeleteConfirmationDialog(context);
                                        if (confirmDelete) {
                                          FirebaseFirestore.instance
                                              .collection('Person')
                                              .doc(guest.id)
                                              .delete();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color.fromARGB(255, 163, 140, 122), // Arka plan rengi
          title: const Text(
            'Confirm Delete',
            style: TextStyle(color: Colors.white), // Başlık rengi beyaz
          ),
          content: const Text(
            'Are you sure you want to delete this guest?',
            style: TextStyle(color: Colors.white), // İçerik rengi beyaz
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white), // Cancel yazısı beyaz
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Delete',
                style: TextStyle(color: Color.fromARGB(255, 109, 18, 12)), // Delete yazısı kırmızı
              ),
            ),
          ],
        ),
      ) ??
      false;
}
}
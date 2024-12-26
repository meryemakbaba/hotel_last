
import 'dart:convert'; // Fotoğrafları decode etmek için
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serenadepalace/admin/updateroom.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class AdminRoomListPage extends StatelessWidget {
  const AdminRoomListPage({Key? key}) : super(key: key);

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
          // White container with heading and room list
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                children: [
                  // Heading for the page
                  const Center(
                        child: Text(
                          'Rooms',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 143, 115, 94),
                          ),
                        ),
                      ),
                  const SizedBox(height: 20),

                  // Room list from Firestore
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Rooms').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No rooms found.'));
                        }

                        List<QueryDocumentSnapshot> rooms = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            var room = rooms[index];
                            String type = room['type'];
                            double number = (room['roomNumber'] as num).toDouble();
                            List<dynamic> imagesBase64 = room['images'];

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminSecondPage(room: room),
                                  ),
                                );
                              },
                              highlightColor: Colors.brown.shade200,
                              
                              child: Card(
                                margin: const EdgeInsets.all(8.0),
                                color:Color.fromARGB(255, 163, 140, 122),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      // Room image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          base64Decode(imagesBase64[0]),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              type,
                                              style: const TextStyle(
                                                color: Color.fromARGB(255, 66, 41, 33),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            Text(
                                              ' ${number.toStringAsFixed(0)}',
                                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 66, 41, 33),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
}

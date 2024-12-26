
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serenadepalace/admin/updatestaffpage.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class StaffListPage extends StatelessWidget {
  const StaffListPage({Key? key}) : super(key: key);

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
          // White container with heading and staff list
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
                  // Heading for the page
                  
                  const Center(
                    child: Text(
                      'Staff',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 143, 115, 94),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Staff list from Firestore
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('Staff').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text('No staff found.'));
                        }

                        List<QueryDocumentSnapshot> staffList = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: staffList.length,
                          itemBuilder: (context, index) {
                            var staff = staffList[index];
                            String name = staff['userName'];
                            String job = staff['job'];
                            IconData icon = _getJobIcon(job);

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateStaffPage( staffId: staff.id,),
                                  ),
                                );
                              },
                              highlightColor: Colors.brown.shade200,
                              child: Card(
                                margin: const EdgeInsets.all(8.0),
                                color: Color.fromARGB(255, 163, 140, 122),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      // Job icon
                                      Icon(
                                        icon,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 10),

                                      // Staff name and job
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                color: Color.fromARGB(255, 66, 41, 33),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            Text(
                                              job,
                                              style: const TextStyle(color: Colors.brown,fontSize: 12.0),
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

  IconData _getJobIcon(String job) {
    switch (job) {
      case 'Housekeeping Staff':
        return Icons.house_outlined;
      case 'Room Service Staff':
        return Icons.room_service;
      case 'Spa Therapist':
        return Icons.spa;
      case 'Alternative Medicine Therapist':
        return Icons.local_hospital;
      case 'Room Service':
        return Icons.room_service;
      default:
        return Icons.person;
    }
  }
}

// The UpdateStaffPage will be created in a separate file and linked here.

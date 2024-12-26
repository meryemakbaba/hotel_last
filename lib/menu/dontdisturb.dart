import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class Dontdisturb extends StatefulWidget {
  const Dontdisturb({Key? key}) : super(key: key);

  @override
  State<Dontdisturb> createState() => _DontdisturbState();
}

class _DontdisturbState extends State<Dontdisturb> {
  bool isdontdisturbRequested = false;
  DateTime? dontdisturbTime;
  @override
  void initState() {
    super.initState();
    _checkDontDisturbStatus();
  }

  Future<void> _checkDontDisturbStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        final userDoc = await FirebaseFirestore.instance
            .collection('Person')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          final dontdisturbStatus = userDoc.data()?['dontdisturb'] ?? false;
          final dontdisturbTimeStamp = userDoc.data()?['dontdisturbTime'];

          if (dontdisturbStatus && dontdisturbTimeStamp != null) {
            DateTime fetchedTime = (dontdisturbTimeStamp as Timestamp).toDate();
            DateTime threeHoursAgo = DateTime.now().subtract(Duration(hours: 3));

            if (fetchedTime.isAfter(threeHoursAgo)) {
              setState(() {
                isdontdisturbRequested = true;
                dontdisturbTime = fetchedTime;
              });
              print('dontdisturb requested at: $dontdisturbTime');
            } else {
              setState(() {
                dontdisturbTime = null;
              });
            }
          }
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> requestdontdisturb() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        final currentTime = Timestamp.now();  // Firestore timestamp

        await FirebaseFirestore.instance
            .collection('Person')
            .doc(userId)
            .update({
          'dontdisturb': true,
          'dontdisturbTime': currentTime, // Time'ı güncelle
        });

        setState(() {
          isdontdisturbRequested = true;
          dontdisturbTime = currentTime.toDate();
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
  Future<void> requestcanceldontdisturb() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        final currentTime = Timestamp.now();  // Firestore timestamp

        await FirebaseFirestore.instance
            .collection('Person')
            .doc(userId)
            .update({
          'dontdisturb': false,
          'dontdisturbTime': currentTime, // Time'ı güncelle
        });

        setState(() {
          isdontdisturbRequested = false;
          dontdisturbTime = currentTime.toDate();
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
                    if (isdontdisturbRequested) 
                      Column(
                        children: [
                         GestureDetector(
                            onTap: requestcanceldontdisturb,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.cancel_outlined,
                                  size: 100,
                                  color: Color.fromARGB(255, 143, 115, 94),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Click, to close the mood",
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
                      )
                    else
                      Column(
                        children: [
                          GestureDetector(
                            onTap: requestdontdisturb,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.do_not_disturb,
                                  size: 100,
                                  color: Color.fromARGB(255, 143, 115, 94),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Click, to mute us",
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

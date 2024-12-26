import 'package:flutter/material.dart';
import 'package:serenadepalace/menu/checkin.dart';
import 'package:serenadepalace/screens/welcome_screen.dart';
import 'package:serenadepalace/services/auth_service.dart';

class FirstHomePage extends StatefulWidget {
  const FirstHomePage({super.key});

  @override
  _FirstHomePageState createState() => _FirstHomePageState();
}

class _FirstHomePageState extends State<FirstHomePage> {
  final AuthService _authService = AuthService();

  String? userName;
  String date = ' ';
  bool confirmed = false;
  bool isCheckedOut = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadDate();
    
  }

  Future<void> _loadUserData() async {
    String? name = await _authService.getUserName();
    if (name != null) {
      setState(() {
        userName = name;
      });
    }
  }

  

  void _loadDate() async {
    String? lastDate = await _authService.getLastResetDate();
    if (lastDate != null) {
      setState(() {
        date = lastDate;
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
            Positioned(
              top: 150.0,
              left: 20.0,
              child: Text(
                'Hello! ${userName ?? ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 180.0,
              left: 20.0,
              child: Text(
                date,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
  top: 300.0,
  left: 20.0,
  right: 20.0,
  child: Container(
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 143, 115, 94).withOpacity(0.4),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    padding: EdgeInsets.all(12),
    child: Text(
      'We are Waiting for You at Serenade Palace!\n\nGet ready to experience unmatched luxury and comfort! Complete your check-in one day before your reservation date to unlock full access to our exceptional amenities, including world-class dining, a relaxing spa, and more.\n\nWe look forward to welcoming you!',
      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      textAlign: TextAlign.left,
    ),
  ),
),

            DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.1,
              maxChildSize: 0.2,
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
                      const SizedBox(height: 30),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const CheckScreen(),
                                ),
                              );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ), backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Icon(Icons.check_box, size: 50, color: Color.fromARGB(255, 143, 115, 94),),
                                  SizedBox(height: 10),
                                   Text(
                                  'In and Out',
                                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 143, 115, 94),),
                                  ),
                                 ],
                               ),  
                              ),
                            ),
                          ],
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

/*
import 'package:flutter/material.dart';
import 'package:serenadepalace/menu/checkin.dart';
import 'package:serenadepalace/screens/welcome_screen.dart';
import 'package:serenadepalace/services/auth_service.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 143, 115, 94),
                ),
                child: Text(
                  'View and Set',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Set Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 143, 115, 94),
                  ),
                ),
                onTap: () {
                  // Profile settings
                },
              ),
            ],
          ),
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
              top: 120.0,
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
              top: 145.0,
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
              top: 180.0,
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
                child: Text('Your Hotel is in Your Pocket !',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ), 
            DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.6,
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
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
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
                                  Icon(Icons.room_service, size: 50, color: Color.fromARGB(255, 143, 115, 94),),
                                  SizedBox(height: 10),
                                   Text(
                                  'Room service',
                                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 143, 115, 94),),
                                  ),
                                 ],
                               ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {},
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
                                  Icon(Icons.water_damage_outlined, size: 50, color: Color.fromARGB(255, 143, 115, 94),),
                                  SizedBox(height: 10),
                                   Text(
                                  'Housekeeping',
                                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 143, 115, 94),),
                                  ),
                                 ],
                               ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {},
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
                                  Icon(Icons.do_not_disturb, size: 50, color: Color.fromARGB(255, 143, 115, 94),),
                                  SizedBox(height: 10),
                                   Text(
                                  'Dont disturb',
                                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 143, 115, 94),),
                                  ),
                                 ],
                               ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {},
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
                                  Icon(Icons.call, size: 50, color: Color.fromARGB(255, 143, 115, 94),),
                                  SizedBox(height: 10),
                                   Text(
                                  'Reception',
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

*/

import 'package:flutter/material.dart';
import 'package:serenadepalace/menu/alternative.dart';
import 'package:serenadepalace/menu/checkin.dart';
import 'package:serenadepalace/menu/dontdisturb.dart';
import 'package:serenadepalace/menu/housekeepingservice.dart';
import 'package:serenadepalace/menu/contact.dart';
import 'package:serenadepalace/menu/restourant.dart';
import 'package:serenadepalace/menu/roomservice.dart';
import 'package:serenadepalace/menu/spa.dart';
import 'package:serenadepalace/screens/editprofile.dart';
import 'package:serenadepalace/screens/welcome_screen.dart';
import 'package:serenadepalace/services/auth_service.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
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
              icon: const Icon(Icons.exit_to_app_sharp, color: Colors.white, size: 30),
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
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 143, 115, 94),
                ),
                child: Text(
                  'View and Set',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Set Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 143, 115, 94),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const EditProfilePage(),
                                ),
                              );
                },
              ),
            ],
          ),
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
              top: 120.0,
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
              top: 145.0,
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
              top: 180.0,
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
                  'Your Hotel is in Your Pocket !',
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.7,
              maxChildSize: 0.9, // Increased max size to allow for more space
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
                        const SizedBox(height: 10),
                        // Horizontal Scrollable Buttons
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                   Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const RoomServicePage(),
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
                                  Icon(Icons.room_service, size: 50, color: Color.fromARGB(255, 143, 115, 94),),
                                  SizedBox(height: 10),
                                   Text(
                                  'Room service',
                                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 143, 115, 94),),
                                  ),
                                 ],
                               ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const HousekeepingServicePage(),
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
                                  Icon(Icons.water_damage_outlined, size: 50, color: Color.fromARGB(255, 143, 115, 94),),
                                  SizedBox(height: 10),
                                   Text(
                                  'Housekeeping',
                                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 143, 115, 94),),
                                  ),
                                 ],
                               ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const Dontdisturb(),
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
                                  Icon(Icons.do_not_disturb, size: 50, color: Color.fromARGB(255, 143, 115, 94),),
                                  SizedBox(height: 10),
                                   Text(
                                  'Dont disturb',
                                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 143, 115, 94),),
                                  ),
                                 ],
                               ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                   Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const ContactPage(),
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
                                  Icon(Icons.call, size: 50, color: Color.fromARGB(255, 143, 115, 94),),
                                  SizedBox(height: 10),
                                   Text(
                                  'Contact',
                                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 143, 115, 94),),
                                  ),
                                 ],
                               ),
                              ),
                            ),
                          ],
                        ),
                        ),
                        const SizedBox(height: 10),
                        _buildImageButton('RESTAURANT', 'assets/images/homepage3.jpg', () {
                          Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const RestaurantPage(),
                                ),
                              );
                        }),
                        _buildImageButton('SPA', 'assets/images/homepage4.jpg', () {
                           Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SpaPage(),
                                ),
                              );
                        }),
                        _buildImageButton('ALTERNATIVE MEDICINE', 'assets/images/homepage6.jpg', () {
                           Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const AlternativePage(),
                                ),
                              );
                        }),
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

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 143, 115, 94).withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: Color.fromARGB(255, 143, 115, 94)),
              SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 143, 115, 94)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageButton(String label, String imagePath, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

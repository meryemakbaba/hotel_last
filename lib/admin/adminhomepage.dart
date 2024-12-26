/*
import 'package:flutter/material.dart';
import 'package:serenadepalace/admin/addroom.dart';
import 'package:serenadepalace/admin/addstaff.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            height: MediaQuery.of(context).size.height - 60, // Beyaz container sayfa altına kadar
            
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddRoomPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color.fromARGB(255, 143, 115, 94), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                    ),
                    child: const Text(
                      'Add New Room',
                      style: TextStyle(
                        color: Color.fromARGB(255, 143, 115, 94),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Butonlar arası boşluk
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddStafPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color.fromARGB(255, 143, 115, 94), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 15.0),
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                    ),
                    child: const Text(
                      'Add Staff',
                      style: TextStyle(
                        color: Color.fromARGB(255, 143, 115, 94),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            
          ),
        ],
      ),
    );
  }
}

*/


import 'package:flutter/material.dart';
import 'package:serenadepalace/admin/addfood.dart';
import 'package:serenadepalace/admin/addroom.dart';
import 'package:serenadepalace/admin/addstaff.dart';
import 'package:serenadepalace/admin/adminroomlist.dart';
import 'package:serenadepalace/admin/adminstafflist.dart';
import 'package:serenadepalace/screens/welcome_screen.dart';
import 'package:serenadepalace/services/auth_service.dart';
import 'package:serenadepalace/admin/guestlist_page.dart';
import 'package:serenadepalace/screens/editprofile.dart';
//import 'package:serenadepalace/admin/editprofile_page.dart'; // Edit Profile page import

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final AuthService _authService = AuthService();

  String? userName;
  String date = ' ';

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
              icon: const Icon(Icons.exit_to_app_sharp, color: Colors.white, size: 30), // Exit icon instead of profile
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
        ), // Removed the drawer
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
              top: 90.0,
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
              top: 113.0,
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
            DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.7,
              maxChildSize: 0.8,
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
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
                                        builder: (context) => GuestListPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.group,
                                      size: 50,
                                      color: Color.fromARGB(255, 143, 115, 94),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Guests',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 143, 115, 94),
                                      ),
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
                                        builder: (context) => AddFoodPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.room_service,
                                      size: 50,
                                      color: Color.fromARGB(255, 143, 115, 94),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Restourant',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 143, 115, 94),
                                      ),
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
                                  ),
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.spa, size: 50, color: Color.fromARGB(255, 143, 115, 94),),
                                    SizedBox(height: 10),
                                    Text(
                                      'Spa',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 143, 115, 94),
                                      ),
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
                                  ),
                                  backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  elevation: 0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.medical_services, size: 50, color: Color.fromARGB(255, 143, 115, 94),),
                                    SizedBox(height: 10),
                                    Text(
                                      'Medicine',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 143, 115, 94),
                                      ),
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
                                  ),
                                  backgroundColor: Colors.transparent,
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
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 143, 115, 94),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ), 
                      const SizedBox(height: 50), 
                      const Text(
                        'What do you want to do?',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 143, 115, 94),
                        ),
                      ),
                      const SizedBox(height: 50), 
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddRoomPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color.fromARGB(255, 143, 115, 94), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                        ),
                        child: const Text(
                          'Add New Room',
                          style: TextStyle(
                            color: Color.fromARGB(255, 143, 115, 94),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminRoomListPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color.fromARGB(255, 143, 115, 94), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                        ),
                        child: const Text(
                          'Update Rooms',
                          style: TextStyle(
                            color: Color.fromARGB(255, 143, 115, 94),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Butonlar arası boşluk
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddStaffPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color.fromARGB(255, 143, 115, 94), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                        ),
                        child: const Text(
                          'Add Staff',
                          style: TextStyle(
                            color: Color.fromARGB(255, 143, 115, 94),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), 
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StaffListPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color.fromARGB(255, 143, 115, 94), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40.0, vertical: 15.0),
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                        ),
                        child: const Text(
                          'Update Staff',
                          style: TextStyle(
                            color: Color.fromARGB(255, 143, 115, 94),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
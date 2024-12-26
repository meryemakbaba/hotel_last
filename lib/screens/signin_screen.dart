import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:serenadepalace/admin/adminhomepage.dart';
import 'package:serenadepalace/firsthome.dart';
import 'package:serenadepalace/home2.dart';
import 'package:serenadepalace/screens/room.dart';
import 'package:serenadepalace/screens/signup_screen.dart';
import 'package:serenadepalace/services/auth_service.dart';
import 'package:serenadepalace/admin/admin_service.dart';
import 'package:serenadepalace/staffs/altstaff.dart';
import 'package:serenadepalace/staffs/housekeepinghomepage.dart';
import 'package:serenadepalace/staffs/roomservicehomepage.dart';
import 'package:serenadepalace/staffs/spastaff.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberPassword = true;
  bool showPassword = false;
  final AuthService _authService = AuthService();
  bool isLoading = false;

  void navigateBasedOnRole(BuildContext context) async {
    setState(() {
      isLoading = true; // Yüklenme durumunu başlat
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Staff')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data();
          final job = data?['job'];

          if (job == "Housekeeping Staff") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HouseKeepingHomePage()),
            );
            return;
          } else if (job == "Room Service Staff") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RoomServiceHomePage()),
            );
            return;
          }else if (job == "Spa Therapist") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SpastaffHomePage()),
            );
            return;
          }else if (job == "Alternative Medicine Therapist") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AltstaffHomePage()),
            );
            return;
          }
        }

        AdminService adminService = AdminService();
        bool isAdmin = await adminService.isAdmin();

        if (isAdmin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminHomePage()),
          );
        } else {
          final userDoc = await FirebaseFirestore.instance
              .collection('Person')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            final data = userDoc.data();
            final startDate = data?['startDate'];
            final endDate = data?['endDate'];
            final roomNumber = data?['roomNumber'];
            final confirmed = data?['confirmed'] ?? false;

            if (startDate == null || endDate == null || roomNumber == null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RoomListPage()),
              );
            } else if (!confirmed) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FirstHomePage()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage2()),
              );
            }
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RoomListPage()),
            );
          }
        }
      }
    } catch (e) {
      print("Error in navigation: $e");
    } finally {
      setState(() {
        isLoading = false; // Yüklenme durumu sona erdi
      });
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
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 143, 115, 94),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            'Email',
                            style: TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),
                          ),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 143, 115, 94),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 143, 115, 94),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 143, 115, 94),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !showPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            'Password',
                            style: TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),
                          ),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 143, 115, 94),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 143, 115, 94),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 143, 115, 94),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _authService
                                .signIn(_emailController.text,
                                    _passwordController.text)
                                .then((value) {
                              if (value != null) {
                                navigateBasedOnRole(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Wrong Email or Password'),
                                  ),
                                );
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 143, 115, 94),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      if (isLoading)
            Container(
              color: Colors.white, // Arka planı yarı saydam yap
              child: const Center(
                child: CircularProgressIndicator(), // Yüklenme göstergesi
              ),
            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 143, 115, 94),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

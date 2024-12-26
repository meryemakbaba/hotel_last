
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

bool _isLoading = false;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _userNameFieldController = TextEditingController();

  bool _passwordVisible = false;
  bool _showPasswordFields = false;
  User? _user;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

 Future<void> _fetchUserData() async {
  if (_user != null) {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('Person')
          .doc(_user!.uid)
          .get();
      final data = userDoc.data();

      if (data != null) {
        setState(() {
          _userName = data['userName'] ?? 'Unknown';
          _userNameFieldController.text = _userName!; // Kontrolcüyü güncelle
        });
      }
      print('Fetched data: $data');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }
}


  Future<void> _resetPassword() async {
    if (_user == null) return;

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _user!.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _changePassword() async {
    if (_passwordController.text.isEmpty || _newPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both current and new password')),
      );
      return;
    }

    if (_newPasswordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password should be at least 8 characters long')),
      );
      return;
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: _user!.email!,
        password: _passwordController.text,
      );

      await _user!.reauthenticateWithCredential(credential);
      await _user!.updatePassword(_newPasswordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 143, 115, 94),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                     TextFormField(
  controller: _userNameFieldController, // Kontrolcüyü bağlayın
  enabled: false, // Salt okunur
  decoration: InputDecoration(
    label: const Text(
      'User Name',
      style: TextStyle(
        color: Color.fromARGB(255, 143, 115, 94),
        fontSize: 16.0,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 143, 115, 94),
      ),
    ),
  ),
),

                      const SizedBox(height: 25.0),
                      TextFormField(
                        initialValue: _user?.email ?? 'No email found',
                        enabled: false, // Salt okunur
                        decoration: InputDecoration(
                          label: const Text(
                            'Email',
                            style: TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 143, 115, 94),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showPasswordFields = true;
                              });
                            },
                            child: const Text(
                              'I want to change my password',
                              style: TextStyle(
                                color: Color.fromARGB(255, 3, 52, 93),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          TextButton(
                            onPressed: _resetPassword,
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 3, 52, 93),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_showPasswordFields) ...[
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          obscuringCharacter: '*',
                          decoration: InputDecoration(
                            label: const Text(
                              'Current Password',
                              style: TextStyle(
                                color: Color.fromARGB(255, 143, 115, 94),
                                fontSize: 16.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 143, 115, 94),
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.black26,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: !_passwordVisible,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new password';
                            } else if (value.length < 8) {
                              return 'Password should have at least 8 characters';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text(
                              'New Password',
                              style: TextStyle(
                                color: Color.fromARGB(255, 143, 115, 94),
                                fontSize: 16.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 143, 115, 94),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        
                        ElevatedButton(
                          onPressed: _changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 143, 115, 94),
                            minimumSize: const Size(400, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Change Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          // Save changes logic here
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 143, 115, 94),
                          minimumSize: const Size(400, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Save Changes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () async {
                          final confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Are you sure?'),
                              content: const Text(
                                  'Do you really want to delete your account? This action cannot be undone.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Yes, Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmDelete == true) {
                            try {
                              // Firestore'dan kullanıcı verisini sil
                              await FirebaseFirestore.instance
                                  .collection('Person')
                                  .doc(_user!.uid)
                                  .delete();
                              // Firebase Authentication'dan kullanıcıyı sil
                              await _user!.delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Account deleted successfully!')),
                              );
                              // Kullanıcıyı giriş ekranına yönlendir
                              Navigator.pushReplacementNamed(context, '/login');
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error deleting account: $e')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 93, 15, 9),
                          minimumSize: const Size(400, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Delete My Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
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

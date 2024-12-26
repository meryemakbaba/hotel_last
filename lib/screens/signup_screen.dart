import 'package:flutter/material.dart';
import 'package:serenadepalace/screens/room.dart';
import 'package:serenadepalace/screens/signin_screen.dart';
import 'package:serenadepalace/services/auth_service.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool agreePersonalData = true;
  bool _passwordVisible = false;

  AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

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
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
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
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Full name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Full Name',style: TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),),
                          hintText: 'Enter Full Name',
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
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email',style: TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),),
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
                        obscureText: !_passwordVisible,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          } else if (value.length < 8) {
                            return 'Your password should have at least 8 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password',style: TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),),
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
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Color.fromARGB(255, 143, 115, 94),
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: Color.fromARGB(255, 143, 115, 94),
                          ),
                          const Text(
                            'I agree to the processing of ',
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            'Personal data',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 143, 115, 94),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formSignupKey.currentState!.validate()) {
                              if (!agreePersonalData) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Please agree to the processing of Personal data.'),
                                  ),
                                );
                              } else {
                                _authService
                                    .createPerson(
                                      _nameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                    )
                                    .then((value) {
                                  if (value != null) {
                                    //_calculateRecommended();
                                    // Başarılı kayıt sonrası yönlendirme
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RoomListPage(),
                                      ),
                                    );
                                  } else {
                                    // Hatalı kayıt durumunda mesaj gösterme
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('This email already exists.'),
                                      ),
                                    );
                                  }
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                             backgroundColor: Color.fromARGB(255, 143, 115, 94),
                             shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(20.0),
                           ),
                          ),                              
                          child: const Text('Sign up',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold, fontSize: 16),),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignInScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 143, 115, 94),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
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
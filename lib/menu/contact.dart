import 'package:flutter/material.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);
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
                 child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Serenade Palace Hotel Contact \n\n',
                     style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 143, 115, 94),
                          ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '📞 Reception Number: +90 123 456 7890\n',
                     style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 53, 29, 11),
                          ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    '📍 Hotel Address: Serenade Hotel, Casablanca, Morocco\n',
                    style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 53, 29, 11),
                          ),
                  ),
                  const SizedBox(height: 15),
                 
                  const SizedBox(height: 15),
                 
                  const SizedBox(height: 10),
                 
                  const SizedBox(height: 30),
                  
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


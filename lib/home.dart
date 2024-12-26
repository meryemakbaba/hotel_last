


import 'package:flutter/material.dart';
import 'package:serenadepalace/screens/signup_screen.dart';
import 'package:serenadepalace/screens/welcome_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/homepage1.jpg',
      'title': '',
      'subtitle': 'Would you like to take a look at our hotel? Every corner of Serenade Palace is designed with your comfort in mind, offering a unique and unforgettable experience.'
    },
    {
      'image': 'assets/images/homepage2.jpg',
      'title': 'ROOMS',
      'subtitle': 'Our rooms provide the perfect blend of luxury and comfort, with modern amenities, elegant décor, and stunning views to make your stay as relaxing as possible'
    },
    {
      'image': 'assets/images/homepage3.jpg',
      'title': 'RESTOURANT',
      'subtitle': 'Indulge in a variety of gourmet dishes at our exquisite restaurants, where every meal is prepared with fresh ingredients and served in a beautiful, inviting atmosphere.'
    },
    {
      'image': 'assets/images/homepage4.jpg',
      'title': 'SPA',
      'subtitle': 'Pamper yourself with a wide range of spa treatments, from soothing massages to holistic therapies, all designed to restore your body and mind.'
    },
    {
      'image': 'assets/images/homepage5.jpg',
      'title': 'SELF CARE',
      'subtitle': 'Our hotel features a specialized care unit offering alternative medicine and natural therapies, providing personalized treatments for total wellness.'
    },
    {
      'image': 'assets/images/homepage6.jpg',
      'title': 'POOLS',
      'subtitle': 'Enjoy our four inviting pools, including a thermal pool with hot spring water, perfect for relaxation and rejuvenation throughout your stay.'
    },
    {
      'image': 'assets/images/homepage7.jpg',
      'title': '',
      'subtitle': 'Join us today by making a reservation through our online platform, where all our services are at your fingertips, ensuring a seamless and convenient experience.'
    },
  ];

 

  void nextPage() {
    setState(() {
      if (currentPage < pages.length - 1) {
        currentPage++;
      }
    });
  }

  void previousPage() {
    setState(() {
      if (currentPage > 0) {
        currentPage--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              pages[currentPage]['image']!,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              top: 150.0,
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
                  pages[currentPage]['subtitle']!,
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ), 
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  pages[currentPage]['title']!,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
               
              ],
            ),
          ),
          if (currentPage == 0)
            Positioned(
              bottom: 50,
              left: 0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const WelcomeScreen(),
                                ),
                              );
                            },
                child: Icon(Icons.navigate_before_outlined, size: 20, color: Colors.white,),
              ),
            ),
          Positioned(
            bottom: 50,
            left: 0,
            child: currentPage > 0
                ? TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.transparent,
                    ),
                    onPressed: previousPage,
                    child: Icon(Icons.navigate_before_outlined, size: 20, color: Colors.white,),
                  )
                : SizedBox.shrink(),
          ),
          Positioned(
            bottom: 50,
            right: 0,
            child: currentPage < pages.length - 1
                ? TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.transparent,
                    ),
                    onPressed: nextPage,
                    child: Icon(Icons.navigate_next_outlined, size: 20, color: Colors.white,),
                  )
                : SizedBox.shrink(),
          ),
          if (currentPage == pages.length - 1)
            Positioned(
              bottom: 50,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color.fromARGB(255, 143, 115, 94).withOpacity(0.4),
                ),
                onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (e) => const SignUpScreen(),
                                ),
                              );
                            },
                child: Text('Make a Reservation', style: TextStyle(color: Colors.white)),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
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



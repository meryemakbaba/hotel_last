import 'package:flutter/material.dart';
import 'package:serenadepalace/home2.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AlternativePage extends StatefulWidget {
  const AlternativePage({Key? key}) : super(key: key);

  @override
  State<AlternativePage> createState() => _AlternativePageState();
}

class _AlternativePageState extends State<AlternativePage> {
  String? _selectedTime;
  bool _isLoading = false;
  bool _hasReservationToday = false; // Bugün rezervasyon var mı kontrolü
  List<String> _availableTimeSlots = [];
  String? _reservationTime; // Rezervasyon saatini saklamak için değişken
  
  final List<String> _alternativeImages = [
    'assets/images/homepage5.jpg',
    'assets/images/alt3.jpg',
    'assets/images/alt2.jpeg',
  ];

  final List<String> _timeSlots = [
    '10:00', '12:00', '14:00', '16:00', '18:00', '20:00', '22:00',
  ];

  // Helper method to check if a time slot is available
  Future<List<String>> _getAvailableTimeSlots(DateTime currentTime) async {
    final availableSlots = <String>[];

    try {
      final normalizedCurrentTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        currentTime.hour,
        currentTime.minute,
      );

      final currentDate = "${currentTime.year}-${currentTime.month.toString().padLeft(2, '0')}-${currentTime.day.toString().padLeft(2, '0')}";

      final existingReservations = await FirebaseFirestore.instance
          .collection('AlternativeReservations')
          .where('date', isEqualTo: currentDate)
          .get();

      final reservedTimes = existingReservations.docs.map((doc) => doc['time'] as String).toList();

      for (var time in _timeSlots) {
        final timeParts = time.split(':');
        final slotDateTime = DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );

        if (slotDateTime.isAfter(normalizedCurrentTime) && !reservedTimes.contains(time)) {
          availableSlots.add(time);
        }
      }

      return availableSlots;
    } catch (e) {
      print('Error fetching available slots: $e');
      return [];
    }
  }

  Future<void> _submitReservation() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to make a reservation.')),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final currentDate = DateTime.now().add(const Duration(hours: 3));
      final formattedDate = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

      final existingUserReservations = await FirebaseFirestore.instance
          .collection('AlternativeReservations')
          .where('date', isEqualTo: formattedDate)
          .where('userEmail', isEqualTo: user.email)
          .get();

      if (existingUserReservations.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You already have a reservation for today.')),
        );
        return;
      }

      final existingReservations = await FirebaseFirestore.instance
          .collection('AlternativeReservations')
          .where('date', isEqualTo: formattedDate)
          .where('time', isEqualTo: _selectedTime)
          .get();

      if (existingReservations.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This time slot is fully booked. Please choose another.')),
        );
        return;
      }

      String userName = user.displayName ?? 'Unknown User';

      if (userName == 'Unknown User' && user.email != null) {
        userName = user.email!.split('@').first;
      }

      // Rezervasyonu kaydetme işlemi
      DocumentReference docRef = await FirebaseFirestore.instance.collection('AlternativeReservations').add({
        'date': formattedDate,
        'time': _selectedTime,
        'userName': userName,
        'userEmail': user.email ?? 'Unknown Email',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Kaydedilen rezervasyonun saatini alıyoruz
      DocumentSnapshot docSnapshot = await docRef.get();
      setState(() {
        _reservationTime = docSnapshot['time']; // Firebase'den gelen saat bilgisi
        _selectedTime = null; // Zamanı sıfırlıyoruz
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation submitted successfully.')),
      );

      // Redirect to HomePage2 after successful submission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage2()), // Ensure you have HomePage2 imported
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fetch available slots and check if the user has a reservation for today
 Future<void> _checkUserReservation() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return;
  }

  final currentDate = DateTime.now().add(const Duration(hours: 3));
  final formattedDate = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')}";

  final existingUserReservations = await FirebaseFirestore.instance
      .collection('AlternativeReservations')
      .where('date', isEqualTo: formattedDate)
      .where('userEmail', isEqualTo: user.email)
      .get();

  if (existingUserReservations.docs.isNotEmpty) {
    final reservationTime = existingUserReservations.docs.first['time'] as String; // Kullanıcının rezervasyon saati
    setState(() {
      _hasReservationToday = true;
      _reservationTime = reservationTime; // Zaman bilgisini sakla
    });
  } else {
    setState(() {
      _hasReservationToday = false;
      _reservationTime = null; // Rezervasyon yoksa zaman bilgisini sıfırla
    });
  }
 }

 @override
 void initState() {
  super.initState();
  _fetchAvailableTimeSlots();
  _checkUserReservation(); // Kullanıcı rezervasyonunu kontrol et
 }

  Future<void> _fetchAvailableTimeSlots() async {
    final currentTime = DateTime.now().add(const Duration(hours: 3));
    final availableSlots = await _getAvailableTimeSlots(currentTime);

    setState(() {
      _availableTimeSlots = availableSlots;
    });
  }

 @override
Widget build(BuildContext context) {
  return CustomScaffold(
    child: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/wl.jpg'),
          fit: BoxFit.cover,
        ),
      ),
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
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                      ),
                      items: _alternativeImages.map((image) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Select Time',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 143, 115, 94),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Note: Alternative Medicine services are available between 10:00 AM and 10:00 PM.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _hasReservationToday
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'You already made a reservation today.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 78, 13, 8),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'at: $_reservationTime', // Rezervasyon saati
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                              : DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: 'Select Time',
                                    labelStyle: const TextStyle(
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
                                  value: _selectedTime,
                                  items: _availableTimeSlots.map((time) {
                                    return DropdownMenuItem(
                                      value: time,
                                      child: Text(time),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedTime = value;
                                    });
                                  },
                                ),
                          const SizedBox(height: 20),
                          _hasReservationToday
                              ? SizedBox()
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _submitReservation,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(255, 143, 115, 94),
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator(color: Colors.white)
                                        : const Text(
                                            'Submit Reservation',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serenadepalace/firsthome.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';

class RezervationScreen extends StatefulWidget {
  final dynamic room;

  const RezervationScreen({Key? key, required this.room}) : super(key: key);

  @override
  State<RezervationScreen> createState() => _RezervationScreenState();
}

class _RezervationScreenState extends State<RezervationScreen> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  bool isLoading = false;
  String? userName;
  String? userEmail;
  late User? currentUser;
  double totalCost = 0.0;

  List<DateTime> reservedDates = [];
  DateTime focusedDay = DateTime.now(); // Initialize focusedDay with current date

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchReservedDates();
  }

  Future<void> _loadUserData() async {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Person').doc(currentUser!.uid).get();
      setState(() {
        userName = userDoc['userName'];
        userEmail = userDoc['email'];
      });
    }
  }

  Future<void> fetchReservedDates() async {
    QuerySnapshot reservations = await FirebaseFirestore.instance
        .collection('RoomRezervation')
        .where('roomNumber', isEqualTo: widget.room['roomNumber'])
        .get();

    setState(() {
      reservedDates = reservations.docs.map((doc) {
        DateTime start = (doc['startDate'] as Timestamp).toDate();
        DateTime end = (doc['endDate'] as Timestamp).toDate();
        return List<DateTime>.generate(
            end.difference(start).inDays + 1,
            (index) => start.add(Duration(days: index)));
      }).expand((dates) => dates).toList();
    });
  }

  bool isDateReserved(DateTime day) {
    return reservedDates.any((reservedDate) => isSameDay(day, reservedDate));
  }

  void calculateTotalCost() {
    if (selectedStartDate != null && selectedEndDate != null) {
      totalCost = 0.0;
      int totalNights = selectedEndDate!.difference(selectedStartDate!).inDays;
      DateTime currentDate = selectedStartDate!;

      for (int i = 0; i < totalNights; i++) {
        if (currentDate.weekday == DateTime.friday ||
            currentDate.weekday == DateTime.saturday ||
            currentDate.weekday == DateTime.sunday) {
          totalCost += (widget.room['price'] as num).toDouble() * 1.1; // %10 increase for weekends
        } else {
          totalCost += (widget.room['price'] as num).toDouble();
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }
  }

  Future<void> _reserveRoom() async {
    if (selectedStartDate == null || selectedEndDate == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select both start and end dates.')));
      return;
    }

    if (selectedEndDate!.isBefore(selectedStartDate!)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('End date must be after start date.')));
      return;
    }

    if (selectedStartDate!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Start date cannot be in the past.')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot reservations = await FirebaseFirestore.instance
          .collection('RoomRezervation')
          .where('roomNumber', isEqualTo: widget.room['roomNumber'])
          .get();

      for (var reservation in reservations.docs) {
        DateTime reservationStartDate = (reservation['startDate'] as Timestamp).toDate();
        DateTime reservationEndDate = (reservation['endDate'] as Timestamp).toDate();

        if ((selectedStartDate!.isBefore(reservationEndDate) || isSameDay(selectedStartDate!, reservationEndDate)) &&
            (selectedEndDate!.isAfter(reservationStartDate) || isSameDay(selectedEndDate!, reservationStartDate))) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Room is not available from ${DateFormat('yyyy-MM-dd').format(selectedStartDate!)} to ${DateFormat('yyyy-MM-dd').format(selectedEndDate!)}.'),
          ));
          setState(() {
            isLoading = false;
          });
          return;
        }
      }

      await FirebaseFirestore.instance.collection('RoomRezervation').add({
        'userName': userName,
        'email': userEmail,
        'startDate': selectedStartDate,
        'endDate': selectedEndDate,
        'roomNumber': widget.room['roomNumber'],
      });

      await FirebaseFirestore.instance.collection('Person').doc(currentUser!.uid).set({
        'roomNumber': widget.room['roomNumber'],
        'startDate': selectedStartDate,
        'endDate': selectedEndDate,
        'cost': totalCost,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Reservation completed successfully.')));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => FirstHomePage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Select the dates',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 143, 115, 94),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.utc(2025, 12, 31),
                      focusedDay: focusedDay,
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedStartDate, day) ||
                            isSameDay(selectedEndDate, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (!isDateReserved(selectedDay)) {
                          setState(() {
                            this.focusedDay = focusedDay;
                            if (selectedStartDate == null ||
                                (selectedEndDate != null &&
                                    selectedDay.isBefore(selectedStartDate!))) {
                              selectedStartDate = selectedDay;
                              selectedEndDate = null;
                            } else if (selectedStartDate != null &&
                                isSameDay(selectedStartDate!, selectedDay)) {
                              selectedStartDate = null;
                            } else if (selectedEndDate != null &&
                                isSameDay(selectedEndDate!, selectedDay)) {
                              selectedEndDate = null;
                            } else if (selectedStartDate != null &&
                                selectedDay.isAfter(selectedStartDate!)) {
                              selectedEndDate = selectedDay;
                            }
                          });
                          calculateTotalCost(); // Recalculate cost when dates are selected
                        }
                      },
                      enabledDayPredicate: (day) {
                        return !isDateReserved(day);
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.rectangle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: const Color.fromARGB(255, 143, 115, 94),
                          shape: BoxShape.rectangle,
                        ),
                        disabledDecoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.5),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      availableGestures: AvailableGestures.none,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (selectedStartDate != null && selectedEndDate != null)
                      Column(
                        children: [
                          Text(
                            'Enter Day: ${DateFormat('yyyy-MM-dd').format(selectedStartDate!)}',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 143, 115, 94)),
                          ),
                          Text(
                            'Exit Day: ${DateFormat('yyyy-MM-dd').format(selectedEndDate!)}',
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 143, 115, 94)),
                          ),
                          Text(
                            'Cost: \$${totalCost.toStringAsFixed(2)}', // Display updated cost
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 143, 115, 94)),
                          ),
                        ],
                      ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: isLoading ? null : _reserveRoom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 143, 115, 94),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text('Reserve Now',
                              style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 100),
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

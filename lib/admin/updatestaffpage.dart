import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serenadepalace/services/auth_service.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';
import 'package:intl/intl.dart';
// ignore: unused_import
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class UpdateStaffPage extends StatefulWidget {
  final String staffId;

  const UpdateStaffPage({Key? key, required this.staffId}) : super(key: key);

  @override
  State<UpdateStaffPage> createState() => _UpdateStaffPageState();
}

class _UpdateStaffPageState extends State<UpdateStaffPage> {
  final _formUpdateKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? selectedJob;
  String? profileImageUrl;
  String? _profileImageBase64;
  File? _newProfileImage;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool _isLoading = false;

  // ignore: unused_field
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadStaffDetails();
  }

  Future<void> _loadStaffDetails() async {
    try {
      DocumentSnapshot staffDoc = await FirebaseFirestore.instance
          .collection('Staff')
          .doc(widget.staffId)
          .get();

      if (staffDoc.exists) {
        setState(() {
          _nameController.text = staffDoc.get('userName') ?? '';
          _emailController.text = staffDoc.get('email') ?? '';
          selectedJob = staffDoc.get('job') ?? '';
          _profileImageBase64 = staffDoc.get('profileImageBase64');

          if (_profileImageBase64 != null) {
            profileImageUrl = _profileImageBase64;
          }

          if (staffDoc.get('workingHours') != null && staffDoc.get('workingHours').isNotEmpty) {
  final hours = staffDoc.get('workingHours').split(' - ');
  startTime = TimeOfDay(
      hour: int.parse(hours[0].split(':')[0]),
      minute: int.parse(hours[0].split(':')[1]));
  endTime = TimeOfDay(
      hour: int.parse(hours[1].split(':')[0]),
      minute: int.parse(hours[1].split(':')[1]));
 } else {
  // Varsayılan çalışma saatleri
  startTime = const TimeOfDay(hour: 8, minute: 0);
  endTime = const TimeOfDay(hour: 18, minute: 0);
 }

        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading staff details: $e'),
        ),
      );
    }
  }
 /*
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _newProfileImage = File(result.files.single.path!);
        profileImageUrl = base64Encode(result.files.single.bytes!);
      });
    }
  }*/

  Future<void> _saveImage() async {
    if (_newProfileImage != null) {
      try {
        final bytes = _newProfileImage!.readAsBytesSync();
        final base64Image = base64Encode(bytes);

        await FirebaseFirestore.instance
            .collection('Staff')
            .doc(widget.staffId)
            .update({'profileImageBase64': base64Image});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile image updated successfully!'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile image: $e'),
          ),
        );
      }
    }
  }


Future<void> _selectTime(BuildContext context, bool isStartTime) async {
  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();

  // Mevcut saatleri başlangıç için ayarla
  if (isStartTime && startTime != null) {
    hourController.text = startTime!.hour.toString().padLeft(2, '0');
    minuteController.text = startTime!.minute.toString().padLeft(2, '0');
  } else if (!isStartTime && endTime != null) {
    hourController.text = endTime!.hour.toString().padLeft(2, '0');
    minuteController.text = endTime!.minute.toString().padLeft(2, '0');
  }

  // Diyalog penceresi açma
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color.fromARGB(255, 163, 140, 122),
        title: Text(isStartTime ? 'Select Start Time' : 'Select End Time', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Saat girişi
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: hourController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Hour',
                      hintText: 'HH',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 2,
                  ),
                ),
                SizedBox(width: 10),
                Text(':', style: TextStyle(fontSize: 24)),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: minuteController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Minute',
                      hintText: 'MM',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
          ),
          TextButton(
            onPressed: () {
              // Kullanıcının girdiği saat ve dakika değerlerini al
              int? hour = int.tryParse(hourController.text);
              int? minute = int.tryParse(minuteController.text);

              // Geçerli bir saat ve dakika değeri girdiyse
              if (hour != null && minute != null) {
                setState(() {
                  if (isStartTime) {
                    startTime = TimeOfDay(hour: hour, minute: minute);
                  } else {
                    endTime = TimeOfDay(hour: hour, minute: minute);
                  }
                });
              }

              Navigator.of(context).pop();
            },
            child: Text('OK', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),),
          ),
        ],
      );
    },
  );
}

    void _openJobSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: const Text(
            'Choose the job',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                'Housekeeping Staff',
                'Room Service Staff',
                'Spa Therapist',
                'Alternative Medicine Therapist',
              ].map((job) {
                return ListTile(
                  title: Text(
                    job,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      selectedJob = job;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
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
                  key: _formUpdateKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Update Staff',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 143, 115, 94),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        //onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: profileImageUrl != null && profileImageUrl is String
    ? MemoryImage(base64Decode(profileImageUrl!))
    : null,

                          child: profileImageUrl == null && _newProfileImage == null
                              ? Icon(Icons.camera_alt, size: 30, color: Colors.grey[700])
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      if (_newProfileImage != null)
                        ElevatedButton(
                          onPressed: _saveImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 143, 115, 94),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text(
                            'Save Profile Image',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      const SizedBox(height: 40.0),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Full name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text(
                            'Full Name',
                            style: TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),
                          ),
                          hintText: 'Enter Full Name',
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
                      GestureDetector(
                        onTap: () {
                          _openJobSelectionDialog(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.brown),
                            color: Colors.white,
                          ),
                          child: Text(
                            selectedJob ?? 'Choose the job',
                            style: TextStyle(
                              color: selectedJob == null
                                  ? Color.fromARGB(255, 143, 115, 94)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
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
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectTime(context, true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.brown),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  startTime == null
                                      ? 'Start Time'
                                      : DateFormat.jm().format(
                                          DateTime(0, 0, 0, startTime!.hour, startTime!.minute)),
                                  style: const TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectTime(context, false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.brown),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  endTime == null
                                      ? 'End Time'
                                      : DateFormat.jm().format(
                                          DateTime(0, 0, 0, endTime!.hour, endTime!.minute)),
                                  style: const TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                     

 SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: _isLoading
        ? null
        : () async {
            if (_formUpdateKey.currentState!.validate()) {
              setState(() {
                _isLoading = true;
              });
              try {
                await FirebaseFirestore.instance
                    .collection('Staff')
                    .doc(widget.staffId)
                    .update({
                  'userName': _nameController.text,
                  'email': _emailController.text,
                  'job': selectedJob,
                  'workingHours': startTime != null && endTime != null
                      ? '${startTime!.hour}:${startTime!.minute} - ${endTime!.hour}:${endTime!.minute}'
                      : null,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Staff details updated successfully!'),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error updating staff: $e'),
                  ),
                );
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            }
          },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 143, 115, 94),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    child: _isLoading
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : const Text(
            'Update',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
  ),
 ),

                      const SizedBox(height: 20.0),
                      SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: _isLoading
        ? null
        : () async {
            setState(() {
              _isLoading = true;
            });
            try {
              await FirebaseFirestore.instance
                  .collection('Staff')
                  .doc(widget.staffId)
                  .delete();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Staff deleted successfully!'),
                ),
              );
              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error deleting staff: $e'),
                ),
              );
            } finally {
              setState(() {
                _isLoading = false;
              });
            }
          },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 94, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    child: _isLoading
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : const Text(
            'Delete Staff',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
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

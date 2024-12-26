/*
import 'dart:convert'; // Base64 encoding için
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // inputFormatters için
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class AddRoomPage extends StatefulWidget {
  @override
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  List<String> selectedImagesBase64 = [];
  bool _isLoading = false;
  String? selectedRoomType;

 Future<void> pickImages() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null) {
      if (result.files.length > 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You can select up to 3 images only!'),
          ),
        );
        return;
      }

      List<String> base64Images = [];

      for (var file in result.files) {
        // Eğer bytes null ise path üzerinden dosyayı okuyup base64'e çevir
        if (file.bytes != null) {
          base64Images.add(base64Encode(file.bytes!));
        } else if (file.path != null) {
          File imageFile = File(file.path!);
          base64Images.add(base64Encode(await imageFile.readAsBytes()));
        }
      }

      if (base64Images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No valid images were selected!'),
          ),
        );
        return;
      }

      setState(() {
        selectedImagesBase64 = base64Images.take(3).toList();
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image selection error: $e')),
    );
  }
 }


  Future<void> addRoom() async {
    if (_formKey.currentState!.validate()) {
      if (selectedRoomType == null || selectedRoomType!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a room type!')),
      );
      return;
    }
    if (_priceController.text.isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please enter the price!')),
  );
  return;
}
      if (selectedImagesBase64.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one image!')),
        );
        return;
      }
      

      setState(() {
        _isLoading = true;
      });

      try {
        double price = double.parse(_priceController.text);

        // Firestore'a odanın bilgilerini ekle
        await FirebaseFirestore.instance.collection('Rooms').add({
          'type': selectedRoomType,
          'price': price,
          'images': selectedImagesBase64,
          'availableFrom': DateTime.now(),
          'isAvailable': true,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room successfully added!')),
        );

        Navigator.pop(context); // Admin ana sayfasına yönlendirme
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding room: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openRoomTypeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Text(
            'Choose the room type',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                'Standart Room',
                'Suite Room',
                'Family Room',
              ].map((type) {
                return ListTile(
                  title: Text(
                    type,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    
                    setState(() {
                      selectedRoomType = type;
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
          const SizedBox(height: 100),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Add the Features of New Room',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 143, 115, 94),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Room Type
                      GestureDetector(
                        onTap: () {
                          _openRoomTypeSelectionDialog(context);
                        },
                        
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.brown),
                            color: Colors.white,
                          ),
                          child: Text(
                            selectedRoomType ?? 'Choose the type of the room',
                            style: TextStyle(
                              color: selectedRoomType == null ? Color.fromARGB(255, 143, 115, 94) : Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Price
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          label: const Text(
                            'Price in Euro',
                            style: TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),
                          ),
                          hintText: 'Enter Price',
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
                      const SizedBox(height: 20),
                      // Images
                      GestureDetector(
                        onTap: pickImages,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.brown),
                            color: Colors.white,
                          ),
                          child: Text(
                            selectedImagesBase64.isEmpty
                                ? 'Images of the Room (1-3)'
                                : '${selectedImagesBase64.length} image(s) selected',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      // Image preview
                      if (selectedImagesBase64.isNotEmpty) _buildImagePreview(),
                      const SizedBox(height: 20),
                      // Add Room Button
                      _buildAddRoomButton(),
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

  Widget _buildImagePreview() {
    return Wrap(
      spacing: 8.0,
      children: selectedImagesBase64
          .map((imageBase64) => Image.memory(
                base64Decode(imageBase64),
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ))
          .toList(),
    );
  }

 Widget _buildAddRoomButton() {
  return Center(
    child: _isLoading
        ? const CircularProgressIndicator()
        : SizedBox(
            width: double.infinity, // Butonun genişliğini ekranı kaplaması için
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 143, 115, 94),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0), // Köşeleri yuvarlatmak için
                ),
              ),
              onPressed: addRoom,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
  );
 }

}*/

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class AddRoomPage extends StatefulWidget {
  @override
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _roomNumberController = TextEditingController();

  List<String> selectedImagesBase64 = [];
  bool _isLoading = false;
  String? selectedRoomType;
  final Map<String, String?> roomFeatures = {
    "Air Conditioner": null,
    "Wi-Fi": null,
    "Double Bed": null,
    "Single Bed": null,
    "Kitchen": null,
    "Sitting Area": null,
  };

  Future<void> pickImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
      );

      if (result != null) {
        if (result.files.length > 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can select up to 3 images only!'),
            ),
          );
          return;
        }

        List<String> base64Images = [];

        for (var file in result.files) {
          if (file.bytes != null) {
            base64Images.add(base64Encode(file.bytes!));
          } else if (file.path != null) {
            File imageFile = File(file.path!);
            base64Images.add(base64Encode(await imageFile.readAsBytes()));
          }
        }

        if (base64Images.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No valid images were selected!'),
            ),
          );
          return;
        }

        setState(() {
          selectedImagesBase64 = base64Images.take(3).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image selection error: $e')),
      );
    }
  }

  Future<void> addRoom() async {
    if (_formKey.currentState!.validate()) {
      if (selectedRoomType == null || selectedRoomType!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a room type!')),
        );
        return;
      }

      if (_priceController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the price!')),
        );
        return;
      }

      if ( _roomNumberController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter room number!')),
        );
        return;
      }

      if (selectedImagesBase64.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one image!')),
        );
        return;
      }

      if (roomFeatures.values.any((value) => value == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please set all room features!')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        double price = double.parse(_priceController.text);
        int roomNumber = int.parse(_roomNumberController.text);

        await FirebaseFirestore.instance.collection('Rooms').add({
          'type': selectedRoomType,
          'price': price,
          'roomNumber': roomNumber,
          'features': roomFeatures,
          'images': selectedImagesBase64,
          'availableFrom': DateTime.now(),
          'isAvailable': true,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room successfully added!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding room: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openRoomTypeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: const Text(
            'Choose the room type',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                'Standart Room',
                'Suite Room',
                'Family Room',
                'Standart Room (sea view)',
                'Suite Room (sea view)',
                'Family Room (sea view)',
              ].map((type) {
                return ListTile(
                  title: Text(
                    type,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    setState(() {
                      selectedRoomType = type;
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

  void _setFeature(String feature, String value) {
    setState(() {
      roomFeatures[feature] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Add the Features of New Room',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 143, 115, 94),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          _openRoomTypeSelectionDialog(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.brown),
                            color: Colors.white,
                          ),
                          child: Text(
                            selectedRoomType ?? 'Choose the type of the room',
                            style: TextStyle(
                              color: selectedRoomType == null
                                  ? Color.fromARGB(255, 143, 115, 94)
                                  : Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          label: const Text(
                            'Price in Euro',
                            style: TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _roomNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          label: const Text(
                            'Room Number',
                            style: TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                       GestureDetector(
                        onTap: pickImages,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.brown),
                            color: Colors.white,
                          ),
                          child: Text(
                            selectedImagesBase64.isEmpty
                                ? 'Images of the Room (1-3)'
                                : '${selectedImagesBase64.length} image(s) selected',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                    
                      const SizedBox(height: 20),
                      
                      ...roomFeatures.keys.map((feature) => ListTile(
                            title: Text(feature),
                            trailing: DropdownButton<String>(
                              value: roomFeatures[feature],
                              hint: const Text('Choose',style: TextStyle(
                      fontSize: 14.0,
                      color:  const Color.fromARGB(255, 143, 115, 94) ,
                    ),),
                              items: ['Yes', 'No']
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              onChanged: (value) => _setFeature(feature, value!),
                            ),
                          )),
                      const SizedBox(height: 20),
                      if (selectedImagesBase64.isNotEmpty) _buildImagePreview(),
                      const SizedBox(height: 20),
                      _buildAddRoomButton(),
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

  Widget _buildImagePreview() {
    return Wrap(
      spacing: 8.0,
      children: selectedImagesBase64
          .map((imageBase64) => Image.memory(
                base64Decode(imageBase64),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ))
          .toList(),
    );
  }

  Widget _buildAddRoomButton() {
    
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator()
          : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 143, 115, 94),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: addRoom,
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
    );
  }
}


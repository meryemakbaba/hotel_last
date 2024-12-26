import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart';

class AddFoodPage extends StatefulWidget {
  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _foodNameController = TextEditingController();

  List<String> selectedImagesBase64 = [];
  bool _isLoading = false;

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
              content: Text('You can select up to 1 image only!'),
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
          selectedImagesBase64 = base64Images.take(1).toList();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image selection error: $e')),
      );
    }
  }

  Future<void> addFood() async {
    if (_formKey.currentState!.validate()) {
      if (_foodNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the Food Name!')),
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

        await FirebaseFirestore.instance.collection('Foods').add({
          'type': _foodNameController.text,
          'price': price,
          'images': selectedImagesBase64,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Food successfully added!')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding Food: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                          'Add the Food',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 143, 115, 94),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _foodNameController,
                        decoration: InputDecoration(
                          label: const Text(
                            'Food Name',
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
                                ? 'Images of the Food (1)'
                                : '${selectedImagesBase64.length} image(s) selected',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 143, 115, 94),
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (selectedImagesBase64.isNotEmpty) _buildImagePreview(),
                      const SizedBox(height: 20),
                      _buildAddFoodButton(),
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

  Widget _buildAddFoodButton() {
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
                onPressed: addFood,
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

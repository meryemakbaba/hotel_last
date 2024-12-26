import 'dart:convert'; // Fotoğrafları decode etmek için
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Import carousel_slider package
import 'package:serenadepalace/screens/rezervation.dart';
import 'package:serenadepalace/widgets/custom_scaffold.dart'; // CustomScaffold import

class SecondPage extends StatefulWidget {
  final dynamic room;

  const SecondPage({Key? key, required this.room}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  late List<dynamic> imagesBase64; // Image list from Firebase
  late Map<String, dynamic> features; // Room features from Firebase

  @override
  void initState() {
    super.initState();
    imagesBase64 = widget.room['images']; // Get the images from Firebase
    features = widget.room['features']; // Get the features from Firebase
  }

  IconData getFeatureIcon(String key) {
    // Match feature keys to appropriate icons
    switch (key.toLowerCase()) {
      case 'air conditioner':
        return Icons.ac_unit;
      case 'double bed':
        return Icons.bed;
      case 'kitchen':
        return Icons.kitchen;
      case 'single bed':
        return Icons.single_bed;
      case 'sitting area':
        return Icons.chair;
      case 'wi-fi':
        return Icons.wifi;
      default:
        return Icons.info; // Default icon for unknown features
    }
  }

  @override
  Widget build(BuildContext context) {
    String type = widget.room['type'];
    double price = (widget.room['price'] as num).toDouble();

    return CustomScaffold(
      child: Column(
        children: [
          // White container with heading and room details
          Expanded(
            flex: 7,
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
                children: [
                  // Room title and price
                  Text(
                    'Room Type: $type',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Price: £ ${price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 20),

                  // CarouselSlider for image gallery with auto-play and resizing
                  CarouselSlider.builder(
                    itemCount: imagesBase64.length,
                    itemBuilder: (context, index, realIndex) {
                      return GestureDetector(
                        onTap: () {
                          // Show image in full-screen dialog when tapped
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: Stack(
                                children: [
                                  Image.memory(
                                    base64Decode(imagesBase64[index]),
                                    fit: BoxFit.contain,
                                  ),
                                  // Close button
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: const Icon(Icons.close, size: 30, color: Colors.black),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            base64Decode(imagesBase64[index]),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover, // Resize image using BoxFit.cover
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      enlargeCenterPage: true, // Enlarge center page
                      enableInfiniteScroll: true, // Enable infinite scroll for the carousel
                      autoPlay: true, // Enable auto-play for automatic image rotation
                      autoPlayInterval: const Duration(seconds: 3), // Set the interval for auto-play
                      autoPlayAnimationDuration: const Duration(milliseconds: 800), // Set the animation duration
                      viewportFraction: 1.0, // Make sure the carousel takes up full width
                      height: 300.0, // Set the height of the carousel
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Room features displayed in a wider box with icons
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 143, 115, 94),
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: features.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(
                                getFeatureIcon(entry.key), // Get the appropriate icon
                                color: const Color.fromARGB(255, 143, 115, 94),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${entry.key}: ${entry.value}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 143, 115, 94),
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Price and booking button
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '£ ${price.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (e) => RezervationScreen(room: widget.room),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 143, 115, 94),
                          ),
                          child: const Text(
                            'Reserve Now',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



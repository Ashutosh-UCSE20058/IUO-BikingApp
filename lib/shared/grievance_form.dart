import 'dart:io';
import 'package:betterroute/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:betterroute/providers/location_provider.dart';

class GrievanceForm extends StatefulWidget {
  final String grievanceType;
  final String grievanceDescription;

  final String routeId;
  const GrievanceForm(
      {super.key,
      required this.grievanceType,
      required this.grievanceDescription,
      required this.routeId});

  @override
  State<GrievanceForm> createState() => _GrievanceFormState();
}

class _GrievanceFormState extends State<GrievanceForm> {
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  String _imageUrl = '';
  GeoPoint _location = const GeoPoint(0, 0);
  bool _isSubmitting = false;
  bool _isUploading = false;

  Future<void> _getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        maxHeight: 200,
        maxWidth: 200);

    if (pickedFile != null) {
      setState(() {
        _isUploading = true;
      });
      try {
        final reference = FirebaseStorage.instance
            .ref()
            .child('images_${widget.routeId}/${DateTime.now()}');
        final task = reference.putFile(File(pickedFile.path));
        await task.whenComplete(() {});
        final downloadUrl = await reference.getDownloadURL();

        setState(() {
          _imageUrl = downloadUrl;
          _isUploading = false;
        });
      } catch (e) {
        setState(() {
          _isUploading = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: const Text(
                      'An error occurred while uploading the image.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
      }
    }
  }

  Future<void> _submitForm(String routeId) async {
    try {
      setState(() {
        _isSubmitting = true;
      });
      // Create a new Firestore document with the form data
      final grief = {
        'type': widget.grievanceType,
        'comment': _commentController.text,
        'imageUrl': _imageUrl,
        'location': {
          'latitude': _location.latitude,
          'longitude': _location.longitude
        },
        'desc': widget.grievanceDescription,
        'createdAt': FieldValue.serverTimestamp()
      };
      await FirebaseFirestore.instance
          .collection('grievances')
          .doc(routeId)
          .collection('griefs')
          .add(grief);
      await FirestoreService().updateGrievanceReport();
      await Provider.of<LocationProvider>(context, listen: false)
          .updateGriefCount();
      // Clear the form fields after submitting
      _textFieldController.clear();
      _commentController.clear();
      _imageUrl = '';
      _location = const GeoPoint(0, 0);
      // Close the bottom modal sheet
      setState(() {
        _isSubmitting = false;
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An error occurred while submitting the form.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _location = GeoPoint(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    _textFieldController.text = widget.grievanceDescription;
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isSubmitting || _isUploading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 48.0),
                  TextFormField(
                    controller: _textFieldController,
                    enabled: false,
                    decoration: InputDecoration(
                        labelText: 'Grievance Type',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _commentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Comments',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _getImageFromCamera,
                    child: Text('Take a photo'),
                  ),
                  SizedBox(height: 16.0),
                  Text('image URL: $_imageUrl'),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => _submitForm(widget.routeId),
                    child: Text('Submit'),
                  ),
                ],
              )),
        ),
        Positioned(
          top: 20,
          right: 15,
          child: IconButton(
            icon: Icon(FontAwesomeIcons.windowClose),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ));
  }
}

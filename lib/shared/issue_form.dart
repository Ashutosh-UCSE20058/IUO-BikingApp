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

class IssueForm extends StatefulWidget {
  final List<dynamic> issueList;
  final String issueType;
  final String issueColor;
  final String routeId;
  const IssueForm({
    super.key,
    required this.issueList,
    required this.issueType,
    required this.issueColor,
    required this.routeId,
  });

  @override
  State<IssueForm> createState() => _IssueFormState();
}

class _IssueFormState extends State<IssueForm> {
  final TextEditingController _commentController = TextEditingController();
  String _imageUrl = '';
  GeoPoint _location = const GeoPoint(0, 0);
  List<String> selectedIssues = [];
  late List<bool> _isSelected;
  bool _isUploading = false;
  bool _isSubmitting = false;

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
                  content: Text('An error occurred while uploading the image'),
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

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _location = GeoPoint(position.latitude, position.longitude);
    });
  }

  Future<void> _submitForm(String routeId) async {
    try {
      setState(() {
        _isSubmitting = true;
      });
      // Create a new Firestore document with the form data
      await _getCurrentLocation();
      final grief = {
        'type': widget.issueType,
        'comment': _commentController.text,
        'imageUrl': _imageUrl,
        'location': {
          'latitude': _location.latitude,
          'longitude': _location.longitude
        },
        'issueList': selectedIssues,
        'issueColor': widget.issueColor,
        'createdAt': FieldValue.serverTimestamp()
      };
      await FirebaseFirestore.instance
          .collection('grievances')
          .doc(routeId)
          .collection('griefs')
          .add(grief);
      await FirestoreService().updateGrievanceReport();
      await FirestoreService().updateLastGrievanceAddedUser();
      await Provider.of<LocationProvider>(context, listen: false)
          .updateGriefCount();
      // Clear the form fields after submitting
      _commentController.clear();
      _imageUrl = '';
      _location = const GeoPoint(0, 0);
      selectedIssues = [];
      // Close the bottom modal sheet
      setState(() {
        _isSubmitting = true;
      });
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: Text("An error occurred while submitting the form"),
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

  Future<bool> _onWillPopForm() async {
    if (_isSubmitting || _isUploading) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _isSelected = List<bool>.filled(widget.issueList.length, false);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPopForm,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('Report Issue'),
              backgroundColor: Colors.black.withOpacity(0.5),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              "Issue Type:",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 5),
                            Text(widget.issueType,
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 20),
                            const Text("Choose Issues:",
                                style: TextStyle(fontSize: 14)),
                            SizedBox(
                              height: 5,
                            ),
                            ToggleButtons(
                              children: widget.issueList
                                  .map(
                                      (issue) => Text(issue["desc"].toString()))
                                  .toList(),
                              isSelected: _isSelected,
                              onPressed: (int index) {
                                setState(() {
                                  _isSelected[index] = !_isSelected[index];
                                  if (_isSelected[index]) {
                                    selectedIssues
                                        .add(widget.issueList[index]["desc"]);
                                  } else {
                                    selectedIssues.remove(
                                        widget.issueList[index]["desc"]);
                                  }
                                });
                              },
                              selectedColor: Colors.white,
                              fillColor: Colors.orange,
                              borderRadius: BorderRadius.circular(2.0),
                              direction: Axis.vertical,
                              borderColor: Colors.grey,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            const Text("Add comments:",
                                style: TextStyle(fontSize: 14)),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _commentController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Comments',
                                focusColor: Colors.orange,
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "Add Image:",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () => _getImageFromCamera(),
                                    iconSize: 48,
                                    color: Colors.black.withOpacity(0.5),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    icon:
                                        Icon(FontAwesomeIcons.solidPlusSquare)),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            const Text("Image URL:"),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    _imageUrl,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ]),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          backgroundColor: Colors.orange),
                      onPressed: () => _submitForm(widget.routeId),
                      child: const Text(
                        "SUBMIT",
                        style: TextStyle(fontSize: 20),
                      )),
                )
              ],
            ),
          ),
          if (_isSubmitting || _isUploading)
            const Opacity(
              opacity: 0.8,
              child: ModalBarrier(dismissible: false, color: Colors.black),
            ),
          if (_isSubmitting || _isUploading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            ),
        ],
      ),
    );
  }
}

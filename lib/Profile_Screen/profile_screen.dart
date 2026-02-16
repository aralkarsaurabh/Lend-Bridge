import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final uidController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final stateController = TextEditingController();
  final panCardController = TextEditingController();
  final aadharCardController = TextEditingController();

  bool isLoading = false;

  bool isPanUploaded = false;
  bool isAadharUploaded = false;

  User? user;

  Map<String, dynamic>? data;

  PlatformFile? panCardFile;
  PlatformFile? aadharCardFile;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  Future<void> getCurrentUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentSnapshot? snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (snapshot.exists) {
          data = snapshot.data() as Map<String, dynamic>;

          nameController.text = data?['name'] ?? 'Name is not available';
          emailController.text = data?['email'] ?? 'Email is not available';
          phoneController.text = data?['phone'] ?? 'Phone is not available';
          uidController.text = currentUser.uid;
          addressLine1Controller.text =
              data?['address_line_1'] ?? 'Address line 1 is not available';
          addressLine2Controller.text =
              data?['address_line_2'] ?? 'Address line 2 is not available';
          cityController.text = data?['city'] ?? 'City is not available';
          pinCodeController.text =
              data?['pin_code'] ?? 'PIN Code is not available';
          stateController.text = data?['state'] ?? 'State is not available';

          final panMap = data?['pan_card'];

          if (panMap != null && panMap is Map<String, dynamic>) {
            isPanUploaded = true;

            panCardController.text =
                panMap['fileName'] as String? ?? 'Pan card uploaded';
          }

          final aadharMap = data?['aadhar_card'];

          if (aadharMap != null && aadharMap is Map<String, dynamic>) {
            isAadharUploaded = true;

            aadharCardController.text =
                aadharMap['fileName'] as String? ?? 'Aadhar card uploaded';
          }
        }

        setState(() {
          isLoading = false;
          user = currentUser;
        });
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? panCardUrl;
      String? aadharCardUrl;

      if (!isPanUploaded && panCardFile != null) {
        panCardUrl = await uploadFileToStorage(panCardFile!, 'pan_cards');
      }

      if (!isAadharUploaded && aadharCardFile != null) {
        aadharCardUrl = await uploadFileToStorage(
          aadharCardFile!,
          'aadhar_cards',
        );
      }

      Map<String, dynamic> updateData = {
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'address_line_1': addressLine1Controller.text.trim(),
      'address_line_2': addressLine2Controller.text.trim(),
      'city': cityController.text.trim(),
      'pin_code': pinCodeController.text.trim(),
      'state': stateController.text.trim(),
      'updatedAt': DateTime.now()
    };

    if (!isPanUploaded && panCardUrl != null && panCardFile != null) {
      updateData['pan_card'] = {
        'fileName': panCardFile!.name,
        'downloadUrl': panCardUrl,
        'uploadedAt': DateTime.now(),
      };
    }

    if (!isAadharUploaded && aadharCardUrl != null && aadharCardFile != null) {
      updateData['aadhar_card'] = {
        'fileName': aadharCardFile!.name,
        'downloadUrl': aadharCardUrl,
        'uploadedAt': DateTime.now(),
      };
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .update(updateData);

    setState(() {
      isLoading = false;
      if (panCardUrl != null) isPanUploaded = true;
      if (aadharCardUrl != null) isAadharUploaded = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Data Uploaded Successfully')));
  } catch (e) {
    debugPrint("$e");

    setState(() {
    isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  Future<String?> uploadFileToStorage(PlatformFile file, String folder) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final timestamp = DateTime
          .now()
          .millisecondsSinceEpoch;
      final fileRef = storageRef.child(
        '$folder/${user!.uid}_${timestamp}_${file.name}',
      );

      if (file.path != null) {
        await fileRef.putFile(File(file.path!));
      } else if (file.bytes != null) {
        await fileRef.putData(file.bytes!);
      } else {
        debugPrint('File has neither path nor bytes');
        return null;
      }

      final downloadUrl = await fileRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    uidController.dispose();
    super.dispose();
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: isLoading
            ? CircularProgressIndicator(color: Colors.black)
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,

                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    border: Border.all(width: 2, color: Colors.grey),
                  ),

                  child: Icon(Icons.person, color: Colors.grey, size: 80),
                ),

                SizedBox(height: 30),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    TextField(
                      controller: nameController,

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,

                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.grey,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    TextField(
                      readOnly: true,

                      controller: emailController,

                      style: TextStyle(color: Colors.grey),

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,

                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: Colors.grey,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Phone',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    TextField(
                      controller: phoneController,

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,

                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: Colors.grey,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'UID',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    TextField(
                      readOnly: true,

                      controller: uidController,

                      style: TextStyle(color: Colors.grey),

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,

                        prefixIcon: Icon(
                          Icons.security_outlined,
                          color: Colors.grey,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Address Line 1',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    TextField(
                      controller: addressLine1Controller,

                      style: TextStyle(color: Colors.black),

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,

                        prefixIcon: Icon(
                          Icons.short_text_outlined,
                          color: Colors.grey,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Address Line 2',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    TextField(
                      controller: addressLine2Controller,

                      style: TextStyle(color: Colors.black),

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,

                        prefixIcon: Icon(
                          Icons.short_text_outlined,
                          color: Colors.grey,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'City',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    TextField(
                      controller: cityController,

                      style: TextStyle(color: Colors.black),

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,

                        prefixIcon: Icon(
                          Icons.location_city_outlined,
                          color: Colors.grey,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'PIN Code',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    TextField(
                      controller: pinCodeController,

                      style: TextStyle(color: Colors.black),

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,

                        prefixIcon: Icon(
                          Icons.fiber_pin,
                          color: Colors.grey,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'State',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    TextField(
                      controller: stateController,

                      style: TextStyle(color: Colors.black),

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,

                        prefixIcon: Icon(
                          Icons.local_activity_outlined,
                          color: Colors.grey,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Upload PAN Card',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            readOnly: true,

                            controller: panCardController,

                            style: TextStyle(color: Colors.grey),

                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,

                              prefixIcon: Icon(
                                Icons.attach_file_outlined,
                                color: Colors.grey,
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 5),

                        if (!isPanUploaded)
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),

                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,

                                minimumSize: Size(double.infinity, 54),
                              ),

                              onPressed: () async {
                                final result = await FilePicker.platform
                                    .pickFiles();

                                if (result == null) return;

                                setState(() {
                                  panCardFile = result.files.first;
                                  panCardController.text =
                                      panCardFile!.name;
                                });
                              },
                              child: isLoading
                                  ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                'Select File',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                      ],
                    ),

                    if (panCardFile != null)
                      Text(
                        '${panCardFile!.extension?.toUpperCase() ??
                            "Unknown"} • ${_formatBytes(panCardFile!.size)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),

                    SizedBox(height: 20),

                    Text(
                      'Upload Aadhar Card',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 8),

                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            readOnly: true,

                            controller: aadharCardController,

                            style: TextStyle(color: Colors.grey),

                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,

                              prefixIcon: Icon(
                                Icons.attach_file_outlined,
                                color: Colors.grey,
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 5),

                        if (!isAadharUploaded)
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),

                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,

                                minimumSize: Size(double.infinity, 54),
                              ),

                              onPressed: () async {
                                final result = await FilePicker.platform
                                    .pickFiles();

                                if (result == null) return;

                                setState(() {
                                  aadharCardFile = result.files.first;
                                  aadharCardController.text =
                                      aadharCardFile!.name;
                                });
                              },
                              child: isLoading
                                  ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                'Select File',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                      ],
                    ),

                    if (aadharCardFile != null)
                      Text(
                        '${aadharCardFile!.extension?.toUpperCase() ??
                            "Unknown"} • ${_formatBytes(aadharCardFile!.size)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),

                    SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),

                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,

                        minimumSize: Size(double.infinity, 54),
                      ),

                      onPressed: () async {
                        isLoading ? null : await updateProfile();
                      },
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Update Profile',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

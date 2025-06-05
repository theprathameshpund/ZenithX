import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  String _fullName = '';
  String _email = '';
  String _contactNumber = '';
  File? _profileImage;
  bool _isEditing = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    }
    return {};
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        if (_formKey.currentState?.validate() ?? false) {
          _formKey.currentState?.save();
          _updateUserData();
        }
      }
      _isEditing = !_isEditing;
    });
  }

  Future<void> _updateUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fullName': _fullName,
        'contactNumber': _contactNumber,
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            _fullName = snapshot.data!['fullName'] ?? '';
            _email = snapshot.data!['email'] ?? '';
            _contactNumber = snapshot.data!['contactNumber'] ?? '';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _isEditing ? _pickImage : null,
                      child: CircleAvatar(
                        radius: 80, // Large profile picture
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        backgroundColor: Colors.purple[300],
                        child: _profileImage == null
                            ? Text(
                          _fullName.isNotEmpty
                              ? _fullName[0].toUpperCase()
                              : '',
                          style: const TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                          ),
                        )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // if (_isEditing)
                    //   TextButton(
                    //     onPressed: _pickImage,
                    //     child: const Text('Edit picture or avatar'),
                    //   ),
                    const SizedBox(height: 20),
                    Text(
                      _fullName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   'Artist', // Static label for role/occupation
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Colors.grey[600],
                    //   ),
                    // ),
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: TextFormField(
                              initialValue: _email,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: InputBorder.none,
                              ),
                              enabled: false,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: TextFormField(
                              initialValue: _contactNumber,
                              decoration: const InputDecoration(
                                labelText: 'Contact No.',
                                border: InputBorder.none,
                              ),
                              onSaved: (value) {
                                _contactNumber = value!;
                              },
                              enabled: _isEditing,
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: TextFormField(
                              initialValue: _fullName,
                              decoration: const InputDecoration(
                                labelText: 'Full Name',
                                border: InputBorder.none,
                              ),
                              onSaved: (value) {
                                _fullName = value!;
                              },
                              enabled: _isEditing,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

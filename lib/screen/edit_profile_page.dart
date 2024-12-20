import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../models/user_profile.dart';
import '../services/config.dart';
import '../services/profile_services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> {
  late Future<UserProfile> _userProfile;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _birthPlaceController;
  late TextEditingController _birthDateController;
  late TextEditingController _addressController;
  String? _selectedGender;
  File? _profileImage;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _userProfile = _fetchUserProfile();
  }

  Future<UserProfile> _fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? kodePengguna = prefs.getString('kode_pengguna');
    if (kodePengguna == null) {
      throw Exception('Kode pengguna tidak ditemukan');
    }

    final profileData = await ProfileService().fetchUserProfile(kodePengguna);
    final userProfile = UserProfile.fromJson(profileData);

    _initializeControllers(userProfile);
    return userProfile;
  }

  void _initializeControllers(UserProfile userProfile) {
    _nameController = TextEditingController(text: userProfile.name);
    _emailController = TextEditingController(text: userProfile.email);
    _phoneNumberController = TextEditingController(text: userProfile.phoneNumber);
    _birthPlaceController = TextEditingController(text: userProfile.birthPlace);
    _birthDateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(userProfile.birthDate));
    _addressController = TextEditingController(text: userProfile.address);
    _selectedGender = userProfile.gender == '1' ? 'Laki-laki' : 'Perempuan';
    _profileImageUrl = userProfile.profileImageUrl;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showToast(String message, {ToastGravity gravity = ToastGravity.BOTTOM, Color backgroundColor = Colors.red}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(_birthDateController.text);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? kodePengguna = prefs.getString('kode_pengguna');
      if (kodePengguna == null) {
        _showToast('Kode pengguna tidak ditemukan');
        return;
      }

      UserProfile updatedProfile = UserProfile(
        profileImageUrl: _profileImageUrl ?? '',
        code: kodePengguna,
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneNumberController.text,
        birthPlace: _birthPlaceController.text,
        birthDate: parsedDate,
        gender: _selectedGender == 'Laki-laki' ? '1' : '2',
        address: _addressController.text,
      );

      await ProfileService().updateUserProfile(updatedProfile, _profileImage);
      _showToast('Profil berhasil diperbarui', backgroundColor: Colors.green);

      if (_profileImage != null) {
        setState(() {
          _profileImageUrl = updatedProfile.profileImageUrl;
        });
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      _showToast('Gagal memperbarui profil: $e');
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _userProfile = _fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder<UserProfile>(
          future: _userProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Tidak ada data pengguna'));
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildProfileImage(),
                        const SizedBox(height: 20),
                        _buildTextField('Nama', _nameController, Icons.person),
                        _buildTextField('Email', _emailController, Icons.email),
                        _buildTextField('No. Telp', _phoneNumberController, Icons.phone),
                        _buildTextField('Tempat Lahir', _birthPlaceController, Icons.location_city),
                        _buildTextField('Tanggal Lahir', _birthDateController, Icons.cake),
                        _buildGenderDropdown(),
                        _buildTextField('Alamat', _addressController, Icons.home),
                        const SizedBox(height: 20),
                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 70,
        backgroundImage: _profileImage != null
            ? FileImage(_profileImage!)
            : NetworkImage('${Config.imageProfileUrl}/$_profileImageUrl') as ImageProvider,
        child: _profileImage == null
            ? Icon(
                Icons.camera_alt,
                color: Colors.white.withOpacity(0.6),
                size: 40,
              )
            : null,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label tidak boleh kosong';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: const Icon(Icons.wc, color: Colors.deepPurple),
        title: DropdownButtonFormField<String>(
          value: _selectedGender,
          items: const [
            DropdownMenuItem(
              value: 'Laki-laki',
              child: Text('Laki-laki'),
            ),
            DropdownMenuItem(
              value: 'Perempuan',
              child: Text('Perempuan'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Jenis Kelamin',
            border: InputBorder.none,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Jenis Kelamin tidak boleh kosong';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveProfile,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5.0,
      ),
      child: const Text(
        'Simpan Perubahan',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

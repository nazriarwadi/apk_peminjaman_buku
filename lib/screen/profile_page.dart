import 'package:aplikasi_pustaka/services/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/user_profile.dart';
import '../services/profile_services.dart';
import 'edit_profile_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late Future<UserProfile?> _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfile = _fetchUserProfile();
  }

  Future<UserProfile?> _fetchUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? kodePengguna = prefs.getString('kode_pengguna');
    if (kodePengguna == null) {
      // Show toast notification for the missing user
      Fluttertoast.showToast(
        msg: 'Data profil tidak bisa ditampilkan karena Anda belum login.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // Return null if the user is not logged in
      return null;
    }

    // Fetch profile data from the service
    final profileData = await ProfileService().fetchUserProfile(kodePengguna);

    // Convert the profile data to UserProfile
    return UserProfile.fromJson(profileData);
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

  Future<void> _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('kode_pengguna');

      _showToast('Berhasil logout', backgroundColor: Colors.green);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      _showToast('Gagal logout: $e');
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
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder<UserProfile?>(
          future: _userProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'Data profil tidak bisa ditampilkan karena Anda belum login.',
                  style: TextStyle(fontSize: 18, color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return _buildProfileContent(snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Profile', style: TextStyle(color: Colors.white)),
      centerTitle: true,
      backgroundColor: Colors.deepPurple,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildProfileContent(UserProfile userProfile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(userProfile),
          const SizedBox(height: 20),
          _buildProfileDetails(userProfile),
          const SizedBox(height: 20),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserProfile userProfile) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage('${Config.imageProfileUrl}/${userProfile.profileImageUrl}'),
          ),
          const SizedBox(height: 10),
          Text(
            userProfile.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            userProfile.email,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(UserProfile userProfile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildProfileField(Icons.person, 'Kode', userProfile.code),
          _buildProfileField(Icons.phone, 'No. Telp', userProfile.phoneNumber),
          _buildProfileField(Icons.location_city, 'Tempat Lahir', userProfile.birthPlace),
          _buildProfileField(Icons.cake, 'Tanggal Lahir', '${userProfile.birthDate.day}/${userProfile.birthDate.month}/${userProfile.birthDate.year}'),
          _buildProfileField(Icons.wc, 'Jenis Kelamin', userProfile.gender == '1' ? 'Laki-laki' : 'Perempuan'),
          _buildProfileField(Icons.home, 'Alamat', userProfile.address),
        ],
      ),
    );
  }

  Widget _buildProfileField(IconData icon, String label, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildEditProfileButton(),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  ElevatedButton _buildEditProfileButton() {
    return ElevatedButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfilePage()),
        );
        if (result == true) {
          setState(() {
            _userProfile = _fetchUserProfile();
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5.0,
      ),
      child: const Text(
        'Edit Profile',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  ElevatedButton _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _logout,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5.0,
      ),
      child: const Text(
        'Logout',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
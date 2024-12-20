import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../models/user_profile.dart';
import 'config.dart'; // Import Config

class ProfileService {
  Future<Map<String, dynamic>> fetchUserProfile(String kodePengguna) async {
    final response = await http.get(
      Uri.parse('${Config.apiBaseUrl}/get_profile.php?kode_anggota=$kodePengguna'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic>) {
        return jsonResponse;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<void> updateUserProfile(UserProfile userProfile, File? profileImage) async {
    final uri = Uri.parse('${Config.apiBaseUrl}/update_edit_profile.php');
    final request = http.MultipartRequest('POST', uri);

    // Add fields from userProfile.toJson()
    final fields = userProfile.toJson();
    fields.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // Add image if it exists
    if (profileImage != null) {
      final imageStream = http.ByteStream(profileImage.openRead());
      final length = await profileImage.length();

      final multipartFile = http.MultipartFile(
        'profile_image',
        imageStream,
        length,
        filename: profileImage.path.split('/').last,
      );

      request.files.add(multipartFile);
    }

    // Send request
    final response = await request.send();

    // Handle response
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }

    final responseData = await response.stream.bytesToString();
    final jsonResponse = json.decode(responseData);

    if (jsonResponse['status'] != 'success') {
      throw Exception(jsonResponse['message']);
    }
  }
}

// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Tambahkan import ini
import '../models/user_model.dart';
import '../services/registrasi_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool _isObscure = true;
  bool _isLoading = false; // To handle loading state

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegisterService _registerService = RegisterService();

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

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<void> _register() async {
    String name = _nameController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String email = _emailController.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (_validateInputs(name, phoneNumber, email, username, password)) {
      setState(() {
        _isLoading = true; // Start loading
      });

      RegisterRequest request = RegisterRequest(
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        username: username,
        password: password,
      );

      try {
        var response = await _registerService.register(request);
        print('Register response: $response'); // Debug log

        if (response.containsKey('message') && response['message'] == 'Registrasi berhasil') {
          _showToast('Registrasi berhasil! Silakan login untuk melanjutkan.', backgroundColor: Colors.green);
          Future.delayed(const Duration(seconds: 1), () {
            _navigateToLogin();
          });
        } else {
          String errorMessage = response['message'] ?? 'Gagal melakukan registrasi. Silakan coba lagi.';
          _showToast(errorMessage);
        }
      } catch (e) {
        _showToast('Failed to register: $e');
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    } else {
      _showToast('Mohon lengkapi semua kolom');
    }
  }

  bool _validateInputs(String name, String phone, String email, String username, String password) {
    // Simple validation for empty fields
    return name.isNotEmpty && phone.isNotEmpty && email.isNotEmpty && username.isNotEmpty && password.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[700],
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Please sign up to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.deepPurple[700],
                ),
              ),
              const SizedBox(height: 60.0),
              _buildTextField(controller: _nameController, label: 'Nama', icon: Icons.account_circle_rounded),
              const SizedBox(height: 20.0),
              _buildTextField(controller: _phoneController, label: 'Nomor Telp', icon: Icons.phone_android_rounded, keyboardType: TextInputType.phone),
              const SizedBox(height: 20.0),
              _buildTextField(controller: _emailController, label: 'Email', icon: Icons.email, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 20.0),
              _buildTextField(controller: _usernameController, label: 'Username', icon: Icons.account_circle_rounded),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: _isObscure,
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _register, // Disable button when loading
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  elevation: 5.0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.name,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}

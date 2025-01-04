import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paybiz/core/app/routes.dart';
import 'package:paybiz/services/auth_service.dart';
import 'package:paybiz/ui/theme/colors.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String? selectedProvince;

  // Controllers for all fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cellNumberController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _suburbController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();

  final List<String> province = [
    'Gauteng',
    'Western Cape',
    'Free State',
    'Northern Cape',
    'Kwazulu-Natal',
    'Limpopo',
    'Mpummalanga',
    'North West',
    'Eastern Cape',
  ];

  String _accountNumber = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _accountNumber = _generateAccountNumber();
  }

  @override
  void dispose() {
    // Dispose controllers
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cellNumberController.dispose();
    _provinceController.dispose();
    _suburbController.dispose();
    _cityController.dispose();
    _streetNumberController.dispose();
    _streetNameController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  String _generateAccountNumber() {
    final random = Random();
    return '${random.nextInt(9) + 1}' +
        List.generate(9, (_) => random.nextInt(10)).join();
  }

  void _signup(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });
      final String  province = selectedProvince!;

      try {
        await AuthService().signup(
          accountNumber: _accountNumber,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          cellNumber: _cellNumberController.text.trim(),
          email: _emailController.text.trim(),
          province: province,
          suburb: _suburbController.text.trim(),
          city: _cityController.text.trim(),
          streetNumber: _streetNumberController.text.trim(),
          streetName: _streetNameController.text.trim(),
          idNumber: _idNumberController.text.trim(),
          password: _passwordController.text.trim(),
          context: context,
          initialBalance: 1000,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signup successful!')),
        );
        Navigator.pushNamed(context, Routes.login);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 50,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Register Account',
                    style: GoogleFonts.raleway(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _textField('First Name', _firstNameController,
                    'Enter your first name'),
                _textField(
                    'Last Name', _lastNameController, 'Enter your last name'),
                _textField('Cell Number', _cellNumberController,
                    'Enter your cell number',
                    keyboardType: TextInputType.phone),
                _textField(
                    'Email Address', _emailController, 'example@gmail.com',
                    keyboardType: TextInputType.emailAddress),
                _passwordField(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Province",
                        style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedProvince,
                    items: province
                        .map((bank) => DropdownMenuItem(
                              value: bank,
                              child: Text(bank),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProvince = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select Privince',
                      hintStyle: TextStyle(color: AppColors.grey4),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a province';
                      }
                      return null;
                    },
                  ),
                ),
                _textField('Suburb', _suburbController, 'Enter your suburb'),
                _textField('City', _cityController, 'Enter your city'),
                _textField('Street Number', _streetNumberController,
                    'Enter your street number'),
                _textField('Street Name', _streetNameController,
                    'Enter your street name'),
                _textField(
                    'ID Number', _idNumberController, 'Enter your ID number'),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0D6EFD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size(double.infinity, 60),
                          elevation: 0,
                        ),
                        onPressed: () => _signup(context),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller, String hint,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.raleway(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xff6A6A6A),
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
            fillColor: const Color(0xffF7F7F9),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _passwordField() {
    return _textField('Password', _passwordController, 'Enter your password',
        keyboardType: TextInputType.visiblePassword);
  }
}

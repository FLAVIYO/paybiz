// 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paybiz/core/app/routes.dart';
import 'package:paybiz/services/transfer_service.dart';
import 'package:paybiz/ui/theme/colors.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedBank;
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _beneficiaryReferenceController =
      TextEditingController();
  final TextEditingController _myReferenceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<String> banks = ['FNB', 'Standard Bank', 'ABSA', 'Nedbank'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Funds'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bank',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedBank,
                  items: banks
                      .map((bank) => DropdownMenuItem(
                            value: bank,
                            child: Text(bank),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBank = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select Bank',
                    hintStyle: TextStyle(color: AppColors.grey),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a bank';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _accountNameController,
                  label: 'Account Name',
                  hint: 'Enter Account Name',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _accountNumberController,
                  label: 'Account Number',
                  hint: 'Enter Account Number',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _beneficiaryReferenceController,
                  label: 'Beneficiary Reference',
                  hint: 'Enter Beneficiary Reference',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _myReferenceController,
                  label: 'My Reference',
                  hint: 'Enter Your Reference',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _amountController,
                  label: 'Amount',
                  hint: 'Enter Amount',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0D6EFD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      minimumSize: const Size(double.infinity, 60),
                      elevation: 0,
                    ),
                    onPressed: _submitTransfer,
                    child: const Text(
                      'Transfer',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      style: GoogleFonts.robotoFlex(color: AppColors.black),
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.black),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  void _submitTransfer() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String bank = selectedBank!;
      final String accountName = _accountNameController.text.trim();
      final String accountNumber = _accountNumberController.text.trim();
      final String beneficiaryReference =
          _beneficiaryReferenceController.text.trim();
      final String myReference = _myReferenceController.text.trim();
      final double amount = double.tryParse(_amountController.text.trim()) ?? 0;

      final transferService = TransferService();

      try {
        print("Form is valid, proceeding with transfer");

        //* Get the current user's account number
        final String senderAccountNumber = await _getCurrentUserAccountNumber();
        print("Sender Account Number: $senderAccountNumber");

        // Call the transfer service
        await transferService.transferFunds(
          senderAccountNumber: senderAccountNumber,
          recipientAccountNumber: accountNumber,
          amount: amount,
          bank: bank,
          senderReference: myReference,
          recipientReference: beneficiaryReference,
          context: context,
        );

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transfer successful!')),
        );

        // Clear the form
        _formKey.currentState?.reset();
        setState(() {
          selectedBank = null;
        });

        // Navigate back to HomeScreen
        Navigator.pushReplacementNamed(context, Routes.home);
      } catch (e) {
        print("Error occurred during transfer: $e");

        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transfer failed: $e')),
        );
      }
    }
  }

  Future<String> _getCurrentUserAccountNumber() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      print("User is logged in: ${user.uid}");

      // Fetch the user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Check if the document exists
      if (userDoc.exists) {
        print("User Document: ${userDoc.data()}");

        // Ensure the accountNumber field exists in the document
        if (userDoc.data() != null &&
            userDoc.data()!.containsKey('accountNumber')) {
          return userDoc['accountNumber'];
        } else {
          throw Exception('Account number not found in user document');
        }
      } else {
        throw Exception('User document does not exist');
      }
    }

    throw Exception('User not found');
  }
}

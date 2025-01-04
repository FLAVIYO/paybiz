
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paybiz/ui/theme/colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Stream to fetch user details from Firestore
  Stream<DocumentSnapshot> getUserDetails(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // Get current user's userId (from Firebase Auth)
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
       appBar: AppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.robotoFlex(color: AppColors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: getUserDetails(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No user data found.'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Container(
            decoration: const BoxDecoration(
             color: AppColors.lightBackground
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Details Card
                    Center(
                      child: Container(
                        height: 150.h,
                        width: 300.w,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4E54C8), Color(0xFF8F94FB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userData['firstName']} ${userData['lastName']}',
                              style: GoogleFonts.robotoFlex(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Account Number: ${userData['accountNumber']}',
                              style: GoogleFonts.robotoFlex(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Profile Details List
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ProfileDetailItem(
                              icon: Icons.email,
                              label: 'Email',
                              value: userData['email'] ?? '',
                            ),
                            ProfileDetailItem(
                              icon: Icons.phone,
                              label: 'Phone Number',
                              value: userData['cellNumber'] ?? '',
                            ),
                            ProfileDetailItem(
                              icon: Icons.cake,
                              label: 'Date of Birth',
                              value: userData['dob'] ?? '',
                            ),
                            ProfileDetailItem(
                              icon: Icons.location_city,
                              label: 'City',
                              value: userData['city'] ?? '',
                            ),
                            ProfileDetailItem(
                              icon: Icons.location_on,
                              label: 'Province',
                              value: userData['province'] ?? '',
                            ),
                            ProfileDetailItem(
                              icon: Icons.home,
                              label: 'Street Address',
                              value:
                                  '${userData['streetNumber']} ${userData['streetName']}',
                            ),
                            ProfileDetailItem(
                              icon: Icons.account_balance,
                              label: 'Suburb',
                              value: userData['suburb'] ?? '',
                            ),
                            ProfileDetailItem(
                              icon: Icons.perm_identity,
                              label: 'ID Number',
                              value: userData['idNumber'] ?? '',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailItem({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF6A11CB),
            radius: 20,
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.robotoFlex(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.robotoFlex(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

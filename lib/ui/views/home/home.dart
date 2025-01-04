
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:paybiz/core/app/routes.dart';
import 'package:paybiz/ui/views/home/tutorial_helper.dart';
import 'package:paybiz/ui/views/transfer/transaction_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey profileIconKey = GlobalKey();
  final GlobalKey balanceKey = GlobalKey();
  final GlobalKey sendMoneyButtonKey = GlobalKey();
  final GlobalKey personIconKey = GlobalKey();



  late String userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userId.isNotEmpty) {
        _showTutorialOnce();
      }
    });
  }

  // Function to check and show the tutorial only once
  Future<void> _showTutorialOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTutorial = prefs.getBool('hasSeenTutorial') ?? false;

    if (!hasSeenTutorial) {
      showTutorial(context, [
        profileIconKey,
        balanceKey,
        sendMoneyButtonKey,
        personIconKey,
      ]);

      // Mark the tutorial as seen
      await prefs.setBool('hasSeenTutorial', true);
    }
  }

  // Stream to listen for balance updates in real-time
  Stream<DocumentSnapshot> getBalanceStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }

  // Stream to fetch transactions
  Stream<List<Map<String, dynamic>>> getTransactionsStream() {
    return FirebaseFirestore.instance
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<String> _getCurrentUserAccountNumber() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
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

  @override
  Widget build(BuildContext context) {
    final size = 814.sp;

     final String currentDate = DateFormat('dd MMM').format(DateTime.now());

    if (userId.isEmpty) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.login);
            },
            child: const Text('Login to continue'),
          ),
        ),
      );
    }

    return Scaffold(
      
      body: Stack(
        children: [
          // Gradient Background
          Container(
            height: size * 0.99.sp,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 97, 87, 237),
                  Color.fromARGB(255, 205, 223, 67)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PayBiz.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      key: profileIconKey,
                      icon: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.lightGreenAccent,
                        child: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 14,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.profile);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your balance is',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                // Real-time balance display using StreamBuilder
                StreamBuilder<DocumentSnapshot>(
                  stream: getBalanceStream(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Text(
                        '0.',
                        style: TextStyle(color: Colors.white, fontSize: 32),
                      );
                    }

                    var userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    double balance = userData['balance'] ?? 0.0;

                    return Text(
                      'R${NumberFormat('#,##0.00').format(balance)}',
                      key: balanceKey,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                 Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    'Today $currentDate',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: size * 0.30.sp,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(27),
                  topRight: Radius.circular(27),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      key: sendMoneyButtonKey,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.transfer);
                              },
                              child: const Text(
                                'Send Money',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Transactions',
                      key: personIconKey,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<String>(
                        future: _getCurrentUserAccountNumber(),
                        builder: (context, userAccountSnapshot) {
                          if (userAccountSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (userAccountSnapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Error: ${userAccountSnapshot.error}'));
                          }

                          if (!userAccountSnapshot.hasData ||
                              userAccountSnapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('Unable to fetch account number.'));
                          }

                          final String currentAccountNumber =
                              userAccountSnapshot.data!;

                          return StreamBuilder<List<Map<String, dynamic>>>(
                            stream: getTransactionsStream(),
                            builder: (context, transactionSnapshot) {
                              if (transactionSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (transactionSnapshot.hasError) {
                                return Center(
                                    child: Text(
                                        'Error: ${transactionSnapshot.error}'));
                              }

                              if (!transactionSnapshot.hasData ||
                                  transactionSnapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No transactions available.'));
                              }

                              var transactions = transactionSnapshot.data!;

                              return ListView.builder(
                                itemCount: transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = transactions[index];

                                  final String senderAccountNumber =
                                      transaction['senderAccountNumber'] ??
                                          'Unknown';
                                  final String recipientAccountNumber =
                                      transaction['recipientAccountNumber'] ??
                                          'Unknown';
                                  final double amount =
                                      (transaction['amount'] ?? 0.0).toDouble();
                                  final DateTime timestamp =
                                      transaction['timestamp'].toDate();

                                  final bool isSent = senderAccountNumber ==
                                      currentAccountNumber;

                                  return TransactionItem(
                                    title: isSent
                                        ? 'To $recipientAccountNumber'
                                        : 'From $senderAccountNumber',
                                    subtitle:
                                        DateFormat('dd MMM yyyy at hh:mm a')
                                            .format(timestamp),
                                    amount: amount,
                                    isSent: isSent,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

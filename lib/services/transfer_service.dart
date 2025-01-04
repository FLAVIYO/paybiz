import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TransferService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> transferFunds({
    required String senderAccountNumber,
    required String recipientAccountNumber,
    required double amount,
    required String bank,
    required String senderReference,
    required String recipientReference, required BuildContext context,
  }) async {
    try {
      // Fetch sender and recipient documents
      QuerySnapshot senderQuery = await _firestore
          .collection('users')
          .where('accountNumber', isEqualTo: senderAccountNumber)
          .limit(1)
          .get();

      QuerySnapshot recipientQuery = await _firestore
          .collection('users')
          .where('accountNumber', isEqualTo: recipientAccountNumber)
          .limit(1)
          .get();

      if (senderQuery.docs.isEmpty || recipientQuery.docs.isEmpty) {
        throw Exception('Sender or recipient account does not exist.');
      }

      // Extract documents
      DocumentSnapshot senderDoc = senderQuery.docs.first;
      DocumentSnapshot recipientDoc = recipientQuery.docs.first;

      double senderBalance = (senderDoc['balance'] as num).toDouble();
      double recipientBalance = (recipientDoc['balance'] as num).toDouble();

      if (senderBalance < amount) {
        throw Exception('Insufficient funds.');
      }

      // Perform the transfer in a Firestore transaction
      await _firestore.runTransaction((transaction) async {
        // Update sender's balance
        transaction.update(senderDoc.reference, {
          'balance': senderBalance - amount,
        });

        // Update recipient's balance
        transaction.update(recipientDoc.reference, {
          'balance': recipientBalance + amount,
        });

        // Record the transaction
        transaction.set(_firestore.collection('transactions').doc(), {
          'senderAccountNumber': senderAccountNumber,
          'recipientAccountNumber': recipientAccountNumber,
          'amount': amount,
          'bank': bank,
          'senderReference': senderReference,
          'recipientReference': recipientReference,
          'timestamp': FieldValue.serverTimestamp(),
        });
      });

      Fluttertoast.showToast(
        msg: 'Transfer successful!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Transfer failed: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      print("$e");
    }
  }

  // Fetch transactions for a specific account
  Future<List<Map<String, dynamic>>> fetchTransactions(String accountNumber) async {
    try {
      // Fetch all transactions
      QuerySnapshot querySnapshot = await _firestore
          .collection('transactions')
          .orderBy('timestamp', descending: true)
          .get();

      // Filter transactions based on the account number (sender or recipient)
      List<Map<String, dynamic>> transactions = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((transaction) =>
              transaction['senderAccountNumber'] == accountNumber ||
              transaction['recipientAccountNumber'] == accountNumber)
          .toList();

      return transactions;
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }
}

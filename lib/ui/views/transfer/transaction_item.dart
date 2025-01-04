import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String title; // Either "From [Name]" or "To [Name]"
  final String subtitle; // Date and time of the transaction
  final double amount; // Transaction amount
  final bool isSent; // Whether it's a sent or received transaction

  const TransactionItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isSent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isSent ? Colors.red : Colors.green,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSent ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 12
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12
        ),
      ),
      trailing: Text(
        (isSent ? '-' : '+') + '\$${amount.toStringAsFixed(2)}',
        style: TextStyle(
          color: isSent ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

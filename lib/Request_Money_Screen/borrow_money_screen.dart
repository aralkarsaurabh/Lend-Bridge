import 'package:flutter/material.dart';

class BorrowMoneyScreen extends StatefulWidget {
  const BorrowMoneyScreen({super.key});

  @override
  State<BorrowMoneyScreen> createState() => _BorrowMoneyScreenState();
}

class _BorrowMoneyScreenState extends State<BorrowMoneyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Borrow Money',
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      backgroundColor: const Color(0xFFF5F5F5),
    );
  }
}

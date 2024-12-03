import 'package:flutter/material.dart';

class ViewSendViewReceivedScreen extends StatefulWidget {
  const ViewSendViewReceivedScreen({super.key});

  @override
  State<ViewSendViewReceivedScreen> createState() => _ViewSendViewReceivedScreenState();
}

class _ViewSendViewReceivedScreenState extends State<ViewSendViewReceivedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Search screen ",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        )
      ),
    );
  }
}
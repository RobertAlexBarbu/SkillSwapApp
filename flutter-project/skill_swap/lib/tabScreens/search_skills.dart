import 'package:flutter/material.dart';

class SearchSkills extends StatefulWidget {
  const SearchSkills({super.key});

  @override
  State<SearchSkills> createState() => _SearchSkillsState();
}

class _SearchSkillsState extends State<SearchSkills> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor:  Color.fromRGBO(255, 198, 0, 1),
        title: const Text(
          "Search profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          "Search profile screen",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        )
      ),
    );
  }
}
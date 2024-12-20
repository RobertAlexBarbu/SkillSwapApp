import 'package:flutter/material.dart';
import 'package:standard_searchbar/new/standard_search_anchor.dart';
import 'package:standard_searchbar/new/standard_search_bar.dart';
import 'package:standard_searchbar/new/standard_suggestion.dart';
import 'package:standard_searchbar/new/standard_suggestions.dart';

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
       backgroundColor:  Colors.green.shade200,
        title: const Text(
          "Search profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: const SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 100),
              SizedBox(
                width: 360,
                child: StandardSearchAnchor(
                  searchBar: StandardSearchBar(
                    bgColor: Color.fromRGBO(255, 198, 0, 1),
                    
                  ),
                  suggestions: StandardSuggestions(
                    suggestions: [
                      StandardSuggestion(text: 'Suggestion 1',),
                      StandardSuggestion(text: 'Suggestion 2'),
                      StandardSuggestion(text: 'Suggestion 3'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  
  }
}
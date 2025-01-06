import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skill_swap/tabScreens/see_user_profile.dart';
import 'package:standard_searchbar/new/standard_search_anchor.dart';
import 'package:standard_searchbar/new/standard_search_bar.dart';
import 'package:standard_searchbar/new/standard_suggestion.dart';
import 'package:standard_searchbar/new/standard_suggestions.dart';

import '../controllers/profile_controller.dart';
import '../controllers/skills_controller.dart';
import '../models/person.dart';
import '../models/skill.dart';

class SearchSkills extends StatefulWidget {
  const SearchSkills({Key? key}) : super(key: key);

  @override
  _SearchSkillsState createState() => _SearchSkillsState();
}

class _SearchSkillsState extends State<SearchSkills> {
  final ProfileController profileController = Get.put(ProfileController());
  final SkillsController skillsController = Get.put(SkillsController());
  List<Person> filteredProfiles = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchProfiles();
  }

  Future<void> fetchProfiles() async {
    // Fetch all profiles from the ProfileController
    List<Person> profiles = profileController.allUsersProfileList;

    // Preload skills for each profile
    for (var person in profiles) {
      person.skills = await skillsController.fetchSkills(person.uid!);
    }

    setState(() {
      filteredProfiles = profiles;
    });
  }

  void filterProfiles(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredProfiles = profileController.allUsersProfileList.where((person) {
        final matchesName = person.name?.toLowerCase().contains(searchQuery) ?? false;
        final matchesSkills = person.skills?.any((skill) =>
        skill.skillName?.toLowerCase().contains(searchQuery) ?? false) ?? false;
        return matchesName || matchesSkills;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade200,
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text(
            "Search Skills",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Search Skills",
                border: OutlineInputBorder(),
              ),
              onChanged: filterProfiles,
            ),
          ),
          Expanded(
            child: filteredProfiles.isEmpty
                ? const Center(child: Text("No profiles found"))
                : ListView.builder(
              itemCount: filteredProfiles.length,
              itemBuilder: (context, index) {
                final person = filteredProfiles[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        person.imageProfile ?? "https://via.placeholder.com/150"),
                  ),
                  title: Text(person.name ?? "Unnamed"),
                  subtitle: Text(
                    person.skills?.map((e) => e.skillName).join(", ") ??
                        "No skills",
                  ),
                  onTap: () {
                    Get.to(SeeUserProfile(userProfile: person));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

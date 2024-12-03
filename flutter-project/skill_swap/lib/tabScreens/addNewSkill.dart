
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skill_swap/tabScreens/user_details_screen.dart';
import 'package:skill_swap/widgets/custom_text_field.dart';

class AddNewSkill extends StatefulWidget {
  const AddNewSkill({super.key});

  @override
  State<AddNewSkill> createState() => _AddNewSkillState();
}

class _AddNewSkillState extends State<AddNewSkill> {

  TextEditingController skillNameTextEditingController = TextEditingController();
  TextEditingController skillDescriptionTextEditingController = TextEditingController();
  // Predefined categories
  final List<String> categories = ["Art", "Music", "Math", "Science", "Sports", "Technology"];
  // State to keep track of selected categories
  final Map<String, bool> selectedCategories = {};

  @override
  void initState() {
    super.initState();
    // Initialize all categories as unchecked
    for (var category in categories) {
      selectedCategories[category] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromRGBO(255, 198, 0, 1),
        title: const Text(
          "Add Skill",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // skill name
              SizedBox(
                width: MediaQuery.of(context).size.width -36,
                height: 55,
                child: CustomTextField(
                  editingController: skillNameTextEditingController,
                  lableText: "Name",
                  iconData: Icons.title,
                  isObsure: false,
                ),
              ),

              SizedBox(height: 30,),
              //description
              SizedBox(
                width: MediaQuery.of(context).size.width -36,
                height: 55,
                child: CustomTextField(
                  editingController: skillDescriptionTextEditingController,
                  lableText: "Description",
                  iconData: Icons.description,
                  isObsure: false,
                ),
              ),
          
              SizedBox(height: 20,),

              // Checkbox List for Categories
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align everything to the left
                children:[
                  // Align the header to the left
                  const Text(
                    "Select skill categories:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10), // Add slight space below the header

                  ... categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.all(0), // Adjust spacing between checkboxes
                    child: Row(
                      children: [
                        Checkbox(
                          value: selectedCategories[category],
                          activeColor: const Color.fromRGBO(255, 198, 0, 1), // Customize selected color
                          checkColor: Colors.white, // Checkmark color
                          onChanged: (bool? value) {
                            setState(() {
                              selectedCategories[category] = value ?? false;
                            });
                          },
                        ),
                        Text(
                          category,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16, // Adjust font size for compact layout
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                ]
              ),
            

              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between buttons
                children: [
                  // Save Button
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 198, 0, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: InkWell(
                        onTap: () async {
                          // Check if skill name, description are not empty and at least one category is selected
                          bool isAnyCategorySelected = selectedCategories.containsValue(true);

                          if (skillNameTextEditingController.text.trim().isNotEmpty &&
                              skillDescriptionTextEditingController.text.trim().isNotEmpty &&
                              isAnyCategorySelected) {
                            Get.back();
                          } else {
                            // Show error message if validation fails
                            String errorMessage = "";
                            if (skillNameTextEditingController.text.trim().isEmpty) {
                              errorMessage = "Please enter a skill name.";
                            } else if (skillDescriptionTextEditingController.text.trim().isEmpty) {
                              errorMessage = "Please enter a skill description.";
                            } else if (!isAnyCategorySelected) {
                              errorMessage = "Please select at least one category.";
                            }
                            Get.snackbar(
                              "Validation Error",
                              errorMessage,
                              backgroundColor: Colors.grey,
                              colorText: Colors.white,
                            );
                          }
                        },
                        child: const Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16), // Spacing between buttons
                  // Cancel Button
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 198, 0, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Add cancel logic here
                          Get.back();
                        },
                        child: const Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

             
            
            ],
          ),
        ),
      )
    );
  }
}
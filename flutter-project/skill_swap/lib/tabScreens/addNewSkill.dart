
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/controllers/skills_controller.dart';
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
  var skillsController = SkillsController.skillsController;

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
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text(
            "Add Skill",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
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
                child: TextFormField(
                  controller: skillNameTextEditingController,
                  textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              constraints: const BoxConstraints(
                                maxWidth: 360,
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                              prefixIcon:  Icon(Icons.title,
                                  color: Colors.orange.shade600),
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                              )),
                ),
              ),

              SizedBox(height: 30,),
              //description
              SizedBox(
                width: MediaQuery.of(context).size.width -36,
                height: 55,
                child: TextFormField(
                  controller: skillDescriptionTextEditingController,
                   textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              constraints: const BoxConstraints(
                                maxWidth: 360,
                              ),
                              filled: true,
                              fillColor: Color.fromRGBO(255, 198, 0, 1).withOpacity(0.3),
                              prefixIcon:  Icon(Icons.description,
                                  color: Colors.orange.shade600),
                              hintText: 'Description',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w400),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none)),
                  
                ),
              ),
          
              SizedBox(height: 20,),

              // Checkbox List for Categories
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align everything to the left
                children:[
                  // Align the header to the left
                   Text(
                    "Select skill categories:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
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
                          checkColor: Colors.white, 
                          side: BorderSide(
                            color: const Color.fromRGBO(255, 198, 0, 1), // Set the contour color
                            width: 1.5,        // Set the border width
                          ),// Checkmark color
                          onChanged: (bool? value) {
                            setState(() {
                              selectedCategories[category] = value ?? false;
                            });
                          },
                        ),
                        Text(
                          category,
                          style:  TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w400,
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

                                // Call the SkillController to create a new skill
                                final selectedCategoriesList = selectedCategories.keys
                                    .where((key) => selectedCategories[key] == true)
                                    .toList();
                                await skillsController.createSkill(
                                  skillName: skillNameTextEditingController.text.trim(),
                                  skillDescription: skillDescriptionTextEditingController.text.trim(),
                                  categories: selectedCategoriesList,
                                );

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
                              fontWeight: FontWeight.w400,
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
                              fontWeight: FontWeight.w400,
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
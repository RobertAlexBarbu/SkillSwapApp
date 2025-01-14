
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
  var selectedCategory;
  var skillsController = SkillsController.skillsController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the theme
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Add Skill",
            style: TextStyle(
              color: theme.primaryColor,
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
                  style: TextStyle(
                  ),
                  decoration: InputDecoration(
                      prefixIcon:  Icon(Icons.title,
                          color: theme.primaryColor),
                      labelText: "Name",
                      border: OutlineInputBorder(
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
                   style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                  decoration: InputDecoration(
                      prefixIcon:  Icon(Icons.description,
                          color: theme.primaryColor),
                      labelText: "Description",
                      border: OutlineInputBorder(
                      )),
                  
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10), // Add slight space below the header
       
                  ... categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.all(0), // Adjust spacing between radio buttons
                      child: Row(
                        children: [
                          Radio<String>(
                            value: category,
                            groupValue: selectedCategory, // Single selected value
                            activeColor: theme.primaryColor, // Customize selected color
                            onChanged: (String? value) {
                              setState(() {
                                selectedCategory = value; // Update selected category
                              });
                            },
                          ),
                          Text(
                            category,
                            style: TextStyle(
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
                mainAxisAlignment: MainAxisAlignment.end, // Space between buttons
                children: [

                  // Cancel Button
                  TextButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      // Add cancel logic here
                      Get.back();
                    },
                  ),

                  // Save Button
                  TextButton(
                  onPressed: () async {

      if (skillNameTextEditingController.text.trim().isNotEmpty &&
      skillDescriptionTextEditingController.text.trim().isNotEmpty &&
      true) {
      await skillsController.createSkill(
      skillName: skillNameTextEditingController.text.trim(),
      skillDescription: skillDescriptionTextEditingController.text.trim(),
      category: selectedCategory,
      );
      if(Get.isSnackbarOpen){
      Get.close(-1);
      } else {
      Get.back();
      }

      }

      },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 20,
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
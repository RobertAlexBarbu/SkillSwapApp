
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
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
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
                   style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
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
                      padding: const EdgeInsets.all(0), // Adjust spacing between radio buttons
                      child: Row(
                        children: [
                          Radio<String>(
                            value: category,
                            groupValue: selectedCategory, // Single selected value
                            activeColor: const Color.fromRGBO(255, 198, 0, 1), // Customize selected color
                            onChanged: (String? value) {
                              setState(() {
                                selectedCategory = value; // Update selected category
                              });
                            },
                          ),
                          Text(
                            category,
                            style: TextStyle(
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
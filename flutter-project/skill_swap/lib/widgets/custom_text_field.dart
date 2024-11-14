import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {

  final TextEditingController? editingController;
  final IconData? iconData;
  final String? assetRef;
  final String? lableText;
  final bool? isObsure;
  final TextStyle? textStyle;



  const CustomTextField({
    super.key,
    this.editingController,
    this.iconData,
    this.assetRef,
    this.lableText,
    this.isObsure,
    this.textStyle
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      decoration: InputDecoration(
        labelText: lableText,
        prefixIcon: iconData != null  
                    ? Icon(iconData) 
                    : Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(assetRef.toString()),
                      ),
        labelStyle: const TextStyle(
          fontSize: 18,
          color: Color.fromARGB(255, 92, 92, 92)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 92, 92, 92),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 92, 92, 92),
          ),
        )
      ),
      obscureText: isObsure!,
      style: TextStyle(color: Colors.black),
    );
  }
}
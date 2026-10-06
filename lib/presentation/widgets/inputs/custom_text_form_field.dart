

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {

  final String? label;
  final String? hint;
  final String? error;
  final int? maxLength;
  final bool isObscure;

  final Function(String)? onChanged;
  final String? Function(String?)? validator;


  const CustomTextFormField({
    super.key, 
    this.label, 
    this.hint, 
    this.error, 
    this.isObscure = false,
    this.onChanged,
    this.validator,
    this.maxLength
  });


  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.black12,
      )
    );


    return TextFormField(
      onChanged: onChanged,

      validator: validator,

      obscureText: isObscure,
      maxLength: maxLength,
      decoration: InputDecoration(
        
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: border.copyWith(borderSide: BorderSide(color: colors.error)),
        focusedErrorBorder: border.copyWith(borderSide: BorderSide(color: colors.error)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,

        label: label == null ? null : Text(label!),
        hint: hint == null ? null : Text(hint!),
        error: error == null ? null : Text(error!, style: TextStyle(color: colors.error),),
      ),
    );
  }
}
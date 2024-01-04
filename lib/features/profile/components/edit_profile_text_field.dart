import 'package:flutter/material.dart';
import 'package:twitter_x/theme/theme.dart';

profileTextField({
  required BuildContext context,
  required String label,
  String? hintText,
  int? maxLength,
  int maxLines = 1,
  String? errorText,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              height: 0,
              color: PallateColor.unselectColor,
            ),
      ),
      TextFormField(
        controller: controller,
        validator: errorText == null
            ? null
            : (value) {
                if (value!.isEmpty) {
                  return errorText;
                }
                return null;
              },
        maxLength: maxLength,
        maxLines: maxLines,
        style: Theme.of(context).textTheme.titleLarge,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          hintText: hintText,
        ),
      ),
    ],
  );
}

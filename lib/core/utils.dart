import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

void UshowToast({String text = "enter your msg"}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.grey,
    textColor: Colors.black,
    fontSize: 16.0,
  );
}

String UgetEmailUsername(String email) {
  final StringList = email.split('@');
  return StringList.first;
}

Future<List<File>> UpickMultipleImages() async {
  List<File> images = [];
  final imagePicker = ImagePicker();

  final pickedImages = await imagePicker.pickMultiImage(imageQuality: 60);

  if (pickedImages.isNotEmpty) {
    for (final image in pickedImages) {
      if (images.length < 4) {
        images.add(File(image.path));
      } else {
        UshowToast(text: "You only allow to pick 4 images");
        break;
      }
    }
  }
// decodeImageFromList(bytes)
  return images;
}

Future<XFile?> UpickImage() async {
  final imagePicker = ImagePicker();

  final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

  return pickedImage;
}

class UDateTime {
  static String getFormatedTimeInDate(DateTime date) {
    return formatDate(
      date,
      [MM, ' ', yyyy],
    );
  }

  static String getFormatedTimeInAM_PM_With_Date(DateTime date) {
    return formatDate(
      date,
      [hh, ":", nn, " ", am, " • ", M, " ", yy, " • "],
    );
  }
}

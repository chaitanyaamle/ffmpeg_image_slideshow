
import 'dart:io';
import 'dart:ui';

import 'package:image_picker/image_picker.dart';

mixin HomeResources {

  String title = "Home";
  String outputUrl = '';

  String? outputUrlName;

  String? imageUrl1 = "";
  String? imageUrl2 = "";
  String? imageUrl3 = "";
  File? imageFile;

  String font = "KolkerBrush-Regular.ttf";
  String fontName = "KolkerBrush";

  List<String> fontNameList = ["KolkerBrush-Regular.ttf",
    "LavishlyYours-Regular.ttf", "PoorStory-Regular.ttf",
    "Shalimar-Regular.ttf", "StickNoBills-VariableFont_wght.ttf"];

  List<String> fonts = ["KolkerBrush",
    "LavishlyYours", "PoorStory",
    "Shalimar", "StickNoBills"];

  Color color = const Color.fromARGB(255, 255, 207, 0);

  String strColor = "";
  String text = "";

  static bool change = false;

  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFiles;

}

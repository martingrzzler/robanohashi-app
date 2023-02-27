import 'package:flutter/material.dart';

dynamic getSubjectBackgroundColor(String object) {
  switch (object) {
    case "kanji":
      return Colors.pink;
    case "radical":
      return Colors.blue;
    case "vocabulary":
      return Colors.purple;
  }
}

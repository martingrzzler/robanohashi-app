import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:robanohashi/api/api.dart';
import 'package:robanohashi/api/subject_preview.dart';

class BookmarkedSubjectsService extends ChangeNotifier {
  Future<List<SubjectPreview>> _subjects = Future.value(<SubjectPreview>[]);

  Future<List<SubjectPreview>> get subjects => _subjects;

  void fetchBookmarkedSubjects(User user) {
    _subjects = Api.fetchBookmarkedSubjects(user);
    notifyListeners();
  }
}

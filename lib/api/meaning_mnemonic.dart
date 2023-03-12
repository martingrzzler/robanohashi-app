import 'package:robanohashi/api/common.dart';

class MeaningMnemonic {
  final String id;
  final String text;
  final String userId;
  final int votingCount;
  final String subjectId;
  final int createdAt;
  final int updatedAt;

  MeaningMnemonic({
    required this.id,
    required this.text,
    required this.userId,
    required this.votingCount,
    required this.subjectId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MeaningMnemonic.fromJson(Map<String, dynamic> json) {
    return MeaningMnemonic(
      id: json['id'],
      text: json['text'],
      userId: json['user_id'],
      votingCount: json['voting_count'],
      subjectId: json['subject_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class MeaningMnemonicWithUserInfo {
  final String id;
  final String text;
  final String userId;
  final int votingCount;
  final Subject subject;
  final int createdAt;
  final int updatedAt;
  final bool upvoted;
  final bool downvoted;
  final bool favorite;
  final bool me;

  MeaningMnemonicWithUserInfo({
    required this.id,
    required this.text,
    required this.userId,
    required this.votingCount,
    required this.subject,
    required this.createdAt,
    required this.updatedAt,
    required this.downvoted,
    required this.upvoted,
    required this.favorite,
    required this.me,
  });

  factory MeaningMnemonicWithUserInfo.fromJson(Map<String, dynamic> json) {
    return MeaningMnemonicWithUserInfo(
        id: json['id'],
        text: json['text'],
        userId: json['user_id'],
        votingCount: json['voting_count'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        upvoted: json['upvoted'],
        downvoted: json['downvoted'],
        favorite: json['favorite'],
        me: json['me'],
        subject: Subject.fromJson(json['subject']));
  }
}

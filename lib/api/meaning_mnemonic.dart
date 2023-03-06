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

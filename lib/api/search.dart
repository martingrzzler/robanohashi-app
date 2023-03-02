import 'subject_preview.dart';

class SearchResponse {
  final int totalCount;
  final List<SubjectPreview> data;

  SearchResponse({
    required this.totalCount,
    required this.data,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
        totalCount: json['total_count'],
        data: List<SubjectPreview>.from(
            json['data'].map((x) => SubjectPreview.fromJson(x))));
  }
}

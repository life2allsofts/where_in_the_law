class Law {
  final String id;
  final String title;
  final List<String> searchKeywords;
  final String category; // NEW: Add category field
  final String lawName;
  final String lawCode;
  final String section;
  final String legalText;
  final String plainExplanation;

  Law({
    required this.id,
    required this.title,
    required this.searchKeywords,
    required this.category, // NEW
    required this.lawName,
    required this.lawCode,
    required this.section,
    required this.legalText,
    required this.plainExplanation,
  });

  factory Law.fromJson(Map<String, dynamic> json) {
    return Law(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      searchKeywords: List<String>.from(json['searchKeywords'] ?? []),
      category: json['category'] ?? 'General', // NEW: Default to 'General'
      lawName: json['lawName'] ?? '',
      lawCode: json['lawCode'] ?? '',
      section: json['section'] ?? '',
      legalText: json['legalText'] ?? '',
      plainExplanation: json['plainExplanation'] ?? '',
    );
  }
}
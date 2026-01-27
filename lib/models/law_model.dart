class Law {
  final String id;
  final String title;
  final List<String> searchKeywords;
  final String category;
  final String lawName;
  final String lawCode;
  final String section;
  final String legalText;
  final String plainExplanation;
  bool isFavorite;

  Law({
    required this.id,
    required this.title,
    required this.searchKeywords,
    required this.category,
    required this.lawName,
    required this.lawCode,
    required this.section,
    required this.legalText,
    required this.plainExplanation,
    this.isFavorite = false,
  });

  factory Law.fromJson(Map<String, dynamic> json) {
    return Law(
      id: _safeString(json['id']),
      title: _safeString(json['title']),
      searchKeywords: _convertToStringList(json['searchKeywords']),
      category: _safeString(json['category']),
      lawName: _safeString(json['lawName']),
      lawCode: _safeString(json['lawCode']),
      section: _safeString(json['section']),
      legalText: _safeString(json['legalText']),
      plainExplanation: _safeString(json['plainExplanation']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  get plainEnglish => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'searchKeywords': searchKeywords,
      'category': category,
      'lawName': lawName,
      'lawCode': lawCode,
      'section': section,
      'legalText': legalText,
      'plainExplanation': plainExplanation,
      'isFavorite': isFavorite,
    };
  }

  // Helper methods to handle type conversion
  static String _safeString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is int || value is double) return value.toString();
    return value.toString();
  }

  static List<String> _convertToStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((item) => _safeString(item)).toList();
    }
    return [];
  }
}
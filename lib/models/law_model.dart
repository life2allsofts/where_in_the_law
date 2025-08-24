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
  bool isFavorite; // NEW: Favorite state

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
    this.isFavorite = false, // Default to not favorite
  });

  factory Law.fromJson(Map<String, dynamic> json) {
    return Law(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      searchKeywords: List<String>.from(json['searchKeywords'] ?? []),
      category: json['category'] ?? 'General',
      lawName: json['lawName'] ?? '',
      lawCode: json['lawCode'] ?? '',
      section: json['section'] ?? '',
      legalText: json['legalText'] ?? '',
      plainExplanation: json['plainExplanation'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
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
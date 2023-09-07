class CategorySeed {
  final String id;
  final String user;
  final String category;

  CategorySeed( {
    required this.id,
    required this.user,
    required this.category,
  });

  factory CategorySeed.fromJson(Map<String, dynamic> json) {
    return CategorySeed(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      category: json['category'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'category': category,
    };
  }
}

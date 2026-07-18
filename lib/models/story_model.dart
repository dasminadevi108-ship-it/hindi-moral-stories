class Story {
  final String id;
  final String titleHindi;
  final String titleEnglish;
  final String descriptionHindi;
  final String descriptionEnglish;
  final String moralHindi;
  final String moralEnglish;
  final String videoUrl;
  final String thumbnailUrl;
  final String category;
  final int duration;
  final double rating;
  final int reviews;
  final DateTime createdAt;
  final List<String> tags;
  bool isBookmarked;
  double userRating;

  Story({
    required this.id,
    required this.titleHindi,
    required this.titleEnglish,
    required this.descriptionHindi,
    required this.descriptionEnglish,
    required this.moralHindi,
    required this.moralEnglish,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.category,
    required this.duration,
    required this.rating,
    required this.reviews,
    required this.createdAt,
    required this.tags,
    this.isBookmarked = false,
    this.userRating = 0.0,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] as String,
      titleHindi: json['titleHindi'] as String,
      titleEnglish: json['titleEnglish'] as String,
      descriptionHindi: json['descriptionHindi'] as String,
      descriptionEnglish: json['descriptionEnglish'] as String,
      moralHindi: json['moralHindi'] as String,
      moralEnglish: json['moralEnglish'] as String,
      videoUrl: json['videoUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      category: json['category'] as String,
      duration: json['duration'] as int,
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      tags: List<String>.from(json['tags'] as List),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      userRating: (json['userRating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleHindi': titleHindi,
      'titleEnglish': titleEnglish,
      'descriptionHindi': descriptionHindi,
      'descriptionEnglish': descriptionEnglish,
      'moralHindi': moralHindi,
      'moralEnglish': moralEnglish,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'duration': duration,
      'rating': rating,
      'reviews': reviews,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'isBookmarked': isBookmarked,
      'userRating': userRating,
    };
  }
}

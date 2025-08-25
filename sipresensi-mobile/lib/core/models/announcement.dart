class Announcement {
  final int id;
  final String title;
  final String content;
  final int authorId;
  final bool isPublished;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.isPublished,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      authorId: json['author_id'] as int? ?? 0,
      isPublished: json['is_published'] as bool? ?? false,
      publishedAt: json['published_at'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author_id': authorId,
      'is_published': isPublished,
      'published_at': publishedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
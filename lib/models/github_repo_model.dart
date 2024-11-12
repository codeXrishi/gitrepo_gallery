class GithubRepoModel {
  final String id;
  final String description;
  final String ownerName;
  final String ownerAvatarUrl;
  final String createdAt;
  final String updatedAt;
  final int commentCount;

  GithubRepoModel({
    required this.id,
    required this.description,
    required this.ownerName,
    required this.ownerAvatarUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.commentCount,
  });

  factory GithubRepoModel.fromJson(Map<String, dynamic> json) {
    return GithubRepoModel(
      id: json['id'],
      description: json['description'] ?? 'No Description',
      ownerName: json['owner']['login'],
      ownerAvatarUrl: json['owner']['avatar_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      commentCount: json['comments'],
    );
  }
}

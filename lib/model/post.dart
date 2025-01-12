class Post {
  final String thumbnail;
  final String author;
  final String community;
  final String title;
  final String description;
  final int votes;
  final int comments;
  final DateTime createdAt;

  Post({
    required this.thumbnail,
    required this.author,
    required this.community,
    required this.title,
    required this.description,
    required this.votes,
    required this.comments,
    required this.createdAt,
  });
  static String cleanMarkdown(String text) {
    final RegExp markdownRegex = RegExp(r'(!\[.*?\]\(.*?\))');
    return text.replaceAll(markdownRegex, '').trim();
  }

  static String extractFirstImageUrl(String body) {
    final RegExp imageRegex =
        RegExp(r'!\[.*?\]\((https?:\/\/.*?\.(?:png|jpg|jpeg|mpeg|gif))\)');
    final match = imageRegex.firstMatch(body);
    return match != null ? match.group(1)! : '';
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      thumbnail: json['thumb'] ??
          extractFirstImageUrl(
              json['body'] ?? ''), // Default empty string if null
      author: json['author'] ?? 'Unknown', // Default 'Unknown' if null
      community: json['community'] ?? 'General', // Default 'General' if null
      title: json['title'] ?? 'No Title', // Default 'No Title' if null
      description: cleanMarkdown(json['body'] ?? '').length > 1000
          ? cleanMarkdown(json['body'] ?? '').substring(0, 1000)
          : cleanMarkdown(
              json['body'] ?? ''), // Check length before applying substring
      votes: json['net_votes'] ?? 0, // Default 0 votes if null
      comments: json['children'] ?? 0, // Default 0 comments if null
      createdAt: DateTime.tryParse(json['created'] ?? '') ??
          DateTime.now(), // Fallback to current time if parsing fails
    );
  }
}

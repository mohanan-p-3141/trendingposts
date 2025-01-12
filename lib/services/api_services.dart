// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:round1/model/post.dart';


class ApiService {
  static const String _url = 'https://api.hive.blog/';
  
  Future<List<Post>> fetchPosts() async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id": 1,
        "jsonrpc": "2.0",
        "method": "bridge.get_ranked_posts",
        "params": {"sort": "trending", "tag": "", "observer": "hive.blog"}
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log('API Response: $data');
      final posts = data['result'] as List;
      return posts.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}

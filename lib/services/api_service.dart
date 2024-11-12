import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/github_repo_model.dart';

class ApiService {
  static const githubGistsUrl = "https://api.github.com/gists/public";

  // Initialize cache settings
  static Future<void> initCache() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('last_cache_time')) {
      prefs.setInt('last_cache_time', 0);
    }
  }

  Future<List<GithubRepoModel>> fetchPublicGists() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('public_gists_cache');

    if (cachedData != null) {
      List<dynamic> jsonData = json.decode(cachedData);
      List<GithubRepoModel> cachedGists =
          jsonData.map((data) => GithubRepoModel.fromJson(data)).toList();

      // Update cache in the background
      _fetchAndCachePublicGists();

      return cachedGists;
    } else {
      return await _fetchAndCachePublicGists();
    }
  }

  Future<List<GithubRepoModel>> _fetchAndCachePublicGists() async {
    final response = await http.get(Uri.parse(githubGistsUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<GithubRepoModel> gists =
          jsonData.map((data) => GithubRepoModel.fromJson(data)).toList();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('public_gists_cache', response.body);

      return gists;
    } else {
      throw Exception('Failed to load gists');
    }
  }

  Future<void> clearOldCache() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCacheTime = prefs.getInt('last_cache_time') ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (currentTime - lastCacheTime > 86400000) {
      // Clear cache after 24 hours
      await prefs.remove('public_gists_cache');
      await prefs.setInt('last_cache_time', currentTime);
    }
  }
}

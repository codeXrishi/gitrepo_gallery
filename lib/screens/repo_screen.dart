import 'package:flutter/material.dart';

import '../models/github_repo_model.dart';
import '../services/api_service.dart';

class RepoScreen extends StatelessWidget {
  final ApiService apiService = ApiService();

  RepoScreen({super.key});

  void _showOwnerInfo(
      BuildContext context, String ownerName, String ownerAvatarUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ownerName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage(ownerAvatarUrl), radius: 30),
              const SizedBox(height: 10),
              Text("Owner: $ownerName"),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GithubRepoModel>>(
      future: apiService.fetchPublicGists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading repositories'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No repositories available'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final repo = snapshot.data![index];

            return GestureDetector(
              onTap: () {
                // Open files screen on normal tap
              },
              onLongPress: () {
                _showOwnerInfo(context, repo.ownerName, repo.ownerAvatarUrl);
              },
              child: Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(repo.description),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Created: ${repo.createdAt}'),
                      Text('Updated: ${repo.updatedAt}'),
                      Text('Comments: ${repo.commentCount}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

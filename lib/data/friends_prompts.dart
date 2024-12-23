// lib/data/friends_prompts.dart
import 'dart:math';

List<Map<String, String>> friendsPrompts = [
  {
    "text": "Sing a song.",
    "type": "dare",
    "difficulty": "easy",
  },
  {
    "text": "Do 10 pushups.",
    "type": "dare",
    "difficulty": "medium",
  },
  {
    "text": "What is your biggest fear?",
    "type": "truth",
    "difficulty": "spicy",
  },
  // Add more friend-specific prompts here
];

Map<String, dynamic>? getRandomFriendsPrompt(String difficulty, String type) {
  final random = Random();
  final matchingPrompts = friendsPrompts.where(
      (prompt) => prompt["difficulty"] == difficulty && prompt["type"] == type);

  if (matchingPrompts.isNotEmpty) {
    final randomIndex = random.nextInt(matchingPrompts.length);
    return matchingPrompts.elementAt(randomIndex);
  } else {
    return null;
  }
}

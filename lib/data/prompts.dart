import 'dart:math';

List<Map<String, String>> prompts = [
  {
    "text": "If you could have any superpower, what would it be and why?",
    "category": "truth",
    "difficulty": "easy",
  },
  {
    "text": "Have you ever pretended to be sick to get out of something? If so, what was it?",
    "category": "truth",
    "difficulty": "medium",
  },
  {
    "text": "Tell us about your most embarrassing childhood memory.",
    "category": "truth",
    "difficulty": "hard",
  },
  {
    "text": "Sing a song.",
    "category": "dare",
    "difficulty": "easy",
  },
  {
    "text": "Do 10 pushups.",
    "category": "dare",
    "difficulty": "medium",
  },
  {
    "text": "Eat something without using your hands.",
    "category": "dare",
    "difficulty": "hard",
  },
  {
    "text": "What is your biggest fear?",
    "category": "truth",
    "difficulty": "medium",
  },
  {
    "text": "Tell a joke.",
    "category": "dare",
    "difficulty": "easy",
  },
  {
    "text": "What is your biggest regret?",
    "category": "truth",
    "difficulty": "hard",
  },
];

/// Returns a random prompt that matches the given difficulty and category.
/// Returns null if no matching prompt is found.
Map<String, dynamic>? getRandomPrompt(String difficulty, String category) {
  final random = Random();
  final matchingPrompts = prompts.where((prompt) =>
      prompt["difficulty"] == difficulty && prompt["category"] == category);

  if (matchingPrompts.isNotEmpty) {
    final randomIndex = random.nextInt(matchingPrompts.length);
    return matchingPrompts.elementAt(randomIndex); 
  } else {
    return null; 
  }
}
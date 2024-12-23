import 'dart:math';

List<Map<String, String>> couplesPrompts = [
  {
    "text": "If you could have any superpower, what would it be and why?",
    "type": "truth",
    "difficulty": "easy",
  },
  {
    "text": "Have you ever pretended to be sick to get out of something? If so, what was it?",
    "type": "truth",
    "difficulty": "medium",
  },
  {
    "text": "Tell us about your most embarrassing childhood memory.",
    "type": "truth",
    "difficulty": "spicy",
  },
  // Add more couples-specific prompts here
];

Map<String, dynamic>? getRandomCouplesPrompt(String difficulty, String type) {
  final random = Random();
  final matchingPrompts = couplesPrompts.where((prompt) =>
      prompt["difficulty"] == difficulty && prompt["type"] == type);

  if (matchingPrompts.isNotEmpty) {
    final randomIndex = random.nextInt(matchingPrompts.length);
    return matchingPrompts.elementAt(randomIndex);
  } else {
    return null;
  }
}
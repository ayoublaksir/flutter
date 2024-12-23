import 'dart:math';

List<Map<String, dynamic>> prompts = [
  {'text': 'What is your biggest fear?', 'difficulty': 'easy', 'type': 'truth'},
  {'text': 'Sing a song.', 'difficulty': 'easy', 'type': 'dare'},
  {'text': 'Have you ever told a lie?', 'difficulty': 'medium', 'type': 'truth'},
  {'text': 'Do 10 pushups.', 'difficulty': 'medium', 'type': 'dare'},
  {'text': 'What is your deepest secret?', 'difficulty': 'extreme', 'type': 'truth'},
  {'text': 'Try to lick your elbow', 'difficulty': 'extreme', 'type': 'dare'},
  {'text': 'What\'s the most embarrassing thing that\'s ever happened to you?', 'difficulty': 'medium', 'type': 'truth'},
  {'text': 'Tell a joke.', 'difficulty': 'easy', 'type': 'dare'},
  {'text': 'If you could have any superpower, what would it be?', 'difficulty': 'easy', 'type': 'truth'},
  {'text': 'Attempt to do a cartwheel.', 'difficulty': 'medium', 'type': 'dare'},
  {'text': 'Have you ever cheated on a test?', 'difficulty': 'medium', 'type': 'truth'},
  {'text': 'Eat something without using your hands.', 'difficulty': 'easy', 'type': 'dare'},
  {'text': 'Who is your celebrity crush?', 'difficulty': 'easy', 'type': 'truth'},
  {'text': 'Tell us your most embarrassing childhood memory.', 'difficulty': 'extreme', 'type': 'truth'},
  {'text': 'Act like a cat for 1 minute.', 'difficulty': 'easy', 'type': 'dare'},
  {'text': 'Do a silly dance.', 'difficulty': 'easy', 'type': 'dare'},  
  {'text': 'Share a secret you haven\'t told anyone.', 'difficulty': 'extreme', 'type': 'truth'},
  {'text': 'Call a random person and sing to them.', 'difficulty': 'extreme', 'type': 'dare'},
];

Map<String, dynamic>? getRandomPrompt(String difficulty, String type) {
  final filteredPrompts = prompts.where((prompt) {
    return (prompt['difficulty'] == difficulty && prompt['type'] == type);
  }).toList();

  if (filteredPrompts.isEmpty) {
    return null;
  }

  final randomIndex = Random().nextInt(filteredPrompts.length);
  return filteredPrompts[randomIndex];
}
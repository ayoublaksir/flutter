import 'package:flutter/material.dart';
import 'data/prompts.dart';
import 'dart:math';
// At the top of your main.dart file, add these imports:
import 'data/couples_prompts.dart';
import 'data/friends_prompts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Truth or Dare',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/category': (context) => const CategoryScreen(),
        '/localMultiplayer': (context) => const LocalMultiplayerScreen(),
        '/couplesMode': (context) => const CouplesModeScreen(),
        '/onlineMultiplayer': (context) => const OnlineMultiplayerScreen(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truth or Dare'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/category', arguments: 'local');
              },
              child: const Text('Local Multiplayer'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/category', arguments: 'couples');
              },
              child: const Text('Couples Mode'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/onlineMultiplayer');
              },
              child: const Text('Online Multiplayer'),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameMode = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _navigateToGame(context, gameMode, 'easy'),
              child: const Text('Easy'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToGame(context, gameMode, 'medium'),
              child: const Text('Medium'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navigateToGame(context, gameMode, 'spicy'),
              child: const Text('Spicy'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToGame(BuildContext context, String gameMode, String category) {
    if (gameMode == 'local') {
      Navigator.pushNamed(context, '/localMultiplayer',
          arguments: {'category': category});
    } else if (gameMode == 'couples') {
      Navigator.pushNamed(context, '/couplesMode',
          arguments: {'category': category});
    }
  }
}

class LocalMultiplayerScreen extends StatefulWidget {
  const LocalMultiplayerScreen({super.key});

  @override
  _LocalMultiplayerScreenState createState() => _LocalMultiplayerScreenState();
}

class _LocalMultiplayerScreenState extends State<LocalMultiplayerScreen> {
  late String _category;
  int _currentPlayerIndex = 0;
  List<String> _playerNames = [];
  List<int> _scores = [];
  int _numPlayers = 0;
  String? _currentPrompt;
  bool _isTruth = true;
  bool _gameStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    _category = args['category']!;
  }

  Map<String, dynamic>? _getRandomPrompt(String type) {
    return getRandomFriendsPrompt(_category, type);
  }

  void _getPlayerNames(int numPlayers) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        List<TextEditingController> controllers =
            List.generate(numPlayers, (index) => TextEditingController());
        return AlertDialog(
          title: const Text('Enter Player Names'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                numPlayers,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: controllers[i],
                    decoration: InputDecoration(labelText: 'Player ${i + 1}'),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _playerNames = controllers
                      .map((c) => c.text.isEmpty
                          ? 'Player ${_playerNames.length + 1}'
                          : c.text)
                      .toList();
                  _scores = List.filled(numPlayers, 0);
                  _gameStarted = true;
                  _currentPrompt =
                      _getRandomPrompt('truth')?['text'] ?? 'No prompt found';
                });
                Navigator.of(context).pop();
              },
              child: const Text('Start Game'),
            ),
          ],
        );
      },
    );
  }

  void _handleTaskCompletion(bool completed) {
    setState(() {
      if (completed) {
        _scores[_currentPlayerIndex] += 10;
        _nextTurn();
      } else {
        _showDarePenalty();
      }
    });
  }

  void _nextTurn() {
    setState(() {
      if (_scores[_currentPlayerIndex] >= 50) {
        _showWinnerDialog();
      } else {
        _currentPlayerIndex = (_currentPlayerIndex + 1) % _playerNames.length;
        _isTruth = true;
        _currentPrompt =
            _getRandomPrompt('truth')?['text'] ?? 'No prompt found';
      }
    });
  }

  void _showDarePenalty() {
    setState(() {
      _isTruth = false;
      _currentPrompt = _getRandomPrompt('dare')?['text'] ?? 'No prompt found';
    });
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${_playerNames[_currentPlayerIndex]} Wins!'),
          content: Text('Final Score: ${_scores[_currentPlayerIndex]} points'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Back to Main Menu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Multiplayer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: !_gameStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enter Number of Players:',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (text) {
                        setState(() {
                          _numPlayers = int.tryParse(text) ?? 0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _numPlayers > 1
                        ? () => _getPlayerNames(_numPlayers)
                        : null,
                    child: const Text('Start Game'),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_playerNames[_currentPlayerIndex]}\'s turn',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _currentPrompt ?? 'No prompt available',
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _handleTaskCompletion(true),
                        child: const Text('Completed'),
                      ),
                      ElevatedButton(
                        onPressed: () => _handleTaskCompletion(false),
                        child: const Text('Pass (Dare)'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Scores: ${_playerNames.asMap().entries.map((e) => '${e.value}: ${_scores[e.key]}').join(', ')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}

class CouplesModeScreen extends StatefulWidget {
  const CouplesModeScreen({super.key});

  @override
  _CouplesModeScreenState createState() => _CouplesModeScreenState();
}

class _CouplesModeScreenState extends State<CouplesModeScreen> {
  late String _category;
  int _currentPlayerIndex = 0;
  List<String> _playerNames = ['Player 1', 'Player 2'];
  List<int> _scores = [0, 0];
  String? _currentPrompt;
  bool _isTruth = true;
  bool _gameStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    _category = args['category']!;
  }

  Map<String, dynamic>? _getRandomPrompt(String type) {
    return getRandomCouplesPrompt(_category, type);
  }

  void _getPlayerNames() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        List<TextEditingController> controllers =
            List.generate(2, (index) => TextEditingController());
        return AlertDialog(
          title: const Text('Enter Player Names'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              2,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: controllers[i],
                  decoration: InputDecoration(labelText: 'Player ${i + 1}'),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _playerNames = controllers
                      .map((c) => c.text.isEmpty
                          ? 'Player ${controllers.indexOf(c) + 1}'
                          : c.text)
                      .toList();
                  _gameStarted = true;
                  _currentPrompt =
                      _getRandomPrompt('truth')?['text'] ?? 'No prompt found';
                });
                Navigator.of(context).pop();
              },
              child: const Text('Start Game'),
            ),
          ],
        );
      },
    );
  }

  void _handleTaskCompletion(bool completed) {
    setState(() {
      if (completed && _isTruth) {
        _scores[_currentPlayerIndex] += 10;
      }
      _nextTurn();
    });
  }

  void _nextTurn() {
    setState(() {
      if (_scores[_currentPlayerIndex] >= 50) {
        _showWinnerDialog();
      } else {
        _currentPlayerIndex = (_currentPlayerIndex + 1) % 2;
        _isTruth = true;
        _currentPrompt =
            _getRandomPrompt('truth')?['text'] ?? 'No prompt found';
      }
    });
  }

  void _showDarePenalty() {
    setState(() {
      _isTruth = false;
      _currentPrompt = _getRandomPrompt('dare')?['text'] ?? 'No prompt found';
    });
  }

  void _showWinnerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${_playerNames[_currentPlayerIndex]} Wins!'),
          content: Text('Final Score: ${_scores[_currentPlayerIndex]} points'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Back to Main Menu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Couples Mode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: !_gameStarted
            ? Center(
                child: ElevatedButton(
                  onPressed: _getPlayerNames,
                  child: const Text('Start Game'),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${_playerNames[_currentPlayerIndex]}\'s turn',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _currentPrompt ?? 'No prompt available',
                        style: const TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _handleTaskCompletion(true),
                        child: const Text('Completed'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showDarePenalty();
                        },
                        child: const Text('Pass (Dare)'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Scores: ${_playerNames.asMap().entries.map((e) => '${e.value}: ${_scores[e.key]}').join(', ')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}

class OnlineMultiplayerScreen extends StatelessWidget {
  const OnlineMultiplayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Multiplayer'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Online Multiplayer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Coming Soon!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            Text(
              'This feature is currently under development.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

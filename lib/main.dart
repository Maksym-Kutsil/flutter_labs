import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MagicCounterPage(),
    );
  }
}

class MagicCounterPage extends StatefulWidget {
  const MagicCounterPage({super.key});

  @override
  State<MagicCounterPage> createState() => _MagicCounterPageState();
}

class _MagicCounterPageState extends State<MagicCounterPage> {
  final TextEditingController _controller = TextEditingController();

  int _counter = 0;
  String _status = 'Enter a number or a magic command.';
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black;

  void _handleInput() {
    final input = _controller.text.trim();

    setState(() {
      if (input.toLowerCase() == 'avada kedavra') {
        _counter = 0;
        _status = 'Avada Kedavra cast! Counter reset to 0.';
        _backgroundColor = Colors.red.shade100;
        _textColor = Colors.black;
      } else if (input.toLowerCase() == 'lumos') {
        _status = 'Lumos activated: light mode on.';
        _backgroundColor = Colors.yellow.shade100;
        _textColor = Colors.black;
      } else if (input.toLowerCase() == 'nox') {
        _status = 'Nox activated: dark mode on.';
        _backgroundColor = Colors.black87;
        _textColor = Colors.white;
      } else {
        final number = int.tryParse(input);

        if (number != null) {
          _counter += number;
          _status = 'Added $number to the counter.';
          _backgroundColor = Colors.green.shade100;
          _textColor = Colors.black;
        } else {
          _status = 'Invalid input. Enter a number or a command.';
          _backgroundColor = Colors.orange.shade100;
          _textColor = Colors.black;
        }
      }
    });

    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Lab 1: Interactive Input'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Counter: $_counter',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter a number or command',
                  hintText: 'Examples: 5, Avada Kedavra, Lumos, Nox',
                ),
                onSubmitted: (_) => _handleInput(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _handleInput,
                child: const Text('Apply'),
              ),
              const SizedBox(height: 20),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: _textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

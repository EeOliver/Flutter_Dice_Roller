import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const DiceApp());
}

class DiceApp extends StatelessWidget {
  const DiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const Dice(),
    );
  }
}

class Dice extends StatefulWidget {
  const Dice({super.key});

  @override
  State<Dice> createState() => _DiceState();
}

class _DiceState extends State<Dice> {
  final List<int> diceTypes = [4, 6, 8, 10, 12, 20];
  bool allowNegative = false;

  int selectedDice = 6;
  int diceCount = 1;
  int modifier = 0;

  int total = 0;
  List<int> lastRolls = [];
  final List<String> rollHistory = [];

void rollDice() {
  final rand = Random();

  lastRolls = List.generate(
    diceCount,
    (_) => rand.nextInt(selectedDice) + 1,
  );

  total = lastRolls.reduce((a, b) => a + b) + modifier;

  if (allowNegative && rand.nextBool()) {
    total = -total;
  }

  setState(() {
    rollHistory.insert(
      0,
      "${diceCount}d$selectedDice ${modifier >= 0 ? '+$modifier' : modifier} → $lastRolls = $total",
    );
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1E1E2C),
              Color(0xFF23243A),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              /// Title
              const Text(
                "  Dice Roller",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),

              const SizedBox(height: 20),

              /// Dice type
             _card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label("Allow Negative Output"),
                  Switch(
                    value: allowNegative,
                    onChanged: (value) {
                      setState(() {
                        allowNegative = value;
                      });
                    },
                    activeColor: const Color.fromARGB(255, 84, 255, 98),
                  ),
                ],
              ),
            ),

              /// Dice amount
              _card(
                child: Column(
                  children: [
                    _label("Dice Amount: $diceCount"),
                    Slider(
                      value: diceCount.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (v) =>
                          setState(() => diceCount = v.toInt()),
                    ),
                  ],
                ),
              ),

              /// Modifier
              _card(
                child: Column(
                  children: [
                    _label("Modifier: $modifier"),
                    Slider(
                      value: modifier.toDouble(),
                      min: -10,
                      max: 10,
                      divisions: 20,
                      onChanged: (v) =>
                          setState(() => modifier = v.toInt()),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// Result
              Text(
                "$total",
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              if (lastRolls.isNotEmpty)
                Text(
                  "Rolls: $lastRolls",
                  style: const TextStyle(color: Color.fromARGB(144, 255, 255, 255)),
                ),

              const SizedBox(height: 15),

              

              /// Roll button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 61, 106),
                          Color.fromARGB(255, 255, 48, 33),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ElevatedButton(
                      onPressed: rollDice,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                        shadowColor: const Color.fromARGB(0, 0, 0, 0),
                        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "ROLL",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// History
              const Text(
                "Roll History",
                style: TextStyle(color: Color.fromARGB(174, 255, 255, 255)),
              ),

              Expanded(
                
                child: SafeArea(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: rollHistory.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.08),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            rollHistory[index],
                            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helpers
  Widget _card({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: child,
        ),
      ),
    );
  }

  

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(color: Color.fromARGB(164, 255, 255, 255)),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 100; // Added Energy Level
  Color petColor = Colors.yellow;
  Timer? _hungerTimer;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _updateHappiness();
        _updatePetColor();
        _checkWinLossCondition();
      });
    });
  }

  void _playWithPet() {
    setState(() {
      if (energyLevel > 10) {
        // Prevents negative energy
        happinessLevel = (happinessLevel + 10).clamp(0, 100);
        energyLevel = (energyLevel - 10).clamp(0, 100);
        _updateHunger();
        _updatePetColor();
        _checkWinLossCondition();
      }
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      energyLevel = (energyLevel + 5).clamp(0, 100); // Increase Energy
      _updateHappiness();
      _updatePetColor();
      _checkWinLossCondition();
    });
  }

  void _updateHappiness() {
    if (hungerLevel > 70) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 5).clamp(0, 100);
    }
  }

  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  void _updatePetColor() {
    if (happinessLevel > 70) {
      petColor = Colors.green;
    } else if (happinessLevel >= 30) {
      petColor = Colors.yellow;
    } else {
      petColor = Colors.red;
    }
  }

  void _checkWinLossCondition() {
    if (happinessLevel >= 80) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🎉 You won! Your pet is very happy!")),
      );
    } else if (hungerLevel == 100 && happinessLevel <= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("😢 Game Over! Your pet is too hungry!")),
      );
    }
  }

  void _setPetName(String name) {
    setState(() {
      petName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Pet')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter pet's name",
              ),
              onSubmitted: _setPetName,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Name: $petName',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: petColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              'Hunger Level: $hungerLevel',
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              'Energy Level: $energyLevel',
              style: const TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: energyLevel / 100,
              color: Colors.blue,
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: const Text('Play with Your Pet'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: const Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    super.dispose();
  }
}

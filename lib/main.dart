import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Age Milestone App');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      if (screen != null) {
        setWindowFrame(Rect.fromCenter(
          center: screen.frame.center,
          width: windowWidth,
          height: windowHeight,
        ));
      }
    });
  }
}

class Counter with ChangeNotifier {
  int _age = 0;
  int get age => _age;

  void updateAge(double value) {
    _age = value.toInt();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Milestone App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Age Milestone App')),
      body: Consumer<Counter>(
        builder: (context, counter, child) {
          final int age = counter.age;
          String message;
          Color bgColor;

          if (age <= 12) {
            message = "You're a child!";
            bgColor = Colors.lightBlue.shade100;
          } else if (age <= 19) {
            message = "Teenager time!";
            bgColor = Colors.lightGreen.shade100;
          } else if (age <= 30) {
            message = "You're a young adult!";
            bgColor = Colors.yellow.shade100;
          } else if (age <= 50) {
            message = "You're an adult now!";
            bgColor = Colors.orange.shade100;
          } else {
            message = "Golden years!";
            bgColor = Colors.grey.shade300;
          }

          return Container(
            color: bgColor,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Your current age:'),
                Text(
                  '$age',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: age.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: age.toString(),
                  onChanged: (value) => context.read<Counter>().updateAge(value),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: age / 100,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    age <= 12
                        ? Colors.lightBlue
                        : age <= 19
                            ? Colors.lightGreen
                            : age <= 30
                                ? Colors.yellow
                                : age <= 50
                                    ? Colors.orange
                                    : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

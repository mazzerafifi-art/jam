import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ClockApp());
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AlarmPage(),
    const WorldClockPage(),
    const StopwatchPage(),
    const TimerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.alarm), label: 'Alarm'),
          NavigationDestination(icon: Icon(Icons.language), label: 'Jam dunia'),
          NavigationDestination(icon: Icon(Icons.timer_outlined), label: 'Stopwatch'),
          NavigationDestination(icon: Icon(Icons.hourglass_bottom), label: 'Pewaktu'),
        ],
      ),
    );
  }
}

// --- 1. HALAMAN ALARM (Ref: image_f12308.png) ---
class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua alarm nonaktif", style: TextStyle(fontSize: 18)),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          AlarmItem(time: "06.00", days: "M S S R K J S", isActive: false),
        ],
      ),
    );
  }
}

class AlarmItem extends StatelessWidget {
  final String time, days;
  final bool isActive;
  const AlarmItem({super.key, required this.time, required this.days, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: const TextStyle(fontSize: 42, color: Colors.black54)),
                Text(days, style: const TextStyle(letterSpacing: 2, color: Colors.blueGrey)),
              ],
            ),
            Switch(value: isActive, onChanged: (val) {}),
          ],
        ),
      ),
    );
  }
}

// --- 2. HALAMAN JAM DUNIA (Ref: image_f12341.png) ---
class WorldClockPage extends StatelessWidget {
  const WorldClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    String timeNow = DateFormat('HH:mm:ss').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(actions: [const Icon(Icons.add), const SizedBox(width: 15), const Icon(Icons.more_vert), const SizedBox(width: 10)]),
      body: Column(
        children: [
          Text(timeNow, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const Text("Waktu Indonesia Barat", style: TextStyle(color: Colors.blueGrey, fontSize: 16)),
          const SizedBox(height: 30),
          const WorldClockItem(city: "London", diff: "6 jam lebih lambat", time: "14.31", temp: "19°", icon: Icons.wb_sunny),
          const WorldClockItem(city: "Jakarta", diff: "Zona waktu lokal", time: "20.31", temp: "26°", icon: Icons.thunderstorm),
        ],
      ),
    );
  }
}

class WorldClockItem extends StatelessWidget {
  final String city, diff, time, temp;
  final IconData icon;
  const WorldClockItem({super.key, required this.city, required this.diff, required this.time, required this.temp, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(city, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(diff, style: const TextStyle(color: Colors.grey)),
          ]),
          Row(children: [
            Text(time, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 10),
            Column(children: [Icon(icon, color: Colors.orangeAccent), Text(temp)]),
          ])
        ],
      ),
    );
  }
}

// --- 3. HALAMAN STOPWATCH (Ref: image_f12361.png) ---
class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  void _toggle() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
        _timer?.cancel();
      } else {
        _stopwatch.start();
        _timer = Timer.periodic(const Duration(milliseconds: 30), (_) => setState(() {}));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var m = _stopwatch.elapsed.inMilliseconds;
    String hundreds = (m % 1000 ~/ 10).toString().padLeft(2, '0');
    String sec = (_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0');
    String min = (_stopwatch.elapsed.inMinutes % 60).toString().padLeft(2, '0');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        Text("$min : $sec , $hundreds", style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () => setState(() => _stopwatch.reset()), style: ElevatedButton.styleFrom(minimumSize: const Size(150, 60), backgroundColor: Colors.grey[300]), child: const Text("Putaran", style: TextStyle(color: Colors.black54))),
              ElevatedButton(onPressed: _toggle, style: ElevatedButton.styleFrom(minimumSize: const Size(150, 60), backgroundColor: Colors.blue[200]), child: Text(_stopwatch.isRunning ? "Berhenti" : "Mulai")),
            ],
          ),
        )
      ],
    );
  }
}

// --- 4. HALAMAN PEWAKTU (Ref: image_f12418.png) ---
class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [Text("Jam", style: TextStyle(color: Colors.grey)), Text("99", style: TextStyle(fontSize: 40, color: Colors.black12))]),
          SizedBox(width: 40),
          Column(children: [Text("Menit", style: TextStyle(color: Colors.grey)), Text("59", style: TextStyle(fontSize: 40, color: Colors.black12))]),
          SizedBox(width: 40),
          Column(children: [Text("Detik", style: TextStyle(color: Colors.grey)), Text("59", style: TextStyle(fontSize: 40, color: Colors.black12))]),
        ]),
        const Text("00 . 00 . 00", style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("01", style: TextStyle(fontSize: 40, color: Colors.black12)), SizedBox(width: 60),
          Text("01", style: TextStyle(fontSize: 40, color: Colors.black12)), SizedBox(width: 60),
          Text("01", style: TextStyle(fontSize: 40, color: Colors.black12)),
        ]),
        const SizedBox(height: 50),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _circle("00.10.00"), _circle("00.15.00"), _circle("00.30.00"),
        ]),
        const SizedBox(height: 50),
        ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(minimumSize: const Size(180, 60), backgroundColor: Colors.blue[100]), child: const Text("Mulai")),
      ],
    );
  }

  Widget _circle(String t) => Container(
    margin: const EdgeInsets.all(10),
    height: 90, width: 90,
    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
    alignment: Alignment.center, child: Text(t),
  );
}
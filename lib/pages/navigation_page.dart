import 'package:flutter/material.dart';
import 'package:indrieye/views/obstacle_view.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  static const List<Widget> _pages = [
    ObstacleView(),
    ObstacleView(),
  ];
  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.fence),
      label: 'Obstacle Detection',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.text_fields),
      label: 'Text Reader',
    ),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Indrieye"),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, "/settings"),
            icon: const Icon(Icons.account_circle),
          )
        ],
      ),
      body: AnimatedSwitcher(
        duration: Durations.medium1,
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: _navItems,
      ),
    );
  }
}

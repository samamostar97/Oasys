import 'package:flutter/material.dart';

class AppShell extends StatelessWidget {
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppShell({super.key, required this.body,
      required this.selectedIndex, required this.onDestinationSelected});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Row(children: [
      NavigationRail(
        extended: MediaQuery.of(context).size.width > 1200,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: const [
          NavigationRailDestination(icon: Icon(Icons.home_outlined),     selectedIcon: Icon(Icons.home),     label: Text('Home')),
          NavigationRailDestination(icon: Icon(Icons.list_outlined),     selectedIcon: Icon(Icons.list),     label: Text('Items')),
          NavigationRailDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: Text('Settings')),
        ],
      ),
      const VerticalDivider(width: 1, thickness: 1),
      Expanded(child: body),
    ]),
  );
}

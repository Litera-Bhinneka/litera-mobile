import 'package:flutter/material.dart';
import 'package:litera_mobile/apps/exchange/screens/list_offers.dart';
import 'package:litera_mobile/apps/exchange/screens/list_owners.dart';
import 'package:litera_mobile/apps/recommendation/screens/show_recommend.dart';
import 'package:litera_mobile/apps/review/pages/show_review.dart';

/// Flutter code sample for [NavigationBar].

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Color(0xFF0F5756),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.chrome_reader_mode),
            icon: Icon(Icons.chrome_reader_mode_outlined),
            label: 'Catalog',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.recommend),
            icon: Icon(Icons.recommend_outlined),
            label: 'Recommendation',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.handshake),
            icon: Icon(Icons.handshake_outlined),
            label: 'Exchange',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        /// Catalog Page
        ShowReview(book_id: 35),

        /// Recommendation page
        ShowRecommendation(),

        /// Exchange page
        ListOffers(),
        // ListOwners(id: 2),

        /// Profile page
        SampleHomePage(),
      ][currentPageIndex],
    );
  }
}

class SampleHomePage extends StatelessWidget {
  const SampleHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.all(8.0),
      child: SizedBox.expand(
        child: Center(
          child: Text(
            'Home page',
            style: theme.textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}

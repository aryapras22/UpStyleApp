// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class BrowsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Browse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: [
            BrowseCard(
              title: 'Casual',
              imagePath: 'assets/images/casual.png',
              color: Colors.pink,
            ),
            BrowseCard(
              title: 'Formal',
              imagePath: 'assets/images/formal.png',
              color: Colors.blue,
            ),
            BrowseCard(
              title: 'Dark Academia',
              imagePath: 'assets/images/live_events.png',
              color: Colors.brown,
            ),
            BrowseCard(
              title: 'Vintage',
              imagePath: 'assets/made_for_you.png',
              color: Colors.black,
            ),
            BrowseCard(
              title: 'New Releases',
              imagePath: 'assets/new_releases.png',
              color: Colors.red,
            ),
            BrowseCard(
              title: 'Ramadan',
              imagePath: 'assets/ramadan.png',
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}

class BrowseCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color color;

  BrowseCard(
      {required this.title, required this.imagePath, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: () {
          // Handle card tap
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
            //   child: Image.asset(
            //     imagePath,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

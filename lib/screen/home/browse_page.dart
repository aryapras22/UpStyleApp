// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:upstyleapp/screen/home/genre_page.dart';

class BrowsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Browse'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            BrowseCard(
              title: 'Casual',
              imageUrl: 'assets/images/casual.png',
              backgroundColor: Color.fromARGB(255, 106, 112, 124),
              textColor: Colors.white,
            ),
            BrowseCard(
              title: 'Formal',
              imageUrl: 'assets/images/formal.png',
              backgroundColor: Color.fromARGB(255, 238, 99, 56),
              textColor: Colors.white,
            ),
            BrowseCard(
              title: 'Monokrom',
              imageUrl: 'assets/images/monokrom.png',
              backgroundColor: Colors.white,
              textColor: Color.fromARGB(255, 238, 99, 56),
            ),
            BrowseCard(
              title: 'Vintage',
              imageUrl: 'assets/images/vintage.png',
              backgroundColor: Color.fromARGB(255, 150, 150, 150),
              textColor: Colors.white,
            ),
            BrowseCard(
              title: '90\'s',
              imageUrl: 'assets/images/90s.png',
              backgroundColor: Color.fromARGB(255, 106, 112, 124),
              textColor: Colors.white,
            ),
            BrowseCard(
              title: 'Earth Tone',
              imageUrl: 'assets/images/earth_tone.png',
              backgroundColor: Color.fromARGB(255, 238, 99, 56),
              textColor: Colors.white,
            ),
            BrowseCard(
              title: 'y2k',
              imageUrl: 'assets/images/y2k.png',
              backgroundColor: Color.fromARGB(255, 150, 150, 150),
              textColor: Colors.white,
            ),
            BrowseCard(
              title: 'Sporty',
              imageUrl: 'assets/images/sporty.png',
              backgroundColor: Colors.white,
              textColor: Color.fromARGB(255, 238, 99, 56),
            ),
          ],
        ),
      ),
    );
  }
}

class BrowseCard extends StatelessWidget {

  final String title;
  final String imageUrl;
  final Color backgroundColor;
  final Color textColor;

  const BrowseCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenrePage(genre: title),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 16.0),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                height: 100.0,
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }


  // final String title;
  // final String imagePath;
  // final Color color;

  // BrowseCard(
  //     {required this.title, required this.imagePath, required this.color});

  // @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     color: color,
  //     child: InkWell(
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => GenrePage(genre: title),
  //           ),
  //         );
  //       },
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SizedBox(height: 8.0),
  //           Text(
  //             title,
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 16.0,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

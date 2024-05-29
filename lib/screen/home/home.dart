// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:upstyleapp/widgets/post_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Center(
            child: Text('Upload your clothes',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  // Handle image upload
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: Theme.of(context).colorScheme.primary,
                  dashPattern: [6, 3],
                  strokeWidth: 2,
                  radius: Radius.circular(10),
                  child: SizedBox(
                    width: 500,
                    height: 100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/icons/upload_active.png'),
                          Text(
                            "Upload your image here",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Type an image caption...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.grey, width: 1, style: BorderStyle.solid),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle upload
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                    child:
                        Text('Upload', style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 310,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    height: 330,
                    decoration: BoxDecoration(
                      // bottom left and right radius
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                          image: Image.asset(
                            'assets/images/home_cover.png',
                          ).image,
                          fit: BoxFit.fill),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 150, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lorem Ipsum',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Center(
                            child: Text(
                              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showUploadDialog(context);
                          },
                          icon: Image.asset('assets/icons/upload.png'),
                          label: Text('Upload your clothes',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                // use theme data font
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverPersistentHeaderDelegate(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              focusColor: Colors.white,
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Lorem Ipsum is simply',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).colorScheme.tertiary,
                                size: 25,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.filter_list,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // recommended for you row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recommended for you',
                            style: Theme.of(context).textTheme.titleLarge),
                        // icon next
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text('Trend'),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(color: Colors.white),
                          // remove outline
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Chip(
                          label: Text('Nearby'),
                          backgroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                        ),
                        Chip(label: Text('Nearby')),
                        Chip(label: Text('Nearby')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: PostCard());
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:upstyleapp/model/post.dart';
import 'package:upstyleapp/screen/home/recommended_screen.dart';
import 'package:upstyleapp/services/post_service.dart';
import 'package:upstyleapp/widgets/post_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> implements TickerProviderStateMixin<Home> {
  final TextEditingController _captionController = TextEditingController();
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }

  @override
  void initState() {
    _postService.getUserRole().then((value) {
      setState(() {
        userRole = value;
      });
    });
    _filterController = TabController(length: filters.length, vsync: this);
    // _filterController.addListener(() {
    //   setState(() {
    //     int index = _filterController.index;
    //     posts.clear();
    //     _fetchData();
    //   });
    // });
    _fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _captionController.dispose();
    _filterController.dispose();
    super.dispose();
  }

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = true;
  final PostService _postService = PostService();
  List<Post> posts = [];
  List<Post> searchPosts = [];
  List<String> filters = ['All', 'Trends', 'Designers', 'Users'];
  late TabController _filterController;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final SearchController _searchController = SearchController();

  void search(query) async {
    if (query.isNotEmpty) {
      searchPosts = posts
          .where((post) =>
              post.caption.toLowerCase().contains(query.toLowerCase()) ||
              post.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        posts = searchPosts;
      });
      return;
    } else {
      posts.clear();
      await _fetchData();
    }
  }

  void _onRefresh() async {
    posts.clear();
    try {
      await _fetchData();
    } catch (e) {
      _refreshController.refreshFailed();
    }
    _refreshController.refreshCompleted();
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Center(
              child: Row(
                children: [
                  Text('Upload your clothes',
                      style: Theme.of(context).textTheme.titleLarge!),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () async {
                      final pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 80);
                      setState(() {
                        if (pickedFile != null) {
                          _image = File(pickedFile.path);
                        } else {
                          SnackBar(
                            content: Text('No image selected.'),
                          );
                        }
                      });
                    },
                    child: _image == null
                        ? DottedBorder(
                            borderType: BorderType.RRect,
                            color: Theme.of(context).colorScheme.primary,
                            dashPattern: [6, 3],
                            strokeWidth: 2,
                            radius: Radius.circular(10),
                            child: SizedBox(
                              width: 500,
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                        'assets/icons/upload_active.png'),
                                    Text(
                                      "Upload your image here",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: SizedBox(
                              width: 500,
                              height: 300,
                              child: Center(
                                child: Ink.image(
                                  image: Image.file(_image!).image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )),
                SizedBox(height: 10),
                TextField(
                  controller: _captionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Type an image caption...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_image == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please select an image.'),
                      ));
                      return;
                    }
                    if (_captionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter a caption.'),
                      ));
                      return;
                    }
                    // upload post
                    _uploadPost(context);
                    Navigator.of(context).pop();
                    // pop up success message with picture
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          title: Center(
                            child: Row(
                              children: [
                                Text('Upload successful',
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    //clear the image and caption
                                    _image = null;
                                    _captionController.clear();
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/images/upload_success.png'),
                              SizedBox(height: 10),
                              Text(
                                'Your image has been uploaded successfully.',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Center(
                      child: Text('Upload',
                          style: TextStyle(color: Colors.white))),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _uploadPost(context) async {
    try {
      await _postService.createPost(_captionController.text, _image!, userRole);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again.'),
      ));
    }
  }

  String userRole = 'customer';

  Future<void> _fetchData() async {
    setState(() {
      posts.clear();
    });
    var allPost =
        await _postService.filteredPost(filters[_filterController.index]);
    if (allPost.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    String name = '';
    String avatar = '';

    for (var doc in allPost) {
      var value = await _postService.getUserData(doc['user_id']);
      name = value['name'];
      avatar = value['imageUrl'];
      posts.add(
        Post(
          id: doc.id,
          name: name,
          userAvatar: avatar,
          postImage: doc['image_url'],
          caption: doc['text'],
          time: doc['created_at'].toString(),
          userId: doc['user_id'],
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      physics: BouncingScrollPhysics(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 330,
                  decoration: BoxDecoration(
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
                  padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'StyleLagi',
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
                            'From drab to fab, #StyleLagi your outfits everyday',
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        search(value);
                      },
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Search your styles...',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended for you',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // icon next
                  GestureDetector(
                    onTap: () {
                      // push to reccomended screen
                      MaterialPageRoute(
                          builder: (context) => RecommendedScreen());
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            DefaultTabController(
              length: filters.length,
              child: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: TabBar(
                      onTap: (index) async {
                        setState(() {
                          isLoading = true;
                          posts.clear();
                        });
                        await _fetchData();
                        setState(() {
                          isLoading = false;
                        });
                      },
                      controller: _filterController,
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelColor: Theme.of(context).colorScheme.surface,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.tertiary,
                      tabs: [
                        for (var filter in filters)
                          Text(
                            filter,
                          )
                      ],
                    )),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        for (var post in posts)
                          PostCard(
                            post: post,
                          ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

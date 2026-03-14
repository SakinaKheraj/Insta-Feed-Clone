import 'package:flutter/material.dart';
import 'package:insta_feed_clone/widgets/story_tray.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Instagram",
          style: TextStyle(
            fontFamily: 'InstaFont',
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.add, size: 28)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border, size: 28),
          ),
        ],
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.black, 
      ),
      body: ListView.builder(
        itemCount: 10 + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const StoryTray();
          }

          // Posts placeholder
          return Container(
            height: 400,
            color: Colors.grey[900],
            margin: const EdgeInsets.only(bottom: 10),
            child: const Center(
              child: Text(
                'Post Placeholder',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}


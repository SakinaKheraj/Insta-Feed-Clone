import 'package:flutter/material.dart';

class StoryTray extends StatelessWidget {
  const StoryTray({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock user list for stories
    final List<Map<String, String>> stories = [
      {
        "username": "Your Story",
        "avatar":
            "https://plus.unsplash.com/premium_photo-1701065893190-46f44657fbee?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjV8fGluc3RhZ3JhbSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D",
        "isUser": "true",
      },
      {
        "username": "natgeo",
        "avatar":
            "https://images.unsplash.com/photo-1532667449560-72a95c8d381b?auto=format&fit=crop&w=200&q=80",
      },
      {
        "username": "tech_reviews",
        "avatar":
            "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=200&q=80",
      },
      {
        "username": "puppy_love",
        "avatar":
            "https://plus.unsplash.com/premium_photo-1718060728038-f2170c36df79?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTE3fHxwdXBweXxlbnwwfHwwfHx8MA%3D%3D",
      },
      {
        "username": "daily_coffee",
        "avatar":
            "https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=200&q=80",
      },
    ];

    return Container(
      height: 150,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white24, 
            width: 0.5,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        itemBuilder: (context, index) {
          final story = stories[index];
          final isUser = story['isUser'] == 'true';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isUser
                            ? null
                            : const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 221, 106, 13),
                                  Color.fromARGB(255, 233, 201, 44),
                                  Color.fromARGB(255, 245, 61, 144),
                                  Color.fromARGB(255, 244, 37, 220),
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(isUser ? 0 : 3.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(story['avatar']!),
                              backgroundColor: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isUser)
                      Positioned(
                        bottom: 0,
                        right: 15,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2), 
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 18,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  story['username']!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

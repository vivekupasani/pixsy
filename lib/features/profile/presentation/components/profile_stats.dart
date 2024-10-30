import 'package:flutter/material.dart';

class ProfileStats extends StatefulWidget {
  final String followerCount;
  final String followingCount;
  final String postCount;
  final void Function()? onTap;
  const ProfileStats(
      {super.key,
      required this.followerCount,
      required this.followingCount,
      required this.postCount,
      required this.onTap});

  @override
  State<ProfileStats> createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //post count
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  widget.postCount,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "Posts",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
      
          //followers count
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  widget.followerCount,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "Follower",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
      
          //following count
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(
                  widget.followingCount,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "Following",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

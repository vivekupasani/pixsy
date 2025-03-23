// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:pixsy/responsive/magic_box.dart';

class FollowUnfollowBtn extends StatefulWidget {
  void Function()? onPressed;
  final bool isFollowing;

  FollowUnfollowBtn(
      {super.key, required this.isFollowing, required this.onPressed});

  @override
  State<FollowUnfollowBtn> createState() => _FollowUnfollowBtnState();
}

class _FollowUnfollowBtnState extends State<FollowUnfollowBtn> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: MagicBox(
        maxWidth: 420,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: SizedBox(
            width: double.infinity, // Make the button take full width
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isFollowing
                    ? Theme.of(context).colorScheme.primary
                    : Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 22),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text(
                widget.isFollowing ? "Unfollow" : "Follow",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

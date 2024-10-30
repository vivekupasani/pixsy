import 'package:flutter/material.dart';
import 'package:pixsy/features/profile/domain/profile_user.dart';

class UserTile extends StatefulWidget {
  final ProfileUser? user;
  final void Function()? onTap;
  const UserTile({super.key, required this.user, required this.onTap});

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: widget.onTap,
        title: Text(widget.user!.name),
        subtitle: Expanded(
            child: Text(
          widget.user!.email,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        )),
        trailing: Icon(
          Icons.arrow_forward,
          color: Theme.of(context).colorScheme.primary,
        ),
        leading: Icon(
          Icons.person,
          color: Theme.of(context).colorScheme.primary,
        ));
  }
}

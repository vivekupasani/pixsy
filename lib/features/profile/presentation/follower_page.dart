import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixsy/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:pixsy/features/profile/presentation/profile_page.dart';

class FollowerPage extends StatefulWidget {
  final List<String> followers;
  final List<String> following;
  final String username;
  const FollowerPage(
      {super.key,
      required this.followers,
      required this.following,
      required this.username});

  @override
  State<FollowerPage> createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.username),
            foregroundColor: Theme.of(context).colorScheme.primary,
            bottom: TabBar(
                dividerColor: Colors.transparent,
                labelColor: Theme.of(context).colorScheme.inversePrimary,
                unselectedLabelColor: Theme.of(context).colorScheme.primary,
                tabs: const [
                  Tab(text: "Followers"),
                  Tab(text: "Following"),
                ]),
          ),
          body: TabBarView(children: [
            _buildFollowerPage(widget.followers, "No follower", context),
            _buildFollowingPage(widget.following, "No following", context)
          ]),
        ));
  }

  Widget _buildFollowerPage(
      List<String> uids, String emptyMessage, BuildContext context) {
    if (uids.isEmpty) {
      return Center(
        child: Text(emptyMessage),
      );
    } else {
      return ListView.builder(
        itemCount: uids.length,
        itemBuilder: (context, index) {
          final uid = uids[index];

          return FutureBuilder(
            future: context.read<ProfileCubit>().getUserProfile(uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(uid: uid),
                          ));
                    },
                    title: Text(user!.name),
                    subtitle: Text(
                      user.email,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                    ));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(),
                );
              }

              return const SizedBox();
            },
          );
        },
      );
    }
  }

  Widget _buildFollowingPage(
      List<String> uids, String emptyMessage, BuildContext context) {
    if (uids.isEmpty) {
      return Center(
        child: Text(emptyMessage),
      );
    } else {
      return ListView.builder(
        itemCount: uids.length,
        itemBuilder: (context, index) {
          final uid = uids[index];

          return FutureBuilder(
            future: context.read<ProfileCubit>().getUserProfile(uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(uid: uid),
                          ));
                    },
                    title: Text(user!.name),
                    subtitle: Text(
                      user.email,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                    ));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SizedBox(),
                );
              }
              return const SizedBox();
            },
          );
        },
      );
    }
  }
}

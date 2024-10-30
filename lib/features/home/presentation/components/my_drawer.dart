import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixsy/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:pixsy/features/home/presentation/components/my_drawer_tile.dart';
import 'package:pixsy/features/profile/presentation/profile_page.dart';
import 'package:pixsy/features/search/presentation/search_page.dart';
import 'package:pixsy/features/settings/presentation/settings_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // App logo
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Icon(
                    Icons.person,
                    size: 82,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                // Home tile
                MyDrawerTile(
                    title: "H O M E",
                    icon: Icons.home,
                    onTap: () {
                      Navigator.pop(context);
                    }),
                // Profile tile
                MyDrawerTile(
                    title: "P R O F I L E",
                    icon: Icons.person,
                    onTap: () {
                      Navigator.pop(context);
                      final user =
                          context.read<AuthenticationCubit>().currentuser;
                      String userId = user!.uid;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              uid: userId,
                            ),
                          ));
                    }),

                // Search tile
                MyDrawerTile(
                    title: "S E A R C H",
                    icon: Icons.search,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchPage(),
                          ));
                    }),
                // Settings tile
                MyDrawerTile(
                  title: "S E T T I N G S",
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                  },
                ),
              ],
            ),
            // Logout tile
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: MyDrawerTile(
                  title: "L O G O U T",
                  icon: Icons.logout,
                  onTap: () async {
                    final authCubit = context.read<AuthenticationCubit>();
                    authCubit.signOut();
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

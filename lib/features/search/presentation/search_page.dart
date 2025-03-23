import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixsy/features/authentication/presentation/components/my_textfield.dart';
import 'package:pixsy/features/profile/presentation/profile_page.dart';
import 'package:pixsy/features/search/presentation/cubit/search_cubit.dart';
import 'package:pixsy/responsive/magic_box.dart';
import 'package:pixsy/responsive/scaffold_responsive.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();

  void search() {
    final query = searchController.text;
    context.read<SearchCubit>().searchUser(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(search);
  }

  @override
  void dispose() {
    searchController.removeListener(search);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S E A R C H"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search textfield
          Center(
            child: MagicBox(
              maxWidth: 720,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MyTextField(
                  Controller: searchController,
                  hint: "Search...",
                  obscureText: false,
                ),
              ),
            ),
          ),

          // List of users
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchLoaded) {
                  final result = state.user;

                  if (result.isEmpty) {
                    return const Center(
                      child: Text("No user found"),
                    );
                  }

                  return ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      final eachUser = result[index];
                      return Center(
                        child: MagicBox(
                          maxWidth: 620,
                          child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfilePage(uid: eachUser.uid),
                                    ));
                              },
                              title: Text(eachUser!.name),
                              subtitle: Text(
                                eachUser.email,
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
                              )),
                        ),
                      );
                    },
                  );
                } else if (state is SearchError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                return const Center(
                  child: Text(
                    "Start searching for user...",
                    style: TextStyle(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

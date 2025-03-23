import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixsy/features/authentication/domain/app_user.dart';
import 'package:pixsy/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:pixsy/features/chatting/presentation/chatting_page.dart';
import 'package:pixsy/features/search/presentation/cubit/search_cubit.dart';
import 'package:pixsy/responsive/magic_box.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  Appuser? currentUser;

  @override
  void initState() {
    final searchCubit = context.read<SearchCubit>();
    searchCubit.searchUser('');
    super.initState();
    final authCubit = context.read<AuthenticationCubit>();
    setState(() {
      currentUser = authCubit.currentuser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("C H A T S"),
          centerTitle: true,
        ),
        body: BlocConsumer<SearchCubit, SearchState>(
          listener: (context, state) {},
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
                      maxWidth: 820,
                      child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChattingPage(
                                    eachUser: eachUser,
                                    isOwn: currentUser!.uid == eachUser.uid
                                        ? true
                                        : false,
                                  ),
                                ));
                          },
                          title: Text(currentUser!.uid == eachUser!.uid
                              ? "${eachUser.name}(Me)"
                              : eachUser.name),
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
        ));
  }
}

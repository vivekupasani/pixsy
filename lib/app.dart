import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixsy/features/authentication/data/auth_firebase_repo.dart';
import 'package:pixsy/features/authentication/domain/auth_repo.dart';
import 'package:pixsy/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:pixsy/features/authentication/presentation/login_or_register_page.dart';
import 'package:pixsy/features/home/presentation/Home_page.dart';
import 'package:pixsy/features/posts/data/post_firebase_repo.dart';
import 'package:pixsy/features/posts/presentation/cubit/post_cubit.dart';
import 'package:pixsy/features/profile/data/profile_firebase_repo.dart';
import 'package:pixsy/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:pixsy/features/search/data/search_firebase_repo.dart';
import 'package:pixsy/features/search/presentation/cubit/search_cubit.dart';
import 'package:pixsy/features/storage/data/storage_firebase_repo.dart';
import 'package:pixsy/theme/cubit/theme_cubit.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final AuthRepo authRepo = AuthFirebaseRepo();

  final ProfileFirebaseRepo profileRepo = ProfileFirebaseRepo();

  final StorageFirebaseRepo storageRepo = StorageFirebaseRepo();

  final PostFirebaseRepo postRepo = PostFirebaseRepo();

  final SearchFirebaseRepo searchRepo = SearchFirebaseRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          //authentication cubit
          BlocProvider(
            create: (context) => AuthenticationCubit(authRepo)..checkAuth(),
          ),

          //profile cubit
          BlocProvider(
            create: (context) => ProfileCubit(profileRepo, storageRepo),
          ),

          //search cubit
          BlocProvider(
            create: (context) => SearchCubit(searchRepo),
          ),

          //post cubit
          BlocProvider(
            create: (context) => PostCubit(postRepo, storageRepo),
          ),

          //theme cubit
          BlocProvider(
            create: (context) => ThemeCubit(),
          )
        ],
        child: BlocBuilder<ThemeCubit, ThemeData>(
          builder: (context, state) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'V A S U D E V  T E C H N O L O G Y',
            theme: state,
            themeAnimationCurve: Curves.decelerate,
            themeAnimationDuration: const Duration(milliseconds: 1),
            home: BlocConsumer<AuthenticationCubit, AuthenticationState>(
              listener: (context, state) {},
              builder: (context, state) {
                //state is unauthenticated
                if (state is Unauthenticated) {
                  return const LoginOrRegisterPage();
                  //state is authenticated
                } else if (state is Authenticated) {
                  return const HomePage();
                  //state is AuthError
                } else if (state is AuthError) {
                  // Show a snackbar for the error
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  });
                  // Provide a fallback widget, e.g., the login screen
                  return const LoginOrRegisterPage();
                } else {
                  //show loading
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
        ));
  }
}

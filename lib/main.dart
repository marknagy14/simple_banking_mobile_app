
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grip/screens/home_screen.dart';
import 'package:grip/screens/splash_screen.dart';

import 'cubit/app_cubit.dart';
import 'cubit/bloc_ovserver.dart';
import 'database/repository/repository.dart';
import 'database/repository/sqlite_repository.dart';

Future<void> main() async {



  Bloc.observer = MyBlocObserver();

  final repository = SqliteRepository();
  // await repository.init();

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {

  final Repository repository;

  const MyApp({
    required this.repository,
    Key? key
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(repository: repository)..getAllTransfers(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
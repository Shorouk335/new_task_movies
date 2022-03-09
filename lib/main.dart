
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_task/Layout/HomeScreen.dart';
import 'package:movies_app_task/Shared/bloc/cubit.dart';
import 'package:movies_app_task/Shared/bloc/states.dart';
import 'package:movies_app_task/shared/DioHelper.dart';

main(context){
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return BlocProvider(
        create: (BuildContext context) =>MoviesCubit()..createDataBase(),
        child: BlocConsumer<MoviesCubit, MoviesState>(
        listener: (context, state) {},
    builder: (context, state) {
       return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark().copyWith(
                scaffoldBackgroundColor: Colors.black,
                appBarTheme: AppBarTheme(
                    color: Colors.black87
                )
            ),
            home: HomeScreen(), );
    },
        ),
   );
  }
}

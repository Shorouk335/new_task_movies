import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_task/Layout/NowPlayingScreen.dart';
import 'package:movies_app_task/Layout/PopularScreen.dart';
import 'package:movies_app_task/Layout/TopScreen.dart';
import 'package:movies_app_task/Shared/ItemBuilder/checkConnectionItem.dart';
import 'package:movies_app_task/Shared/bloc/cubit.dart';
import 'package:movies_app_task/Shared/bloc/states.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    MoviesCubit.get(context).subscription = MoviesCubit.get(context)
        .simpleConnectionChecker
        .onConnectionChange
        .listen((connected) {
      if (connected)
        MoviesCubit.get(context).ChangeMessage("Connected");
      else
        MoviesCubit.get(context).ChangeMessage("Not connected");
    });
      MoviesCubit.get(context).LoadAllData();
    super.initState();
    }

  void dispose() {
    MoviesCubit.get(context).subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer < MoviesCubit,MoviesState>(
      listener: (context ,state){},
      builder:(context ,state){
        return  DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Movies App",
                style: TextStyle(fontSize: 30.0, color: Colors.red),
              ),
              bottom: TabBar(
                indicatorColor: Colors.white,
                labelStyle: TextStyle(fontSize: 18.0),
                tabs: [
                  Tab(
                    child: Text("Top Movies"),
                  ),
                  Tab(
                    child: Text("Popular"),
                  ),
                  Tab(
                    child: Text("Now Playing"),
                  ),
                ],
              ),
            ),
            body: (MoviesCubit.get(context).message == "Not connected")
                ? checkConnectionItem()
           : TabBarView(
                children: [
                        TopScreen(),
                         PopularScreen(),
                          NowPlayingScreen()
                      ]
            )          )
        ); }
    );
  }
}

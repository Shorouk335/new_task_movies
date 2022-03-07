import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_task/Shared/ItemBuilder/MoviesItems.dart';
import 'package:movies_app_task/Shared/bloc/cubit.dart';
import 'package:movies_app_task/Shared/bloc/states.dart';

class NowPlayingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoviesCubit,MoviesState>(
      listener: (context ,state){},
      builder:(context ,state){
        MoviesCubit cubit = MoviesCubit.get(context);
        cubit.getNowMoviesDataFromApi();
        return ConditionalBuilder(
          condition: cubit.NowPlayingList.isEmpty,
          builder:(context)=> Center(child: CircularProgressIndicator(color: Colors.red,),) ,
          fallback:(context)=> MoviesItems(cubit.NowPlayingList,context,"now_playing"), );
      } ,
    );
  }
}

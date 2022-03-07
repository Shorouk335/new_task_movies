import 'package:flutter/material.dart';
import 'package:movies_app_task/Layout/DetialsScreen.dart';
import 'package:movies_app_task/Shared/bloc/cubit.dart';
Widget MoviesItems ( List <dynamic> model ,context ,String type){
  return RefreshIndicator(
    color: Colors.red,
    onRefresh: () async {
      if (type == "top_rated")
     {
       MoviesCubit.get(context).TopMoviesList = [];
      MoviesCubit.get(context).getTopMoviesDataFromApi();
     } else if  (type == "popular"){
        MoviesCubit.get(context).PopularList = [];
        MoviesCubit.get(context).getPopularMoviesDataFromApi();
      }else {
        MoviesCubit.get(context).NowPlayingList = [];
        MoviesCubit.get(context).getNowMoviesDataFromApi();
      }

    },
    child: Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: model.length ,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              MoviesCubit.get(context).ChangeDetialsData(model[index]);
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return DetialsScreen();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  children: [
                    Image(
                      fit: BoxFit.fitWidth,
                      height: MediaQuery.of(context).size.height / 2.5,
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500${model[index]["poster_path"]}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${model[index]["title"]}",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
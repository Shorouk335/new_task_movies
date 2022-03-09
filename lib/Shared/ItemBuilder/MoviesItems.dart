import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_task/Layout/DetialsScreen.dart';
import 'package:movies_app_task/Shared/bloc/cubit.dart';
import 'package:movies_app_task/Shared/bloc/states.dart';

Widget MoviesItems(List<dynamic> model, context, String type) {
  return BlocConsumer<MoviesCubit, MoviesState>(
    listener: (context, state) {},
    builder: (context, state) {
      MoviesCubit cubit = MoviesCubit.get(context);
      return Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: model.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BlocProvider(
                        create: (BuildContext context) => MoviesCubit(),
                        child: BlocConsumer<MoviesCubit, MoviesState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            MoviesCubit.get(context)
                                .ChangeDetialsData(model[index]);
                            return DetialsScreen();
                          },
                        ),
                      );
                    },
                  ),
                );
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
      );
    },
  );
}

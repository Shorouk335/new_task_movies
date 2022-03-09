import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_task/Shared/ItemBuilder/checkConnectionItem.dart';
import 'package:movies_app_task/Shared/bloc/cubit.dart';
import 'package:movies_app_task/Shared/bloc/states.dart';

class DetialsScreen extends StatefulWidget {
  @override
  State<DetialsScreen> createState() => _DetialsScreenState();
}

class _DetialsScreenState extends State<DetialsScreen> {
  Color star1 = Colors.white54;

  Color star2 = Colors.white54;

  Color star3 = Colors.white54;

  void changrColor(vote) {
    if (vote >= 6 && vote <= 7)
      setState(() {
        this.star1 = Colors.yellow;
      });
    else if (vote >= 7 && vote <= 8)
      setState(() {
        this.star1 = Colors.yellow;
        this.star2 = Colors.yellow;
      });
    else if (vote >= 8 && vote <= 9)
      setState(() {
        this.star1 = Colors.yellow;
        this.star2 = Colors.yellow;
        this.star3 = Colors.yellow;
      });
    else {}
  }

  @override
  Widget build(BuildContext context) {
        MoviesCubit cubit = MoviesCubit.get(context);
        changrColor(cubit.vote_average!);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Movie Details",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
            centerTitle: true,
          ),
          body: (cubit.message == "Not connected")
              ? checkConnectionItem()
              : Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Stack(
                      children: [
                        Image(
                          fit: BoxFit.fitWidth,
                          height: MediaQuery.of(context).size.height / 2,
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/w500${cubit.poster_path!}"),
                        ),
                        Positioned(
                            right: 3,
                            child: Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 55.0,
                            )),
                        Positioned(
                            top: 20,
                            right: 20,
                            child: Text(
                              "${cubit.vote_average!}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Text(
                    "${cubit.title!}",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "${cubit.overview!}",
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                            overflow: TextOverflow.fade),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: this.star1,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: this.star2,
                              size: 20,
                            ),
                            Icon(
                              Icons.star,
                              color: this.star3,
                              size: 20,
                            ),
                          ],
                        ),
                        Text(
                          "${cubit.original_language!}",
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ]),
        );


  }
}

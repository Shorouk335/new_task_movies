import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app_task/Shared/bloc/states.dart';
import 'package:movies_app_task/shared/DioHelper.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:sqflite/sqflite.dart';

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit() : super(initalMoviesState()) ;
  static MoviesCubit get(context) => BlocProvider.of(context);

  //connection of internet
  String message = '';
  void ChangeMessage(value) {
    message = value;
    emit(changeMessageState());
  }

  StreamSubscription? subscription;
  SimpleConnectionChecker simpleConnectionChecker = SimpleConnectionChecker()
    ..setLookUpAddress('pub.dev');

  // object from DataBase
  Database? MoviesDataBase11;
  //List of Movies

  List<dynamic> TopMoviesList = [];
  List<dynamic> PopularList = [];
  List<dynamic> NowPlayingList = [];

  //Data of DetailsScreen
  String? title;
  String? poster_path;
  String? overview;
  dynamic vote_average;
  String? original_language;

  void ChangeDetialsData(Map<String ,dynamic> model){
    title = model["title"];
    poster_path = model["poster_path"];
    overview = model["overview"];
    vote_average = model["vote_average"];
    original_language = model["original_language"];
    emit(changeDetailsDataState());

  }

//create database and table

  void createDataBase() async {
    await openDatabase('movies11.dp', version: 1,
        onCreate: (MoviesDataBase11, vesion) async {
      await MoviesDataBase11.execute(
              'CREATE TABLE moviesdb (id INTEGER PRIMARY KEY, title TEXT ,poster_path TEXT ,overview TEXT , vote_average DOUBLE , original_language TEXT ,Type Text)')
          .then((value) {
        print("create db");
      }).catchError((onError) {});
    }, onOpen: (MoviesDataBase11) {
      getDataFromDataBase(MoviesDataBase11);
    }
    ).then((value) {
      MoviesDataBase11 = value;
      emit(CreateDataBaseState());
    });
  }

//insert from database
  Future insertIntoDataBase({
   required String? title ,
   required String? poster_path,
   required String? overview,
   required dynamic vote_average,
   required String? original_language,
    required String? Type ,

  }) async {
    await MoviesDataBase11?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO moviesdb (title,poster_path,overview , vote_average, original_language ,Type ) VALUES("$title" ,"$poster_path", "$overview" , "$vote_average", "$original_language","$Type")')
          .then((value) {
        emit(InsertToDataBaseState());
        getDataFromDataBase(MoviesDataBase11);
      }).catchError((onError) {});
    });
  }

//get from data base
  void getDataFromDataBase(MoviesDataBase11) {
    MoviesDataBase11?.rawQuery('SELECT * FROM moviesdb').then((value) {
      value.forEach((element) {
        print("get");
        if (element["Type"] == "top_rated") {
          TopMoviesList.add(element);
        } else if (element["Type"] == "popular") {
          PopularList.add(element);
        } else {
          NowPlayingList.add(element);
        }
      });
      emit(GetFromDataBaseState());
    });
  }

  void getTopMoviesDataFromApi() async {
    emit(LoadTopMoviesApiState());
     await DioHelper.getData(
         path:"3/movie/top_rated", query: {
        "api_key": "8d6f4f55538927d4b721f1796a1a842d",
      }).then((value) {
      value.data["result"].forEach((element) {
        insertIntoDataBase(title: element["tit le"], poster_path: element("poster_path"), overview: element("overview"), vote_average:element("vote_average") , original_language: element("original_language"), Type:"top_rated");
      });
        emit(SucessTopMoviesAPiState());
      }).catchError((onError) {
        emit(ErrorTopMoviesApiState(this.onError));
      });

  }
  void getPopularMoviesDataFromApi() async {
    emit(LoadPopularMoviesApiState());
     await DioHelper.getData(path:"3/movie/popular", query: {
        "api_key": "8d6f4f55538927d4b721f1796a1a842d",
      }).then((value) {
      value.data["result"].forEach((element) {
        print(element["title"]);
        insertIntoDataBase(title: element["title"], poster_path: element("poster_path"), overview: element("overview"), vote_average:element("vote_average") , original_language: element("original_language"), Type:"popular");
      });
        emit(SucessPopularMoviesAPiState());
      }).catchError((onError) {
        emit(ErrorPopularMoviesApiState(this.onError));
      });

  }
  void getNowMoviesDataFromApi() async {
    emit(LoadNowMoviesApiState());
     await DioHelper.getData(path:"3/movie/now_playing", query: {
        "api_key": "8d6f4f55538927d4b721f1796a1a842d",
      }).then((value) {
      value.data["result"].forEach((element) {
        insertIntoDataBase(title: element["title"], poster_path: element("poster_path"), overview: element("overview"), vote_average:element("vote_average") , original_language: element("original_language"), Type:"now_playing");
      });
        emit(SucessNowMoviesAPiState());
      }).catchError((onError) {
        emit(ErrorNowMoviesApiState(this.onError));
      });

  }
}

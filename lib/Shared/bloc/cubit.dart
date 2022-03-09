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
  Database? MoviesDB11;

  //List of Movies
  List<dynamic> TopMoviesList = [];
  List<dynamic> PopularList = [];
  List<dynamic> NowPlayingList = [];
  //Data of DetailsScreen
  String? title =" ";
  String? poster_path=" ";
  String? overview=" ";
  dynamic vote_average=" ";
  String? original_language=" ";

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
    await openDatabase('mdb11.dp', version: 1,
        onCreate: (MoviesDB11, vesion) async {
      await MoviesDB11.execute(
              'CREATE TABLE MoviesDB11 (id INTEGER PRIMARY KEY, title TEXT ,poster_path TEXT ,overview TEXT , vote_average DOUBLE , original_language TEXT ,Type Text)')
          .then((value) {
        print("create db");
      }).catchError((onError) {});
    }, onOpen: (MoviesDB11) {
      getDataFromDataBase(MoviesDB11);
    }
    ).then((value) {
      MoviesDB11 = value;
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
    await MoviesDB11?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO MoviesDB11 (title,poster_path,overview, vote_average, original_language,Type) VALUES("$title" ,"$poster_path", "$overview" , "$vote_average", "$original_language","$Type")')
          .then((value) {
        emit(InsertToDataBaseState());
      }).catchError((onError) {});
    });
  }
//get from data base
  void getDataFromDataBase(MoviesDB11) {
    MoviesDB11?.rawQuery('SELECT * FROM MoviesDB11').then((value) {
      value.forEach((element) {
        if (element["Type"] == "top_rated") {
          TopMoviesList.add(element);
        } else if (element["Type"] == "popular") {
          PopularList.add(element);
        } else if ( element["Type"] == "now_playing" ){
          NowPlayingList.add(element);
        }
      });
      emit(GetFromDataBaseState());
    });
  }
// get data from api
  void getTopMoviesDataFromApi() async {
    emit(LoadTopMoviesApiState());
    if (TopMoviesList.isEmpty){
      await DioHelper.getData(
          path:"3/movie/top_rated", query: {
        "api_key": "b6ed23dfdf510291f459cb2c46a090ef",
      }).then((value) {
        value.data["results"].forEach((element) {
          insertIntoDataBase(title: element["title"], poster_path: element["poster_path"], overview: element["overview"], vote_average:element["vote_average"] , original_language: element["original_language"], Type:"top_rated");
        });
        emit(SucessTopMoviesAPiState());
      }).catchError((onError) {
        emit(ErrorTopMoviesApiState(this.onError));
      });
    } else {
      emit(SucessTopMoviesAPiState());
    }


  }
  void getPopularMoviesDataFromApi() async {
    emit(LoadPopularMoviesApiState());
    if (PopularList.isEmpty){
      await DioHelper.getData(path:"3/movie/popular", query: {
        "api_key": "b6ed23dfdf510291f459cb2c46a090ef",
      }).then((value) {
        value.data["results"].forEach((element) {
          insertIntoDataBase(title: element["title"], poster_path: element["poster_path"], overview: element["overview"], vote_average:element["vote_average"] , original_language: element["original_language"], Type:"popular");
        });
        emit(SucessPopularMoviesAPiState());
      }).catchError((onError) {
        emit(ErrorPopularMoviesApiState(this.onError));
      });
    } else {
      emit(SucessPopularMoviesAPiState());
    }


  }
  void getNowMoviesDataFromApi() async {
    emit(LoadNowMoviesApiState());
    if (NowPlayingList.isEmpty){
      await DioHelper.getData(path:"3/movie/now_playing", query: {
      "api_key": "b6ed23dfdf510291f459cb2c46a090ef",
    }).then((value) {
      value.data["results"].forEach((element) {
        insertIntoDataBase(title: element["title"], poster_path: element["poster_path"], overview: element["overview"], vote_average:element["vote_average"] , original_language: element["original_language"], Type:"now_playing");
      });
      emit(SucessNowMoviesAPiState());
    }).catchError((onError) {
      emit(ErrorNowMoviesApiState(this.onError));
    });}else{
      emit(SucessNowMoviesAPiState());
    }
  }
  void LoadAllData (){
    getTopMoviesDataFromApi();
    getPopularMoviesDataFromApi();
    getNowMoviesDataFromApi();
    getDataFromDataBase(MoviesDB11);
    emit(LoadAllDataState());
  }

}

abstract class MoviesState {}

class initalMoviesState extends MoviesState {}

class changeMessageState extends MoviesState {}

class changeDetailsDataState extends MoviesState {}

class CreateDataBaseState extends MoviesState {}

class InsertToDataBaseState extends MoviesState {}

class GetFromDataBaseState extends MoviesState {}

class LoadTopMoviesApiState extends MoviesState{}

class SucessTopMoviesAPiState extends MoviesState {}

class ErrorTopMoviesApiState extends MoviesState {
  var error;
  ErrorTopMoviesApiState(this.error);
}
class LoadPopularMoviesApiState extends MoviesState{}

class SucessPopularMoviesAPiState extends MoviesState {}

class ErrorPopularMoviesApiState extends MoviesState {
  var error;
  ErrorPopularMoviesApiState(this.error);
}
class LoadNowMoviesApiState extends MoviesState{}

class SucessNowMoviesAPiState extends MoviesState {}

class ErrorNowMoviesApiState extends MoviesState {
  var error;
  ErrorNowMoviesApiState(this.error);
}
class LoadAllDataState extends MoviesState {}


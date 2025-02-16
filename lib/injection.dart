import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_series/tv_series_local_data_source.dart';
import 'package:core/data/datasources/tv_series/tv_series_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_series_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_now_playing_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_popular_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_recommendation_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_top_rated_bloc.dart';
import 'package:core/presentation/bloc/movie/movie_watchlist_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_detail_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_on_air_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_popular_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_recommendation_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_top_rated_bloc.dart';
import 'package:core/presentation/bloc/tv/tv_watchlist_bloc.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:core/domain/usecases/tv/get_popular_tv_series_shows.dart';
import 'package:core/domain/usecases/tv/get_top_rated_tv_series_shows.dart';
import 'package:core/domain/usecases/tv/get_tv_series_detail.dart';
import 'package:core/domain/usecases/tv/get_tv_series_on_air.dart';
import 'package:core/domain/usecases/tv/get_tv_series_recommendations.dart';
import 'package:core/domain/usecases/tv/get_watchlist_tv_series.dart';
import 'package:core/domain/usecases/tv/get_watchlist_tv_series_status.dart';
import 'package:core/domain/usecases/tv/remove_tv_series_watchlist.dart';
import 'package:core/domain/usecases/tv/save_tv_series_watchlist.dart';
import 'package:search/domain/usecases/tv/search_tv_series.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  //bloc
  locator.registerFactory(
        () => SearchBlocMovie(
      locator(),
    ),
  );
  locator.registerFactory(
        () => SearchBlocTvSeries(
      locator(),
    ),
  );
  locator.registerFactory(
        () => MovieDetailBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => MovieRecommendationBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => MovieWatchlistBloc(
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
        () => MovieNowPlayingBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => MoviePopularBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => MovieTopRatedBloc(
      locator(),
    ),
  );

  locator.registerFactory(
        () => TvDetailBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TvRecommendationBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TvWatchlistBloc(
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
        () => TvOnAirBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TvPopularBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TvTopRatedBloc(
      locator(),
    ),
  );
  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeriesOnAir(locator()));
  locator.registerLazySingleton(() => GetTvSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeriesStatus(locator()));
  locator.registerLazySingleton(() => RemoveTvSeriesWatchlist(locator()));
  locator.registerLazySingleton(() => SaveTvSeriesWatchlist(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  locator.registerLazySingleton<TvSeriesRepository>(
    () => TvSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ));

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<TvSeriesRemoteDataSource>(
      () => TvSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvSeriesLocalDataSource>(
      () => TvSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}

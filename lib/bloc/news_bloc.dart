import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_joints_news_apps/data/article_model.dart';
import 'package:flutter_joints_news_apps/data/network_manager.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<NewsGetEvent>((event, emit) async {
      emit(NewsLoadingState());
      final result = await NetworkManager().getAllNews();
      emit(NewsLoadedState(listNews: result));
    });
    on<NewsSearchEvent>((event, emit) async {
      emit(NewsLoadingState());
      final result = await NetworkManager().getSearchNews(event.search);
      emit(NewsLoadedState(listNews: result));
    });
  }
}

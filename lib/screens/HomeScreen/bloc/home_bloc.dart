import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tiffsy_app/screens/HomeScreen/model/home_model.dart';
import 'package:tiffsy_app/screens/HomeScreen/repository/home_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialFetchEvent>(homeInitialFetch);
  }

  FutureOr<void> homeInitialFetch(HomeInitialFetchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    
    List<MenuDataModel> menu = await HomeRepo.fetchMenu();
    emit(HomeFetchSuccessfulState(menu: menu));
  }
}

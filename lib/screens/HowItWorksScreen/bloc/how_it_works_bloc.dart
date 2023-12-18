import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'how_it_works_event.dart';
part 'how_it_works_state.dart';

class HowItWorksBloc extends Bloc<HowItWorksEvent, HowItWorksState> {
  HowItWorksBloc() : super(HowItWorksInitial()) {
    on<HowItWorksEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

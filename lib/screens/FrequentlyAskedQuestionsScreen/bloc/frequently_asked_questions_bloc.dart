import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'frequently_asked_questions_event.dart';
part 'frequently_asked_questions_state.dart';

class FrequentlyAskedQuestionsBloc extends Bloc<FrequentlyAskedQuestionsEvent, FrequentlyAskedQuestionsState> {
  FrequentlyAskedQuestionsBloc() : super(FrequentlyAskedQuestionsInitial()) {
    on<FrequentlyAskedQuestionsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

part of 'frequently_asked_questions_bloc.dart';

sealed class FrequentlyAskedQuestionsState extends Equatable {
  const FrequentlyAskedQuestionsState();
  
  @override
  List<Object> get props => [];
}

final class FrequentlyAskedQuestionsInitial extends FrequentlyAskedQuestionsState {}

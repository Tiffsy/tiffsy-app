part of 'how_it_works_bloc.dart';

sealed class HowItWorksState extends Equatable {
  const HowItWorksState();
  
  @override
  List<Object> get props => [];
}

final class HowItWorksInitial extends HowItWorksState {}

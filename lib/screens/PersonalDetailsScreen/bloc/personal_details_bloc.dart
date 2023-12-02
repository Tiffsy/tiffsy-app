import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'personal_details_event.dart';
part 'personal_details_state.dart';

class PersonalDetailsBloc extends Bloc<PersonalDetailsEvent, PersonalDetailsState> {
  PersonalDetailsBloc() : super(PersonalDetailsInitial()) {
    on<PersonalDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

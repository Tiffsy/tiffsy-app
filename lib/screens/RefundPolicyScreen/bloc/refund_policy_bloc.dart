import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'refund_policy_event.dart';
part 'refund_policy_state.dart';

class RefundPolicyBloc extends Bloc<RefundPolicyEvent, RefundPolicyState> {
  RefundPolicyBloc() : super(RefundPolicyInitial()) {
    on<RefundPolicyEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

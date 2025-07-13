import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'counter_state.dart';

@injectable
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterInitial());

  void increment() => emit(CounterUpdated(state.value + 1));
  void decrement() => emit(CounterUpdated(state.value - 1));
}

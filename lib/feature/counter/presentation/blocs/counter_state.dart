part of 'counter_cubit.dart';

sealed class CounterState extends Equatable {
  const CounterState(this.value);

  final int value;

  @override
  List<Object> get props => [value];
}

final class CounterInitial extends CounterState {
  const CounterInitial() : super(0);
}

class CounterUpdated extends CounterState {
  const CounterUpdated(super.value);

  @override
  String toString() => 'CounterUpdated(value: $value)';
}

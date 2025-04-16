import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_state.dart';
part 'screen_cubit.freezed.dart';

class ScreenCubit extends Cubit<ScreenState> {
  void showCluster() => emit(const ScreenState.cluster());
  void showMap() => emit(const ScreenState.map());
  void showAddressSelection() => emit(const ScreenState.addressSelection());

  ScreenCubit() : super(const ScreenState.cluster());

  static ScreenCubit create(BuildContext context) => ScreenCubit();
}

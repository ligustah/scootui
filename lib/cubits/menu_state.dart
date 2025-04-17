part of 'menu_cubit.dart';

@freezed
class MenuState with _$MenuState {
  const factory MenuState.hidden() = MenuHidden;
  const factory MenuState.visible() = MenuVisible;
}

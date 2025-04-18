import 'package:equatable/equatable.dart';

import '../builders/sync/annotations.dart';
import '../builders/sync/settings.dart';

part 'navigation.g.dart';

@StateClass("navigation", Duration(seconds: 5))
class NavigationData extends Equatable with $NavigationData {
  @StateField()
  final String destination;

  NavigationData({
    this.destination = "",
  });
}

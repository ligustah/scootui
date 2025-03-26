import 'settings.dart';

class StateClass {
  final String channel;
  final Duration interval;

  const StateClass(this.channel, this.interval);
}

class StateField{
  final String? name;
  final Duration? interval;
  final String? defaultValue;

  const StateField({this.name, this.interval, this.defaultValue});
}

class StateDiscriminator{
  const StateDiscriminator();
}

abstract class Syncable<T> {
  SyncSettings get syncSettings;
  T update(String name, String value);
}
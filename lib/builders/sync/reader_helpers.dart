import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import 'settings.dart';

String camelToKebab(String input) {
  final regExp = RegExp(r'(?<=[a-z])[A-Z]');
  return input.replaceAllMapped(regExp, (match) {
    return '-${match.group(0)!.toLowerCase()}';
  }).toLowerCase();
}

Duration? durationFromObject(DartObject? obj) {
  if (obj == null || obj.isNull) {
    return null;
  }

  final micros = obj.getField("_duration")?.toIntValue();
  return Duration(microseconds: micros!);
}

List<String> enumFields(EnumElement element) =>
    element.fields
        .where((field) => field.name != 'values')
        .map((field) => field.name)
        .toList();

SyncSettings stateFromReader(
  ConstantReader reader,
  List<SyncFieldSettings> fields,
    String? discriminator,
) {
  final channel = reader.read("channel").stringValue;
  final interval = reader.read("interval").objectValue;
  final duration = durationFromObject(interval);

  return SyncSettings(channel, duration!, fields, discriminator);
}

SyncFieldType syncFieldType(DartType fieldType) {
  if (fieldType.isDartCoreString) {
    return SyncFieldType.string;
  }

  if (fieldType.isDartCoreNum) {
    return SyncFieldType.num;
  }

  if (fieldType.isDartCoreBool) {
    return SyncFieldType.bool;
  }

  if(fieldType.isDartCoreInt) {
    return SyncFieldType.int;
  }

  if(fieldType.isDartCoreDouble) {
    return SyncFieldType.double;
  }

  if (fieldType.element is EnumElement) {
    return SyncFieldType.enum_;
  }

  throw ArgumentError("The supplied type $fieldType is not supported");
}

SyncFieldSettings stateFieldFromObject(
  String fieldName,
  DartType fieldType,
  DartObject? obj,
) {
  DartObject? interval;
  String variable = camelToKebab(fieldName);
  String? defaultValue;
  SyncFieldType type = syncFieldType(fieldType);

  if (obj != null && !obj.isNull) {
    interval = obj.getField("interval");
    variable = obj.getField("name")?.toStringValue() ?? variable;
    defaultValue = obj.getField("defaultValue")?.toStringValue();
  }

  if(type == SyncFieldType.enum_ && defaultValue == null) {
    throw ArgumentError("Enum fields need to declare a default value");
  }

  return SyncFieldSettings(
    name: fieldName,
    variable: variable,
    defaultValue: defaultValue,
    typeName: fieldType.getDisplayString(),
    type: type,
    interval: durationFromObject(interval),
  );
}

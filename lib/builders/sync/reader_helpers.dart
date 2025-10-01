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

List<String> enumFields(EnumElement element) => element.fields
    .where((field) => field.name != 'values')
    .map((field) => field.name)
    .toList();

SyncSettings stateFromReader(
  ConstantReader reader,
  List<SyncFieldSettings> fields,
  List<SyncSetFieldSettings> setFields,
  String? discriminator,
) {
  final channel = reader.read("channel").stringValue;
  final interval = reader.read("interval").objectValue;
  final duration = durationFromObject(interval);

  return SyncSettings(channel, duration!, fields, discriminator, setFields);
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

  if (fieldType.isDartCoreInt) {
    return SyncFieldType.int;
  }

  if (fieldType.isDartCoreDouble) {
    return SyncFieldType.double;
  }

  if (fieldType.element is EnumElement) {
    return SyncFieldType.enum_;
  }

  // Check if it's a Set type
  if (fieldType.isDartCoreSet) {
    final typeArgs = (fieldType as dynamic).typeArguments;
    if (typeArgs != null && typeArgs.isNotEmpty) {
      final elementType = typeArgs[0] as DartType;
      if (elementType.isDartCoreInt) {
        return SyncFieldType.set_int;
      }
      if (elementType.isDartCoreString) {
        return SyncFieldType.set_string;
      }
    }
    throw ArgumentError(
        "Set type must have int or String element type, got $fieldType");
  }

  throw ArgumentError("The supplied type $fieldType is not supported");
}

SyncFieldType syncSetElementType(String elementType) {
  switch (elementType) {
    case "int":
      return SyncFieldType.set_int;
    case "string":
      return SyncFieldType.set_string;
    default:
      throw ArgumentError("Unsupported Set element type: $elementType");
  }
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

  if (type == SyncFieldType.enum_ && defaultValue == null) {
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

SyncSetFieldSettings setFieldFromObject(
  String fieldName,
  DartType fieldType,
  DartObject obj,
) {
  final setKey = obj.getField("setKey")?.toStringValue();
  if (setKey == null) {
    throw ArgumentError("SetField annotation must have a setKey parameter");
  }

  final elementTypeStr =
      obj.getField("elementType")?.toStringValue() ?? "string";
  final interval = obj.getField("interval");

  final elementType = syncSetElementType(elementTypeStr);

  return SyncSetFieldSettings(
    name: fieldName,
    setKey: setKey,
    elementType: elementType,
    typeName: fieldType.getDisplayString(),
    interval: durationFromObject(interval),
  );
}

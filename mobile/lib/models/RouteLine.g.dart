// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RouteLine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RouteLine _$RouteLineFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['routeline_id'],
  );
  return _RouteLine()
    ..routelineId = json['routeline_id'] as int
    ..routename = json['routename'] as String;
}

Map<String, dynamic> _$RouteLineToJson(_RouteLine instance) =>
    <String, dynamic>{
      'routeline_id': instance.routelineId,
      'routename': instance.routename,
    };

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class RouteLine extends _RouteLine with RealmEntity, RealmObject {
  RouteLine(
    int routelineId,
    String routename,
  ) {
    RealmObject.set(this, 'routelineId', routelineId);
    RealmObject.set(this, 'routename', routename);
  }

  RouteLine._();

  @override
  int get routelineId => RealmObject.get<int>(this, 'routelineId') as int;
  @override
  set routelineId(int value) => RealmObject.set(this, 'routelineId', value);

  @override
  String get routename => RealmObject.get<String>(this, 'routename') as String;
  @override
  set routename(String value) => RealmObject.set(this, 'routename', value);

  @override
  Stream<RealmObjectChanges<RouteLine>> get changes =>
      RealmObject.getChanges<RouteLine>(this);

  @override
  RouteLine freeze() => RealmObject.freezeObject<RouteLine>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(RouteLine._);
    return const SchemaObject(RouteLine, 'RouteLine', [
      SchemaProperty('routelineId', RealmPropertyType.int),
      SchemaProperty('routename', RealmPropertyType.string),
    ]);
  }
}

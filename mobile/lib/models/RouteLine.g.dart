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

class RouteLine extends _RouteLine
    with RealmEntity, RealmObjectBase, RealmObject {
  RouteLine(
    int routelineId,
    String routename,
  ) {
    RealmObjectBase.set(this, 'routelineId', routelineId);
    RealmObjectBase.set(this, 'routename', routename);
  }

  RouteLine._();

  @override
  int get routelineId => RealmObjectBase.get<int>(this, 'routelineId') as int;
  @override
  set routelineId(int value) => RealmObjectBase.set(this, 'routelineId', value);

  @override
  String get routename =>
      RealmObjectBase.get<String>(this, 'routename') as String;
  @override
  set routename(String value) => RealmObjectBase.set(this, 'routename', value);

  @override
  Stream<RealmObjectChanges<RouteLine>> get changes =>
      RealmObjectBase.getChanges<RouteLine>(this);

  @override
  RouteLine freeze() => RealmObjectBase.freezeObject<RouteLine>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RouteLine._);
    return const SchemaObject(ObjectType.realmObject, RouteLine, 'RouteLine', [
      SchemaProperty('routelineId', RealmPropertyType.int),
      SchemaProperty('routename', RealmPropertyType.string),
    ]);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MstType.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MstType _$MstTypeFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['mst_type_id'],
  );
  return _MstType()
    ..mstTypeId = json['mst_type_id'] as int
    ..head = json['head'] as int
    ..description = json['description'] as String
    ..typeDetail = json['type_detail'] as String;
}

Map<String, dynamic> _$MstTypeToJson(_MstType instance) => <String, dynamic>{
      'mst_type_id': instance.mstTypeId,
      'head': instance.head,
      'description': instance.description,
      'type_detail': instance.typeDetail,
    };

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class MstType extends _MstType with RealmEntity, RealmObjectBase, RealmObject {
  MstType(
    int mstTypeId,
    int head,
    String description,
    String typeDetail,
  ) {
    RealmObjectBase.set(this, 'mstTypeId', mstTypeId);
    RealmObjectBase.set(this, 'head', head);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'typeDetail', typeDetail);
  }

  MstType._();

  @override
  int get mstTypeId => RealmObjectBase.get<int>(this, 'mstTypeId') as int;
  @override
  set mstTypeId(int value) => RealmObjectBase.set(this, 'mstTypeId', value);

  @override
  int get head => RealmObjectBase.get<int>(this, 'head') as int;
  @override
  set head(int value) => RealmObjectBase.set(this, 'head', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get typeDetail =>
      RealmObjectBase.get<String>(this, 'typeDetail') as String;
  @override
  set typeDetail(String value) =>
      RealmObjectBase.set(this, 'typeDetail', value);

  @override
  Stream<RealmObjectChanges<MstType>> get changes =>
      RealmObjectBase.getChanges<MstType>(this);

  @override
  MstType freeze() => RealmObjectBase.freezeObject<MstType>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(MstType._);
    return const SchemaObject(ObjectType.realmObject, MstType, 'MstType', [
      SchemaProperty('mstTypeId', RealmPropertyType.int),
      SchemaProperty('head', RealmPropertyType.int),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('typeDetail', RealmPropertyType.string),
    ]);
  }
}

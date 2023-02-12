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

class MstType extends _MstType with RealmEntity, RealmObject {
  MstType(
    int mstTypeId,
    int head,
    String description,
    String typeDetail,
  ) {
    RealmObject.set(this, 'mstTypeId', mstTypeId);
    RealmObject.set(this, 'head', head);
    RealmObject.set(this, 'description', description);
    RealmObject.set(this, 'typeDetail', typeDetail);
  }

  MstType._();

  @override
  int get mstTypeId => RealmObject.get<int>(this, 'mstTypeId') as int;
  @override
  set mstTypeId(int value) => RealmObject.set(this, 'mstTypeId', value);

  @override
  int get head => RealmObject.get<int>(this, 'head') as int;
  @override
  set head(int value) => RealmObject.set(this, 'head', value);

  @override
  String get description =>
      RealmObject.get<String>(this, 'description') as String;
  @override
  set description(String value) => RealmObject.set(this, 'description', value);

  @override
  String get typeDetail =>
      RealmObject.get<String>(this, 'typeDetail') as String;
  @override
  set typeDetail(String value) => RealmObject.set(this, 'typeDetail', value);

  @override
  Stream<RealmObjectChanges<MstType>> get changes =>
      RealmObject.getChanges<MstType>(this);

  @override
  MstType freeze() => RealmObject.freezeObject<MstType>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(MstType._);
    return const SchemaObject(MstType, 'MstType', [
      SchemaProperty('mstTypeId', RealmPropertyType.int),
      SchemaProperty('head', RealmPropertyType.int),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('typeDetail', RealmPropertyType.string),
    ]);
  }
}

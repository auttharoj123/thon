// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NonUpdatedJob.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NonUpdatedJob _$NonUpdatedJobFromJson(Map<String, dynamic> json) =>
    _NonUpdatedJob()
      ..id = json['id'] as String
      ..jobIds = json['jobIds'] as String
      ..barcodes = json['barcodes'] as String
      ..sendJobType = json['sendJobType'] as int
      ..targetOrderStatus = json['targetOrderStatus'] as int
      ..targetRemarkCategoryId = json['targetRemarkCategoryId'] as int
      ..specialRemark = json['specialRemark'] as String?
      ..selectedComplacencyLevel = json['selectedComplacencyLevel'] as int
      ..signImagePath = json['signImagePath'] as String
      ..latitude = json['latitude'] as String?
      ..longitude = json['longitude'] as String?
      ..result = json['result'] as String?
      ..imagesPath =
          (json['imagesPath'] as List<dynamic>).map((e) => e as String).toList()
      ..isUploadSuccess = json['isUploadSuccess'] as bool
      ..createdDate = DateTime.parse(json['createdDate'] as String)
      ..updatedDate = DateTime.parse(json['updatedDate'] as String)
      ..loginName = json['loginName'] as String;

Map<String, dynamic> _$NonUpdatedJobToJson(_NonUpdatedJob instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobIds': instance.jobIds,
      'barcodes': instance.barcodes,
      'sendJobType': instance.sendJobType,
      'targetOrderStatus': instance.targetOrderStatus,
      'targetRemarkCategoryId': instance.targetRemarkCategoryId,
      'specialRemark': instance.specialRemark,
      'selectedComplacencyLevel': instance.selectedComplacencyLevel,
      'signImagePath': instance.signImagePath,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'result': instance.result,
      'imagesPath': instance.imagesPath,
      'isUploadSuccess': instance.isUploadSuccess,
      'createdDate': instance.createdDate.toIso8601String(),
      'updatedDate': instance.updatedDate.toIso8601String(),
      'loginName': instance.loginName,
    };

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class NonUpdatedJob extends _NonUpdatedJob
    with RealmEntity, RealmObjectBase, RealmObject {
  NonUpdatedJob(
    String id,
    String jobIds,
    String barcodes,
    int sendJobType,
    int targetOrderStatus,
    int targetRemarkCategoryId,
    int selectedComplacencyLevel,
    String signImagePath,
    bool isUploadSuccess,
    DateTime createdDate,
    DateTime updatedDate,
    String loginName, {
    String? specialRemark,
    String? latitude,
    String? longitude,
    String? result,
    Iterable<String> imagesPath = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'jobIds', jobIds);
    RealmObjectBase.set(this, 'barcodes', barcodes);
    RealmObjectBase.set(this, 'sendJobType', sendJobType);
    RealmObjectBase.set(this, 'targetOrderStatus', targetOrderStatus);
    RealmObjectBase.set(this, 'targetRemarkCategoryId', targetRemarkCategoryId);
    RealmObjectBase.set(this, 'specialRemark', specialRemark);
    RealmObjectBase.set(
        this, 'selectedComplacencyLevel', selectedComplacencyLevel);
    RealmObjectBase.set(this, 'signImagePath', signImagePath);
    RealmObjectBase.set(this, 'latitude', latitude);
    RealmObjectBase.set(this, 'longitude', longitude);
    RealmObjectBase.set(this, 'result', result);
    RealmObjectBase.set(this, 'isUploadSuccess', isUploadSuccess);
    RealmObjectBase.set(this, 'createdDate', createdDate);
    RealmObjectBase.set(this, 'updatedDate', updatedDate);
    RealmObjectBase.set(this, 'loginName', loginName);
    RealmObjectBase.set<RealmList<String>>(
        this, 'imagesPath', RealmList<String>(imagesPath));
  }

  NonUpdatedJob._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get jobIds => RealmObjectBase.get<String>(this, 'jobIds') as String;
  @override
  set jobIds(String value) => RealmObjectBase.set(this, 'jobIds', value);

  @override
  String get barcodes =>
      RealmObjectBase.get<String>(this, 'barcodes') as String;
  @override
  set barcodes(String value) => RealmObjectBase.set(this, 'barcodes', value);

  @override
  int get sendJobType => RealmObjectBase.get<int>(this, 'sendJobType') as int;
  @override
  set sendJobType(int value) => RealmObjectBase.set(this, 'sendJobType', value);

  @override
  int get targetOrderStatus =>
      RealmObjectBase.get<int>(this, 'targetOrderStatus') as int;
  @override
  set targetOrderStatus(int value) =>
      RealmObjectBase.set(this, 'targetOrderStatus', value);

  @override
  int get targetRemarkCategoryId =>
      RealmObjectBase.get<int>(this, 'targetRemarkCategoryId') as int;
  @override
  set targetRemarkCategoryId(int value) =>
      RealmObjectBase.set(this, 'targetRemarkCategoryId', value);

  @override
  String? get specialRemark =>
      RealmObjectBase.get<String>(this, 'specialRemark') as String?;
  @override
  set specialRemark(String? value) =>
      RealmObjectBase.set(this, 'specialRemark', value);

  @override
  int get selectedComplacencyLevel =>
      RealmObjectBase.get<int>(this, 'selectedComplacencyLevel') as int;
  @override
  set selectedComplacencyLevel(int value) =>
      RealmObjectBase.set(this, 'selectedComplacencyLevel', value);

  @override
  String get signImagePath =>
      RealmObjectBase.get<String>(this, 'signImagePath') as String;
  @override
  set signImagePath(String value) =>
      RealmObjectBase.set(this, 'signImagePath', value);

  @override
  String? get latitude =>
      RealmObjectBase.get<String>(this, 'latitude') as String?;
  @override
  set latitude(String? value) => RealmObjectBase.set(this, 'latitude', value);

  @override
  String? get longitude =>
      RealmObjectBase.get<String>(this, 'longitude') as String?;
  @override
  set longitude(String? value) => RealmObjectBase.set(this, 'longitude', value);

  @override
  String? get result => RealmObjectBase.get<String>(this, 'result') as String?;
  @override
  set result(String? value) => RealmObjectBase.set(this, 'result', value);

  @override
  RealmList<String> get imagesPath =>
      RealmObjectBase.get<String>(this, 'imagesPath') as RealmList<String>;
  @override
  set imagesPath(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  bool get isUploadSuccess =>
      RealmObjectBase.get<bool>(this, 'isUploadSuccess') as bool;
  @override
  set isUploadSuccess(bool value) =>
      RealmObjectBase.set(this, 'isUploadSuccess', value);

  @override
  DateTime get createdDate =>
      RealmObjectBase.get<DateTime>(this, 'createdDate') as DateTime;
  @override
  set createdDate(DateTime value) =>
      RealmObjectBase.set(this, 'createdDate', value);

  @override
  DateTime get updatedDate =>
      RealmObjectBase.get<DateTime>(this, 'updatedDate') as DateTime;
  @override
  set updatedDate(DateTime value) =>
      RealmObjectBase.set(this, 'updatedDate', value);

  @override
  String get loginName =>
      RealmObjectBase.get<String>(this, 'loginName') as String;
  @override
  set loginName(String value) => RealmObjectBase.set(this, 'loginName', value);

  @override
  Stream<RealmObjectChanges<NonUpdatedJob>> get changes =>
      RealmObjectBase.getChanges<NonUpdatedJob>(this);

  @override
  NonUpdatedJob freeze() => RealmObjectBase.freezeObject<NonUpdatedJob>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(NonUpdatedJob._);
    return const SchemaObject(
        ObjectType.realmObject, NonUpdatedJob, 'NonUpdatedJob', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('jobIds', RealmPropertyType.string),
      SchemaProperty('barcodes', RealmPropertyType.string),
      SchemaProperty('sendJobType', RealmPropertyType.int),
      SchemaProperty('targetOrderStatus', RealmPropertyType.int),
      SchemaProperty('targetRemarkCategoryId', RealmPropertyType.int),
      SchemaProperty('specialRemark', RealmPropertyType.string, optional: true),
      SchemaProperty('selectedComplacencyLevel', RealmPropertyType.int),
      SchemaProperty('signImagePath', RealmPropertyType.string),
      SchemaProperty('latitude', RealmPropertyType.string, optional: true),
      SchemaProperty('longitude', RealmPropertyType.string, optional: true),
      SchemaProperty('result', RealmPropertyType.string, optional: true),
      SchemaProperty('imagesPath', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('isUploadSuccess', RealmPropertyType.bool),
      SchemaProperty('createdDate', RealmPropertyType.timestamp),
      SchemaProperty('updatedDate', RealmPropertyType.timestamp),
      SchemaProperty('loginName', RealmPropertyType.string),
    ]);
  }
}

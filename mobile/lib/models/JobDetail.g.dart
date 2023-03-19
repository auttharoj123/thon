// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'JobDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobDetail _$JobDetailFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['id'],
  );
  return _JobDetail()
    ..id = json['id'] as int
    ..ordDetailId = json['ord_detail_id'] as int
    ..routelineId = json['routeline_id'] as int
    ..routeName = json['routename'] as String
    ..nextRoutelineId = json['next_routeline_id'] as int
    ..orderStatus = json['order_status'] as int
    ..directionType = json['direction_type'] as int
    ..barcode = json['barcode'] as String
    ..jobNumber = json['jobnumber'] as String
    ..customerId = json['customer_id'] as int
    ..customerName = json['customer_name'] as String
    ..deliveryDate = DateTime.parse(json['delivery_date'] as String)
    ..deliveryDocumentDate = DateTime.parse(json['delivery_doc_date'] as String)
    ..receiveDate = DateTime.parse(json['receive_date'] as String)
    ..createdDateFromServer =
        DateTime.parse(json['created_date_from_server'] as String)
    ..goodsNumber = json['goods_number'] as String
    ..goodsType = json['goods_type'] as String
    ..goodsDetails = json['goods_details'] as String
    ..receiverName = json['receiver_name'] as String
    ..receiverAddress = json['receiver_address'] as String
    ..receiverFullAddress = json['receiver_full_address'] as String
    ..contactName = json['contact_name'] as String
    ..contactTelephone = json['contact_telephone'] as String
    ..contactEmail = json['contact_email'] as String?
    ..qty = json['qty'] as int
    ..weight = _JobDetail._stringToDouble(json['weight'] as String?)
    ..width = _JobDetail._stringToDouble(json['width'] as String?)
    ..high = _JobDetail._stringToDouble(json['high'] as String?)
    ..length = _JobDetail._stringToDouble(json['length'] as String?)
    ..reference1 = json['reference1'] as String
    ..reference2 = json['reference2'] as String
    ..reference3 = json['reference3'] as String
    ..remark = json['remark'] as String
    ..imgPath = json['img_path'] as String?
    ..statusFromServer = json['status_from_server'] as int
    ..createdUserFromServer = json['created_user_from_server'] as String
    ..updatedUserFromServer = json['updated_user_from_server'] as String?
    ..updatedDateFromServer = json['updated_date_from_server'] as String;
}

Map<String, dynamic> _$JobDetailToJson(_JobDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ord_detail_id': instance.ordDetailId,
      'routeline_id': instance.routelineId,
      'routename': instance.routeName,
      'next_routeline_id': instance.nextRoutelineId,
      'order_status': instance.orderStatus,
      'direction_type': instance.directionType,
      'barcode': instance.barcode,
      'jobnumber': instance.jobNumber,
      'customer_id': instance.customerId,
      'customer_name': instance.customerName,
      'delivery_date': instance.deliveryDate.toIso8601String(),
      'delivery_doc_date': instance.deliveryDocumentDate.toIso8601String(),
      'receive_date': instance.receiveDate.toIso8601String(),
      'created_date_from_server':
          instance.createdDateFromServer.toIso8601String(),
      'goods_number': instance.goodsNumber,
      'goods_type': instance.goodsType,
      'goods_details': instance.goodsDetails,
      'receiver_name': instance.receiverName,
      'receiver_address': instance.receiverAddress,
      'receiver_full_address': instance.receiverFullAddress,
      'contact_name': instance.contactName,
      'contact_telephone': instance.contactTelephone,
      'contact_email': instance.contactEmail,
      'qty': instance.qty,
      'weight': instance.weight,
      'width': instance.width,
      'high': instance.high,
      'length': instance.length,
      'reference1': instance.reference1,
      'reference2': instance.reference2,
      'reference3': instance.reference3,
      'remark': instance.remark,
      'img_path': instance.imgPath,
      'status_from_server': instance.statusFromServer,
      'created_user_from_server': instance.createdUserFromServer,
      'updated_user_from_server': instance.updatedUserFromServer,
      'updated_date_from_server': instance.updatedDateFromServer,
    };

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class JobDetail extends _JobDetail
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  JobDetail(
    String remark,
    int ordDetailId,
    int routelineId,
    String routeName,
    int nextRoutelineId,
    int orderStatus,
    int directionType,
    String barcode,
    int customerId,
    String customerName,
    int statusFromServer,
    int id,
    DateTime createdDateFromServer,
    String goodsNumber,
    String goodsType,
    String goodsDetails,
    String receiverName,
    String receiverAddress,
    String receiverFullAddress,
    String contactTelephone,
    String createdUserFromServer,
    String updatedDateFromServer,
    String reference1,
    String reference2,
    String reference3,
    String contactName,
    DateTime deliveryDate,
    DateTime deliveryDocumentDate,
    int qty,
    DateTime receiveDate, {
    String jobNumber = "",
    bool isUpdatedFailed = false,
    String? imgPath,
    DateTime? latestUpdateTime,
    double? width,
    double? high,
    double? length,
    String? updatedUserFromServer,
    String? contactEmail,
    double? weight,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<JobDetail>({
        'jobNumber': "",
        'isUpdatedFailed': false,
      });
    }
    RealmObjectBase.set(this, 'remark', remark);
    RealmObjectBase.set(this, 'ordDetailId', ordDetailId);
    RealmObjectBase.set(this, 'routelineId', routelineId);
    RealmObjectBase.set(this, 'routeName', routeName);
    RealmObjectBase.set(this, 'nextRoutelineId', nextRoutelineId);
    RealmObjectBase.set(this, 'orderStatus', orderStatus);
    RealmObjectBase.set(this, 'directionType', directionType);
    RealmObjectBase.set(this, 'barcode', barcode);
    RealmObjectBase.set(this, 'jobNumber', jobNumber);
    RealmObjectBase.set(this, 'customerId', customerId);
    RealmObjectBase.set(this, 'customerName', customerName);
    RealmObjectBase.set(this, 'statusFromServer', statusFromServer);
    RealmObjectBase.set(this, 'isUpdatedFailed', isUpdatedFailed);
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'createdDateFromServer', createdDateFromServer);
    RealmObjectBase.set(this, 'goodsNumber', goodsNumber);
    RealmObjectBase.set(this, 'goodsType', goodsType);
    RealmObjectBase.set(this, 'goodsDetails', goodsDetails);
    RealmObjectBase.set(this, 'receiverName', receiverName);
    RealmObjectBase.set(this, 'receiverAddress', receiverAddress);
    RealmObjectBase.set(this, 'receiverFullAddress', receiverFullAddress);
    RealmObjectBase.set(this, 'imgPath', imgPath);
    RealmObjectBase.set(this, 'contactTelephone', contactTelephone);
    RealmObjectBase.set(this, 'createdUserFromServer', createdUserFromServer);
    RealmObjectBase.set(this, 'updatedDateFromServer', updatedDateFromServer);
    RealmObjectBase.set(this, 'latestUpdateTime', latestUpdateTime);
    RealmObjectBase.set(this, 'width', width);
    RealmObjectBase.set(this, 'high', high);
    RealmObjectBase.set(this, 'length', length);
    RealmObjectBase.set(this, 'reference1', reference1);
    RealmObjectBase.set(this, 'reference2', reference2);
    RealmObjectBase.set(this, 'reference3', reference3);
    RealmObjectBase.set(this, 'updatedUserFromServer', updatedUserFromServer);
    RealmObjectBase.set(this, 'contactName', contactName);
    RealmObjectBase.set(this, 'deliveryDate', deliveryDate);
    RealmObjectBase.set(this, 'contactEmail', contactEmail);
    RealmObjectBase.set(this, 'deliveryDocumentDate', deliveryDocumentDate);
    RealmObjectBase.set(this, 'qty', qty);
    RealmObjectBase.set(this, 'receiveDate', receiveDate);
    RealmObjectBase.set(this, 'weight', weight);
  }

  JobDetail._();

  @override
  String get remark => RealmObjectBase.get<String>(this, 'remark') as String;
  @override
  set remark(String value) => RealmObjectBase.set(this, 'remark', value);

  @override
  int get ordDetailId => RealmObjectBase.get<int>(this, 'ordDetailId') as int;
  @override
  set ordDetailId(int value) => RealmObjectBase.set(this, 'ordDetailId', value);

  @override
  int get routelineId => RealmObjectBase.get<int>(this, 'routelineId') as int;
  @override
  set routelineId(int value) => RealmObjectBase.set(this, 'routelineId', value);

  @override
  String get routeName =>
      RealmObjectBase.get<String>(this, 'routeName') as String;
  @override
  set routeName(String value) => RealmObjectBase.set(this, 'routeName', value);

  @override
  int get nextRoutelineId =>
      RealmObjectBase.get<int>(this, 'nextRoutelineId') as int;
  @override
  set nextRoutelineId(int value) =>
      RealmObjectBase.set(this, 'nextRoutelineId', value);

  @override
  int get orderStatus => RealmObjectBase.get<int>(this, 'orderStatus') as int;
  @override
  set orderStatus(int value) => RealmObjectBase.set(this, 'orderStatus', value);

  @override
  int get directionType =>
      RealmObjectBase.get<int>(this, 'directionType') as int;
  @override
  set directionType(int value) =>
      RealmObjectBase.set(this, 'directionType', value);

  @override
  String get barcode => RealmObjectBase.get<String>(this, 'barcode') as String;
  @override
  set barcode(String value) => RealmObjectBase.set(this, 'barcode', value);

  @override
  String get jobNumber =>
      RealmObjectBase.get<String>(this, 'jobNumber') as String;
  @override
  set jobNumber(String value) => RealmObjectBase.set(this, 'jobNumber', value);

  @override
  int get customerId => RealmObjectBase.get<int>(this, 'customerId') as int;
  @override
  set customerId(int value) => RealmObjectBase.set(this, 'customerId', value);

  @override
  String get customerName =>
      RealmObjectBase.get<String>(this, 'customerName') as String;
  @override
  set customerName(String value) =>
      RealmObjectBase.set(this, 'customerName', value);

  @override
  int get statusFromServer =>
      RealmObjectBase.get<int>(this, 'statusFromServer') as int;
  @override
  set statusFromServer(int value) =>
      RealmObjectBase.set(this, 'statusFromServer', value);

  @override
  bool get isUpdatedFailed =>
      RealmObjectBase.get<bool>(this, 'isUpdatedFailed') as bool;
  @override
  set isUpdatedFailed(bool value) =>
      RealmObjectBase.set(this, 'isUpdatedFailed', value);

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  DateTime get createdDateFromServer =>
      RealmObjectBase.get<DateTime>(this, 'createdDateFromServer') as DateTime;
  @override
  set createdDateFromServer(DateTime value) =>
      RealmObjectBase.set(this, 'createdDateFromServer', value);

  @override
  String get goodsNumber =>
      RealmObjectBase.get<String>(this, 'goodsNumber') as String;
  @override
  set goodsNumber(String value) =>
      RealmObjectBase.set(this, 'goodsNumber', value);

  @override
  String get goodsType =>
      RealmObjectBase.get<String>(this, 'goodsType') as String;
  @override
  set goodsType(String value) => RealmObjectBase.set(this, 'goodsType', value);

  @override
  String get goodsDetails =>
      RealmObjectBase.get<String>(this, 'goodsDetails') as String;
  @override
  set goodsDetails(String value) =>
      RealmObjectBase.set(this, 'goodsDetails', value);

  @override
  String get receiverName =>
      RealmObjectBase.get<String>(this, 'receiverName') as String;
  @override
  set receiverName(String value) =>
      RealmObjectBase.set(this, 'receiverName', value);

  @override
  String get receiverAddress =>
      RealmObjectBase.get<String>(this, 'receiverAddress') as String;
  @override
  set receiverAddress(String value) =>
      RealmObjectBase.set(this, 'receiverAddress', value);

  @override
  String get receiverFullAddress =>
      RealmObjectBase.get<String>(this, 'receiverFullAddress') as String;
  @override
  set receiverFullAddress(String value) =>
      RealmObjectBase.set(this, 'receiverFullAddress', value);

  @override
  String? get imgPath =>
      RealmObjectBase.get<String>(this, 'imgPath') as String?;
  @override
  set imgPath(String? value) => RealmObjectBase.set(this, 'imgPath', value);

  @override
  String get contactTelephone =>
      RealmObjectBase.get<String>(this, 'contactTelephone') as String;
  @override
  set contactTelephone(String value) =>
      RealmObjectBase.set(this, 'contactTelephone', value);

  @override
  String get createdUserFromServer =>
      RealmObjectBase.get<String>(this, 'createdUserFromServer') as String;
  @override
  set createdUserFromServer(String value) =>
      RealmObjectBase.set(this, 'createdUserFromServer', value);

  @override
  String get updatedDateFromServer =>
      RealmObjectBase.get<String>(this, 'updatedDateFromServer') as String;
  @override
  set updatedDateFromServer(String value) =>
      RealmObjectBase.set(this, 'updatedDateFromServer', value);

  @override
  DateTime? get latestUpdateTime =>
      RealmObjectBase.get<DateTime>(this, 'latestUpdateTime') as DateTime?;
  @override
  set latestUpdateTime(DateTime? value) =>
      RealmObjectBase.set(this, 'latestUpdateTime', value);

  @override
  double? get width => RealmObjectBase.get<double>(this, 'width') as double?;
  @override
  set width(double? value) => RealmObjectBase.set(this, 'width', value);

  @override
  double? get high => RealmObjectBase.get<double>(this, 'high') as double?;
  @override
  set high(double? value) => RealmObjectBase.set(this, 'high', value);

  @override
  double? get length => RealmObjectBase.get<double>(this, 'length') as double?;
  @override
  set length(double? value) => RealmObjectBase.set(this, 'length', value);

  @override
  String get reference1 =>
      RealmObjectBase.get<String>(this, 'reference1') as String;
  @override
  set reference1(String value) =>
      RealmObjectBase.set(this, 'reference1', value);

  @override
  String get reference2 =>
      RealmObjectBase.get<String>(this, 'reference2') as String;
  @override
  set reference2(String value) =>
      RealmObjectBase.set(this, 'reference2', value);

  @override
  String get reference3 =>
      RealmObjectBase.get<String>(this, 'reference3') as String;
  @override
  set reference3(String value) =>
      RealmObjectBase.set(this, 'reference3', value);

  @override
  String? get updatedUserFromServer =>
      RealmObjectBase.get<String>(this, 'updatedUserFromServer') as String?;
  @override
  set updatedUserFromServer(String? value) =>
      RealmObjectBase.set(this, 'updatedUserFromServer', value);

  @override
  String get contactName =>
      RealmObjectBase.get<String>(this, 'contactName') as String;
  @override
  set contactName(String value) =>
      RealmObjectBase.set(this, 'contactName', value);

  @override
  DateTime get deliveryDate =>
      RealmObjectBase.get<DateTime>(this, 'deliveryDate') as DateTime;
  @override
  set deliveryDate(DateTime value) =>
      RealmObjectBase.set(this, 'deliveryDate', value);

  @override
  String? get contactEmail =>
      RealmObjectBase.get<String>(this, 'contactEmail') as String?;
  @override
  set contactEmail(String? value) =>
      RealmObjectBase.set(this, 'contactEmail', value);

  @override
  DateTime get deliveryDocumentDate =>
      RealmObjectBase.get<DateTime>(this, 'deliveryDocumentDate') as DateTime;
  @override
  set deliveryDocumentDate(DateTime value) =>
      RealmObjectBase.set(this, 'deliveryDocumentDate', value);

  @override
  int get qty => RealmObjectBase.get<int>(this, 'qty') as int;
  @override
  set qty(int value) => RealmObjectBase.set(this, 'qty', value);

  @override
  DateTime get receiveDate =>
      RealmObjectBase.get<DateTime>(this, 'receiveDate') as DateTime;
  @override
  set receiveDate(DateTime value) =>
      RealmObjectBase.set(this, 'receiveDate', value);

  @override
  double? get weight => RealmObjectBase.get<double>(this, 'weight') as double?;
  @override
  set weight(double? value) => RealmObjectBase.set(this, 'weight', value);

  @override
  Stream<RealmObjectChanges<JobDetail>> get changes =>
      RealmObjectBase.getChanges<JobDetail>(this);

  @override
  JobDetail freeze() => RealmObjectBase.freezeObject<JobDetail>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(JobDetail._);
    return const SchemaObject(ObjectType.realmObject, JobDetail, 'JobDetail', [
      SchemaProperty('remark', RealmPropertyType.string),
      SchemaProperty('ordDetailId', RealmPropertyType.int),
      SchemaProperty('routelineId', RealmPropertyType.int),
      SchemaProperty('routeName', RealmPropertyType.string),
      SchemaProperty('nextRoutelineId', RealmPropertyType.int),
      SchemaProperty('orderStatus', RealmPropertyType.int),
      SchemaProperty('directionType', RealmPropertyType.int),
      SchemaProperty('barcode', RealmPropertyType.string),
      SchemaProperty('jobNumber', RealmPropertyType.string),
      SchemaProperty('customerId', RealmPropertyType.int),
      SchemaProperty('customerName', RealmPropertyType.string),
      SchemaProperty('statusFromServer', RealmPropertyType.int),
      SchemaProperty('isUpdatedFailed', RealmPropertyType.bool),
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('createdDateFromServer', RealmPropertyType.timestamp),
      SchemaProperty('goodsNumber', RealmPropertyType.string),
      SchemaProperty('goodsType', RealmPropertyType.string),
      SchemaProperty('goodsDetails', RealmPropertyType.string),
      SchemaProperty('receiverName', RealmPropertyType.string),
      SchemaProperty('receiverAddress', RealmPropertyType.string),
      SchemaProperty('receiverFullAddress', RealmPropertyType.string),
      SchemaProperty('imgPath', RealmPropertyType.string, optional: true),
      SchemaProperty('contactTelephone', RealmPropertyType.string),
      SchemaProperty('createdUserFromServer', RealmPropertyType.string),
      SchemaProperty('updatedDateFromServer', RealmPropertyType.string),
      SchemaProperty('latestUpdateTime', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('width', RealmPropertyType.double, optional: true),
      SchemaProperty('high', RealmPropertyType.double, optional: true),
      SchemaProperty('length', RealmPropertyType.double, optional: true),
      SchemaProperty('reference1', RealmPropertyType.string),
      SchemaProperty('reference2', RealmPropertyType.string),
      SchemaProperty('reference3', RealmPropertyType.string),
      SchemaProperty('updatedUserFromServer', RealmPropertyType.string,
          optional: true),
      SchemaProperty('contactName', RealmPropertyType.string),
      SchemaProperty('deliveryDate', RealmPropertyType.timestamp),
      SchemaProperty('contactEmail', RealmPropertyType.string, optional: true),
      SchemaProperty('deliveryDocumentDate', RealmPropertyType.timestamp),
      SchemaProperty('qty', RealmPropertyType.int),
      SchemaProperty('receiveDate', RealmPropertyType.timestamp),
      SchemaProperty('weight', RealmPropertyType.double, optional: true),
    ]);
  }
}

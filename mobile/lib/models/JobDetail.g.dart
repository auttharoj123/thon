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
    ..updatedUserFromServer = json['updated_user_from_server'] as String
    ..updatedDateFromServer = json['updated_date_from_server'] as String;
}

Map<String, dynamic> _$JobDetailToJson(_JobDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ord_detail_id': instance.ordDetailId,
      'routeline_id': instance.routelineId,
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

class JobDetail extends _JobDetail with RealmEntity, RealmObject {
  static var _defaultsSet = false;

  JobDetail(
    int id,
    int ordDetailId,
    int routelineId,
    int nextRoutelineId,
    int orderStatus,
    int directionType,
    String barcode,
    String jobNumber,
    int customerId,
    String customerName,
    DateTime deliveryDate,
    DateTime deliveryDocumentDate,
    DateTime receiveDate,
    DateTime createdDateFromServer,
    String goodsNumber,
    String goodsType,
    String goodsDetails,
    String receiverName,
    String receiverAddress,
    String receiverFullAddress,
    String contactName,
    String contactTelephone,
    int qty,
    String reference1,
    String reference2,
    String reference3,
    String remark,
    int statusFromServer,
    String createdUserFromServer,
    String updatedUserFromServer,
    String updatedDateFromServer, {
    String? contactEmail,
    double? weight,
    double? width,
    double? high,
    double? length,
    String? imgPath,
    bool isUpdatedFailed = false,
    DateTime? latestUpdateTime,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObject.setDefaults<JobDetail>({
        'isUpdatedFailed': false,
      });
    }
    RealmObject.set(this, 'id', id);
    RealmObject.set(this, 'ordDetailId', ordDetailId);
    RealmObject.set(this, 'routelineId', routelineId);
    RealmObject.set(this, 'nextRoutelineId', nextRoutelineId);
    RealmObject.set(this, 'orderStatus', orderStatus);
    RealmObject.set(this, 'directionType', directionType);
    RealmObject.set(this, 'barcode', barcode);
    RealmObject.set(this, 'jobNumber', jobNumber);
    RealmObject.set(this, 'customerId', customerId);
    RealmObject.set(this, 'customerName', customerName);
    RealmObject.set(this, 'deliveryDate', deliveryDate);
    RealmObject.set(this, 'deliveryDocumentDate', deliveryDocumentDate);
    RealmObject.set(this, 'receiveDate', receiveDate);
    RealmObject.set(this, 'createdDateFromServer', createdDateFromServer);
    RealmObject.set(this, 'goodsNumber', goodsNumber);
    RealmObject.set(this, 'goodsType', goodsType);
    RealmObject.set(this, 'goodsDetails', goodsDetails);
    RealmObject.set(this, 'receiverName', receiverName);
    RealmObject.set(this, 'receiverAddress', receiverAddress);
    RealmObject.set(this, 'receiverFullAddress', receiverFullAddress);
    RealmObject.set(this, 'contactName', contactName);
    RealmObject.set(this, 'contactTelephone', contactTelephone);
    RealmObject.set(this, 'contactEmail', contactEmail);
    RealmObject.set(this, 'qty', qty);
    RealmObject.set(this, 'weight', weight);
    RealmObject.set(this, 'width', width);
    RealmObject.set(this, 'high', high);
    RealmObject.set(this, 'length', length);
    RealmObject.set(this, 'reference1', reference1);
    RealmObject.set(this, 'reference2', reference2);
    RealmObject.set(this, 'reference3', reference3);
    RealmObject.set(this, 'remark', remark);
    RealmObject.set(this, 'imgPath', imgPath);
    RealmObject.set(this, 'statusFromServer', statusFromServer);
    RealmObject.set(this, 'createdUserFromServer', createdUserFromServer);
    RealmObject.set(this, 'updatedUserFromServer', updatedUserFromServer);
    RealmObject.set(this, 'updatedDateFromServer', updatedDateFromServer);
    RealmObject.set(this, 'isUpdatedFailed', isUpdatedFailed);
    RealmObject.set(this, 'latestUpdateTime', latestUpdateTime);
  }

  JobDetail._();

  @override
  int get id => RealmObject.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObject.set(this, 'id', value);

  @override
  int get ordDetailId => RealmObject.get<int>(this, 'ordDetailId') as int;
  @override
  set ordDetailId(int value) => RealmObject.set(this, 'ordDetailId', value);

  @override
  int get routelineId => RealmObject.get<int>(this, 'routelineId') as int;
  @override
  set routelineId(int value) => RealmObject.set(this, 'routelineId', value);

  @override
  int get nextRoutelineId =>
      RealmObject.get<int>(this, 'nextRoutelineId') as int;
  @override
  set nextRoutelineId(int value) =>
      RealmObject.set(this, 'nextRoutelineId', value);

  @override
  int get orderStatus => RealmObject.get<int>(this, 'orderStatus') as int;
  @override
  set orderStatus(int value) => RealmObject.set(this, 'orderStatus', value);

  @override
  int get directionType => RealmObject.get<int>(this, 'directionType') as int;
  @override
  set directionType(int value) => RealmObject.set(this, 'directionType', value);

  @override
  String get barcode => RealmObject.get<String>(this, 'barcode') as String;
  @override
  set barcode(String value) => RealmObject.set(this, 'barcode', value);

  @override
  String get jobNumber => RealmObject.get<String>(this, 'jobNumber') as String;
  @override
  set jobNumber(String value) => RealmObject.set(this, 'jobNumber', value);

  @override
  int get customerId => RealmObject.get<int>(this, 'customerId') as int;
  @override
  set customerId(int value) => RealmObject.set(this, 'customerId', value);

  @override
  String get customerName =>
      RealmObject.get<String>(this, 'customerName') as String;
  @override
  set customerName(String value) =>
      RealmObject.set(this, 'customerName', value);

  @override
  DateTime get deliveryDate =>
      RealmObject.get<DateTime>(this, 'deliveryDate') as DateTime;
  @override
  set deliveryDate(DateTime value) =>
      RealmObject.set(this, 'deliveryDate', value);

  @override
  DateTime get deliveryDocumentDate =>
      RealmObject.get<DateTime>(this, 'deliveryDocumentDate') as DateTime;
  @override
  set deliveryDocumentDate(DateTime value) =>
      RealmObject.set(this, 'deliveryDocumentDate', value);

  @override
  DateTime get receiveDate =>
      RealmObject.get<DateTime>(this, 'receiveDate') as DateTime;
  @override
  set receiveDate(DateTime value) =>
      RealmObject.set(this, 'receiveDate', value);

  @override
  DateTime get createdDateFromServer =>
      RealmObject.get<DateTime>(this, 'createdDateFromServer') as DateTime;
  @override
  set createdDateFromServer(DateTime value) =>
      RealmObject.set(this, 'createdDateFromServer', value);

  @override
  String get goodsNumber =>
      RealmObject.get<String>(this, 'goodsNumber') as String;
  @override
  set goodsNumber(String value) => RealmObject.set(this, 'goodsNumber', value);

  @override
  String get goodsType => RealmObject.get<String>(this, 'goodsType') as String;
  @override
  set goodsType(String value) => RealmObject.set(this, 'goodsType', value);

  @override
  String get goodsDetails =>
      RealmObject.get<String>(this, 'goodsDetails') as String;
  @override
  set goodsDetails(String value) =>
      RealmObject.set(this, 'goodsDetails', value);

  @override
  String get receiverName =>
      RealmObject.get<String>(this, 'receiverName') as String;
  @override
  set receiverName(String value) =>
      RealmObject.set(this, 'receiverName', value);

  @override
  String get receiverAddress =>
      RealmObject.get<String>(this, 'receiverAddress') as String;
  @override
  set receiverAddress(String value) =>
      RealmObject.set(this, 'receiverAddress', value);

  @override
  String get receiverFullAddress =>
      RealmObject.get<String>(this, 'receiverFullAddress') as String;
  @override
  set receiverFullAddress(String value) =>
      RealmObject.set(this, 'receiverFullAddress', value);

  @override
  String get contactName =>
      RealmObject.get<String>(this, 'contactName') as String;
  @override
  set contactName(String value) => RealmObject.set(this, 'contactName', value);

  @override
  String get contactTelephone =>
      RealmObject.get<String>(this, 'contactTelephone') as String;
  @override
  set contactTelephone(String value) =>
      RealmObject.set(this, 'contactTelephone', value);

  @override
  String? get contactEmail =>
      RealmObject.get<String>(this, 'contactEmail') as String?;
  @override
  set contactEmail(String? value) =>
      RealmObject.set(this, 'contactEmail', value);

  @override
  int get qty => RealmObject.get<int>(this, 'qty') as int;
  @override
  set qty(int value) => RealmObject.set(this, 'qty', value);

  @override
  double? get weight => RealmObject.get<double>(this, 'weight') as double?;
  @override
  set weight(double? value) => RealmObject.set(this, 'weight', value);

  @override
  double? get width => RealmObject.get<double>(this, 'width') as double?;
  @override
  set width(double? value) => RealmObject.set(this, 'width', value);

  @override
  double? get high => RealmObject.get<double>(this, 'high') as double?;
  @override
  set high(double? value) => RealmObject.set(this, 'high', value);

  @override
  double? get length => RealmObject.get<double>(this, 'length') as double?;
  @override
  set length(double? value) => RealmObject.set(this, 'length', value);

  @override
  String get reference1 =>
      RealmObject.get<String>(this, 'reference1') as String;
  @override
  set reference1(String value) => RealmObject.set(this, 'reference1', value);

  @override
  String get reference2 =>
      RealmObject.get<String>(this, 'reference2') as String;
  @override
  set reference2(String value) => RealmObject.set(this, 'reference2', value);

  @override
  String get reference3 =>
      RealmObject.get<String>(this, 'reference3') as String;
  @override
  set reference3(String value) => RealmObject.set(this, 'reference3', value);

  @override
  String get remark => RealmObject.get<String>(this, 'remark') as String;
  @override
  set remark(String value) => RealmObject.set(this, 'remark', value);

  @override
  String? get imgPath => RealmObject.get<String>(this, 'imgPath') as String?;
  @override
  set imgPath(String? value) => RealmObject.set(this, 'imgPath', value);

  @override
  int get statusFromServer =>
      RealmObject.get<int>(this, 'statusFromServer') as int;
  @override
  set statusFromServer(int value) =>
      RealmObject.set(this, 'statusFromServer', value);

  @override
  String get createdUserFromServer =>
      RealmObject.get<String>(this, 'createdUserFromServer') as String;
  @override
  set createdUserFromServer(String value) =>
      RealmObject.set(this, 'createdUserFromServer', value);

  @override
  String get updatedUserFromServer =>
      RealmObject.get<String>(this, 'updatedUserFromServer') as String;
  @override
  set updatedUserFromServer(String value) =>
      RealmObject.set(this, 'updatedUserFromServer', value);

  @override
  String get updatedDateFromServer =>
      RealmObject.get<String>(this, 'updatedDateFromServer') as String;
  @override
  set updatedDateFromServer(String value) =>
      RealmObject.set(this, 'updatedDateFromServer', value);

  @override
  bool get isUpdatedFailed =>
      RealmObject.get<bool>(this, 'isUpdatedFailed') as bool;
  @override
  set isUpdatedFailed(bool value) =>
      RealmObject.set(this, 'isUpdatedFailed', value);

  @override
  DateTime? get latestUpdateTime =>
      RealmObject.get<DateTime>(this, 'latestUpdateTime') as DateTime?;
  @override
  set latestUpdateTime(DateTime? value) =>
      RealmObject.set(this, 'latestUpdateTime', value);

  @override
  Stream<RealmObjectChanges<JobDetail>> get changes =>
      RealmObject.getChanges<JobDetail>(this);

  @override
  JobDetail freeze() => RealmObject.freezeObject<JobDetail>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObject.registerFactory(JobDetail._);
    return const SchemaObject(JobDetail, 'JobDetail', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('ordDetailId', RealmPropertyType.int),
      SchemaProperty('routelineId', RealmPropertyType.int),
      SchemaProperty('nextRoutelineId', RealmPropertyType.int),
      SchemaProperty('orderStatus', RealmPropertyType.int),
      SchemaProperty('directionType', RealmPropertyType.int),
      SchemaProperty('barcode', RealmPropertyType.string),
      SchemaProperty('jobNumber', RealmPropertyType.string),
      SchemaProperty('customerId', RealmPropertyType.int),
      SchemaProperty('customerName', RealmPropertyType.string),
      SchemaProperty('deliveryDate', RealmPropertyType.timestamp),
      SchemaProperty('deliveryDocumentDate', RealmPropertyType.timestamp),
      SchemaProperty('receiveDate', RealmPropertyType.timestamp),
      SchemaProperty('createdDateFromServer', RealmPropertyType.timestamp),
      SchemaProperty('goodsNumber', RealmPropertyType.string),
      SchemaProperty('goodsType', RealmPropertyType.string),
      SchemaProperty('goodsDetails', RealmPropertyType.string),
      SchemaProperty('receiverName', RealmPropertyType.string),
      SchemaProperty('receiverAddress', RealmPropertyType.string),
      SchemaProperty('receiverFullAddress', RealmPropertyType.string),
      SchemaProperty('contactName', RealmPropertyType.string),
      SchemaProperty('contactTelephone', RealmPropertyType.string),
      SchemaProperty('contactEmail', RealmPropertyType.string, optional: true),
      SchemaProperty('qty', RealmPropertyType.int),
      SchemaProperty('weight', RealmPropertyType.double, optional: true),
      SchemaProperty('width', RealmPropertyType.double, optional: true),
      SchemaProperty('high', RealmPropertyType.double, optional: true),
      SchemaProperty('length', RealmPropertyType.double, optional: true),
      SchemaProperty('reference1', RealmPropertyType.string),
      SchemaProperty('reference2', RealmPropertyType.string),
      SchemaProperty('reference3', RealmPropertyType.string),
      SchemaProperty('remark', RealmPropertyType.string),
      SchemaProperty('imgPath', RealmPropertyType.string, optional: true),
      SchemaProperty('statusFromServer', RealmPropertyType.int),
      SchemaProperty('createdUserFromServer', RealmPropertyType.string),
      SchemaProperty('updatedUserFromServer', RealmPropertyType.string),
      SchemaProperty('updatedDateFromServer', RealmPropertyType.string),
      SchemaProperty('isUpdatedFailed', RealmPropertyType.bool),
      SchemaProperty('latestUpdateTime', RealmPropertyType.timestamp,
          optional: true),
    ]);
  }
}

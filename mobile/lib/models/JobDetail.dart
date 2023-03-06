import 'package:realm/realm.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:json_annotation/json_annotation.dart';

part 'JobDetail.g.dart';

@RealmModel()
@JsonSerializable()
class _JobDetail {
  @PrimaryKey()
  @JsonKey(name: "id", required: true)
  late int id;
  @JsonKey(name: "ord_detail_id")
  late int ordDetailId;
  @JsonKey(name: "routeline_id")
  late int routelineId;
  @JsonKey(name: "routename")
  late String routeName;
  @JsonKey(name: "next_routeline_id")
  late int nextRoutelineId;
  @JsonKey(name: "order_status")
  late int orderStatus;
  @JsonKey(name: "direction_type")
  late int directionType;
  @JsonKey(name: "barcode")
  late String barcode;
  @JsonKey(name: "jobnumber")
  late String jobNumber;
  @JsonKey(name: "customer_id")
  late int customerId;
  @JsonKey(name: "customer_name")
  late String customerName;
  @JsonKey(name: "delivery_date")
  late DateTime deliveryDate;
  @JsonKey(name: "delivery_doc_date")
  late DateTime deliveryDocumentDate;
  @JsonKey(name: "receive_date")
  late DateTime receiveDate;
  @JsonKey(name: "created_date_from_server")
  late DateTime createdDateFromServer;
  @JsonKey(name: "goods_number")
  late String goodsNumber;
  @JsonKey(name: "goods_type")
  late String goodsType;
  @JsonKey(name: "goods_details")
  late String goodsDetails;
  @JsonKey(name: "receiver_name")
  late String receiverName;
  @JsonKey(name: "receiver_address")
  late String receiverAddress;
  @JsonKey(name: "receiver_full_address")
  late String receiverFullAddress;
  @JsonKey(name: "contact_name")
  late String contactName;
  @JsonKey(name: "contact_telephone")
  late String contactTelephone;
  @JsonKey(name: "contact_email")
  late String? contactEmail;
  @JsonKey(name: "qty")
  late int qty;
  @JsonKey(name: "weight", fromJson: _stringToDouble)
  late double? weight;
  @JsonKey(name: "width", fromJson: _stringToDouble)
  late double? width;
  @JsonKey(name: "high", fromJson: _stringToDouble)
  late double? high;
  @JsonKey(name: "length", fromJson: _stringToDouble)
  late double? length;
  @JsonKey(name: "reference1")
  late String reference1;
  @JsonKey(name: "reference2")
  late String reference2;
  @JsonKey(name: "reference3")
  late String reference3;
  @JsonKey(name: "remark")
  late String remark;
  @JsonKey(name: "img_path")
  late String? imgPath;
  @JsonKey(name: "status_from_server")
  late int statusFromServer;
  @JsonKey(name: "created_user_from_server")
  late String createdUserFromServer;
  @JsonKey(name: "updated_user_from_server")
  late String? updatedUserFromServer;
  @JsonKey(name: "updated_date_from_server")
  late String updatedDateFromServer;

  @JsonKey(includeFromJson: false)
  late bool isUpdatedFailed = false;

  @JsonKey(includeFromJson: false)
  late DateTime? latestUpdateTime;

  @JsonKey(includeFromJson: false)
  @Ignored()
  late bool isChecked = false;

  tz.TZDateTime get deliveryDateEx => tz.TZDateTime.from(
        deliveryDate,
        tz.getLocation('Asia/Bangkok'),
      );

  tz.TZDateTime get deliveryDocumentDateEx => tz.TZDateTime.from(
        deliveryDocumentDate,
        tz.getLocation('Asia/Bangkok'),
      );

  tz.TZDateTime get receiveDateEx => tz.TZDateTime.from(
        receiveDate,
        tz.getLocation('Asia/Bangkok'),
      );

  tz.TZDateTime get createdDateFromServerEx => tz.TZDateTime.from(
        createdDateFromServer,
        tz.getLocation('Asia/Bangkok'),
      );

  static double? _stringToDouble(String? number) =>
      number == null ? null : double.parse(number);
  //static String _stringFromInt(int number) => number?.toString();
}

extension JobDetailJ on JobDetail {
  static JobDetail toRealmObject(_JobDetail jobDetail) {
    return JobDetail(
      jobDetail.remark,
      jobDetail.ordDetailId,
      jobDetail.routelineId,
      jobDetail.routeName,
      jobDetail.nextRoutelineId,
      jobDetail.orderStatus,
      jobDetail.directionType,
      jobDetail.barcode,
      jobDetail.jobNumber,
      jobDetail.customerId,
      jobDetail.customerName,
      jobDetail.statusFromServer,
      jobDetail.id,
      jobDetail.createdDateFromServer,
      jobDetail.goodsNumber,
      jobDetail.goodsType,
      jobDetail.goodsDetails,
      jobDetail.receiverName,
      jobDetail.receiverAddress,
      jobDetail.receiverFullAddress,
      jobDetail.contactTelephone,
      jobDetail.createdUserFromServer,
      jobDetail.updatedDateFromServer,
      jobDetail.reference1,
      jobDetail.reference2,
      jobDetail.reference3,
      jobDetail.contactName,
      jobDetail.deliveryDate,
      jobDetail.deliveryDocumentDate,
      jobDetail.qty,
      jobDetail.receiveDate,
      isUpdatedFailed: jobDetail.isUpdatedFailed,
      imgPath: jobDetail.imgPath,
      width: jobDetail.width,
      high: jobDetail.high,
      length: jobDetail.length,
      updatedUserFromServer: jobDetail.updatedUserFromServer,
      contactEmail: jobDetail.contactEmail,
      weight: jobDetail.weight,
    );
  }

  static JobDetail fromJson(Map<String, dynamic> json) =>
      toRealmObject(_$JobDetailFromJson(json));
  Map<String, dynamic> toJson() => _$JobDetailToJson(this);
}

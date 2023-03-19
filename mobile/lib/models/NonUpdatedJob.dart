import 'package:realm/realm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'NonUpdatedJob.g.dart';

@RealmModel()
@JsonSerializable()
class _NonUpdatedJob {
  @PrimaryKey()
  late String id;
  late String jobIds;
  late String barcodes;
  late int sendJobType;
  late int targetOrderStatus;
  late int targetRemarkCategoryId;
  late String? specialRemark;
  late int selectedComplacencyLevel;
  late String signImagePath;
  late String? latitude;
  late String? longitude;
  late String? result;
  late List<String> imagesPath;
  late bool isUploadSuccess;
  late DateTime createdDate;
  late DateTime updatedDate;
  late String loginName;
}

extension NonUpdatedJobJ on NonUpdatedJob {
  static NonUpdatedJob toRealmObject(_NonUpdatedJob item) {
    return NonUpdatedJob(
        item.id,
        item.jobIds,
        item.barcodes,
        item.sendJobType,
        item.targetOrderStatus,
        item.targetRemarkCategoryId,
        item.selectedComplacencyLevel,
        item.signImagePath,
        item.isUploadSuccess,
        item.createdDate,
        item.updatedDate,
        item.loginName);
  }

  static NonUpdatedJob fromJson(Map<String, dynamic> json) =>
      toRealmObject(_$NonUpdatedJobFromJson(json));
  Map<String, dynamic> toJson() => _$NonUpdatedJobToJson(this);
}

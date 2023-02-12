import 'package:realm/realm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'MstType.g.dart';

// {
//     "mst_type_id": 112,
//     "head": 11,
//     "description": "Job Close Cat",
//     "type_detail": "ลูกค้าไม่รับตัวแถม",
//     "load_weight": "0.0000",
//     "load_volumn": "0.0000",
//     "datasort": 0,
//     "status": true,
//     "updated_date": null,
//     "updated_user": null,
//     "active_flg": 1
// },

@RealmModel()
@JsonSerializable()
class _MstType {
  @JsonKey(name: "mst_type_id", required: true)
  late int mstTypeId;
  @JsonKey(name: "head")
  late int head;
  @JsonKey(name: "description")
  late String description;
  @JsonKey(name: "type_detail")
  late String typeDetail;
}

extension MstTypeJ on MstType {
  static MstType toRealmObject(_MstType mstType) {
    return MstType(mstType.mstTypeId, mstType.head, mstType.description,mstType.typeDetail);
  }

  static MstType fromJson(Map<String, dynamic> json) =>
      toRealmObject(_$MstTypeFromJson(json));
  Map<String, dynamic> toJson() => _$MstTypeToJson(this);
}

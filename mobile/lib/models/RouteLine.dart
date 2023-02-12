import 'package:realm/realm.dart';
import 'package:json_annotation/json_annotation.dart';

part 'RouteLine.g.dart';

@RealmModel()
@JsonSerializable()
class _RouteLine {
  @JsonKey(name: "routeline_id", required: true)
  late int routelineId;
  @JsonKey(name: "routename")
  late String routename;
}

extension RouteLineJ on RouteLine {
  static RouteLine toRealmObject(_RouteLine routeline) {
    return RouteLine(
      routeline.routelineId,
      routeline.routename
    );
    
  }

  static RouteLine fromJson(Map<String, dynamic> json) =>
      toRealmObject(_$RouteLineFromJson(json));
  Map<String, dynamic> toJson() => _$RouteLineToJson(this);
}
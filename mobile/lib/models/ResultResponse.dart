import 'package:json_annotation/json_annotation.dart';

// part "ResultResponse.g.dart";

// @JsonSerializable()
class ResultResponse<T> {
  late bool isSuccess;
  late dynamic result;

  ResultResponse mapData(Map<String, dynamic> map, Function callback) {
    this.isSuccess = map["isSuccess"] as bool;
    if (map["result"] is List) {
      var items = map["result"] as List;
      List<T> values = [];
      for (var item in items) {
        T convertItem = callback(item);
        values.add(convertItem);
      }
      result = values;
    }
    return this;
  }
}

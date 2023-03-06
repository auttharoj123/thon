import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:slpod/models/JobDetail.dart';
import 'package:slpod/models/JobDetailWrapper.dart';
import "package:collection/collection.dart";

enum JobDetailGroupBy { barcode, customer, receiver }

class HeaderGroup extends Equatable {
  final String barcode;
  final int routeid;

  HeaderGroup({
    required this.barcode,
    required this.routeid,
  });

  @override
  List<Object> get props => [barcode, routeid];
}

extension JobWrapperExtension on List<JobDetailWrapper> {
  List<JobDetail> toJobDetailList() {
    List<JobDetail> items = [];
    for (var item in this) {
      items.addAll(item.items);
    }
    return items;
  }
}

extension JobDetailExtension on List<JobDetail> {
  List<JobDetailWrapper> toJobDetailWrapper(JobDetailGroupBy type) {
    var result;
    if (type == JobDetailGroupBy.barcode) {
      result = groupBy(
          this,
          (JobDetail item) =>
              HeaderGroup(barcode: item.barcode, routeid: item.routelineId));
    } else if (type == JobDetailGroupBy.customer) {
      result = groupBy(this, (JobDetail item) => item.customerName);
    } else if (type == JobDetailGroupBy.receiver) {
      result = groupBy(this, (JobDetail item) => item.receiverName);
    }
    List<JobDetailWrapper> items = [];
    result.forEach((key, value) {
      JobDetailWrapper item = JobDetailWrapper(key.barcode.toString(), value);
      item.id = Uuid.v4().toString();
      value.forEach((element) {
        item.totalQty += element.qty as int;
      });
      items.add(item);
    });
    return items;
  }
}

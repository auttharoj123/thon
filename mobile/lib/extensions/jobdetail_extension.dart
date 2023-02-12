import 'package:slpod/models/JobDetail.dart';
import 'package:slpod/models/JobDetailWrapper.dart';
import "package:collection/collection.dart";

enum JobDetailGroupBy 
{
  barcode,
  customer,
  receiver
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
    if(type == JobDetailGroupBy.barcode)
    {
      result = groupBy(this, (JobDetail item) => item.barcode);
    }
    else if(type == JobDetailGroupBy.customer)
    {
      result = groupBy(this, (JobDetail item) => item.customerName);
    }
    else if(type == JobDetailGroupBy.receiver)
    {
      result = groupBy(this, (JobDetail item) => item.receiverName);
    }
    List<JobDetailWrapper> items = [];
    result.forEach((key, value) {
      JobDetailWrapper item = JobDetailWrapper(key.toString(), value);
      items.add(item);
    });
    return items;
  }
}

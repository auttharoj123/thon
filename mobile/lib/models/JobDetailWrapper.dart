import 'JobDetail.dart';

class JobDetailWrapper {
  late String id;
  late bool isChecked = false;
  late String title;
  late int totalQty = 0;
  late List<JobDetail> items;

  JobDetailWrapper(String title, List<JobDetail> items) {
    this.title = title;
    this.items = items;
  }
}

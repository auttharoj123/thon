import 'JobDetail.dart';

class JobDetailWrapper {
  late bool isChecked = false;
  late String title;
  late List<JobDetail> items;

  JobDetailWrapper(String title, List<JobDetail> items) {
    this.title = title;
    this.items = items;
  }
}

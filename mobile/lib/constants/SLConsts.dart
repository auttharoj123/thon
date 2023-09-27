import 'package:flutter/material.dart';

class SLAppl {
  static const String VERSION = "3.0.2";
}

class SLColor {
  static const Color LIGHTBLUE1 = Color.fromRGBO(112, 172, 244, 1);
  static const Color LIGHTBLUE2 = Color.fromRGBO(95, 162, 240, 1);
  static const Color BLUE = Color.fromRGBO(47, 129, 229, 1);
}

class JobStatus {
  static const int NEW_CREATED = 0;
  static const int CREATE_JOB_DETAIL = 13;
  static const int TO_WAREHOUSE = 14;
  static const int DOCUMENTED = 15;
  static const int SENDING = 17;
  static const int SENT = 18;
  static const int REJECT_SENDING = 19;
}

class JobGroupStatus {
  static const List<int> OPEN_GROUP = <int>[
    JobStatus.NEW_CREATED,
    JobStatus.CREATE_JOB_DETAIL,
    JobStatus.TO_WAREHOUSE,
    JobStatus.DOCUMENTED
  ];
  static const List<int> SENDING_GROUP = <int>[JobStatus.SENDING];
  static const List<int> SENT_GROUP = <int>[JobStatus.SENT];
  static const List<int> REJECTED_GROUP = <int>[JobStatus.REJECT_SENDING];
}

class SendJobType {
  static const int NORMAL = 1;
  static const int REMARK = 2;
  static const int REJECT = 3;
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  final String category;
  final IconData categoryIcon;
  final Color color;

  Category(this.category, this.categoryIcon,this.color);

  static List<Category> categoryList() {
    List<Category> list = [];
    list.add(Category('งานที่ยังไม่ได้ทำ', FontAwesomeIcons.boxOpen, Colors.grey));
    list.add(Category('งานที่รับแล้ว', FontAwesomeIcons.box, Colors.yellow.shade600));
    list.add(Category('งานที่ส่งแล้ว', FontAwesomeIcons.solidPaperPlane, Colors.green));
    list.add(Category('งานที่ยกเลิก', FontAwesomeIcons.xmark, Colors.red));
    // list.add(Category('Gynaecologist', Icons.pregnant_woman));

    return list;
  }

  static List<Category> adminCategoryList() {
    List<Category> list = [];
    list.add(Category('งานทั้งหมด', FontAwesomeIcons.box, Colors.grey));
    list.add(Category('งานที่เลือก', FontAwesomeIcons.box, Colors.green));
    // list.add(Category('Gynaecologist', Icons.pregnant_woman));

    return list;
  }
}

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:slpod/components/expansion_tile_partial.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'package:slpod/models/JobDetail.dart';

class JobDetailScreenPage extends StatefulWidget {
  JobDetailScreenPage({Key? key}) : super(key: key);

  @override
  State<JobDetailScreenPage> createState() => _JobDetailScreenPageState();
}

class _JobDetailScreenPageState extends State<JobDetailScreenPage> {
  final titleStyle = TextStyle(
      fontFamily: 'Kanit',
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w800);
  final titleImportantStyle = TextStyle(
      fontFamily: 'Kanit',
      color: Colors.red,
      fontSize: 18,
      fontWeight: FontWeight.w800);      
  final detailStyle =
      TextStyle(fontFamily: 'Kanit', color: Colors.black, fontSize: 18);
  final detailImportantStyle =
      TextStyle(fontFamily: 'Kanit', color: Colors.red, fontSize: 18);      

  Widget buildGeneralComponent(JobDetail item) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: ExpansionTileNew(
          initiallyExpanded: true,
          childrenPadding: FxSpacing.symmetric(vertical: 10, horizontal: 20),
          title: FxText.titleLarge("ทั่วไป"),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "หมายเลขงาน: ", style: titleStyle),
                  TextSpan(text: item.jobNumber, style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "บาร์โค้ด: ", style: titleStyle),
                  TextSpan(text: item.barcode, style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "ชื่อลูกค้า: ", style: titleStyle),
                  TextSpan(text: item.customerName, style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "วันที่ส่งของ: ", style: titleStyle),
                  TextSpan(
                      text: formatDate(item.deliveryDateEx,
                          [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
                      style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "วันที่บิล: ", style: titleStyle),
                  TextSpan(
                      text: formatDate(item.receiveDateEx,
                          [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
                      style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "วันที่ใบคุม: ", style: titleStyle),
                  TextSpan(
                      text: formatDate(item.deliveryDocumentDateEx,
                          [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
                      style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "วันที่สร้าง: ", style: titleStyle),
                  TextSpan(
                      text: formatDate(item.createdDateFromServerEx,
                          [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]),
                      style: detailStyle)
                ])),
              ],
            ),
            (item.remark.isEmpty) ? Container() :
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "หมายเหตุ: ", style: titleImportantStyle,),
                  TextSpan(text: item.remark, style: detailImportantStyle)
                ])),
              ],
            ),
          ]),
    );
  }

  Widget buildProductComponent(JobDetail item) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: ExpansionTileNew(
          initiallyExpanded: true,
          childrenPadding: FxSpacing.symmetric(vertical: 10, horizontal: 20),
          title: FxText.titleLarge("สินค้า"),
          children: [
            (item.goodsNumber.isEmpty) ? Container() :
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "หมายเลข: ", style: titleStyle),
                  TextSpan(text: item.goodsNumber, style: detailStyle)
                ])),
              ],
            ),
            (item.goodsType.isEmpty) ? Container() :
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "ประเภท: ", style: titleStyle),
                  TextSpan(text: item.goodsType, style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "รายละเอียด: ", style: titleStyle),
                  TextSpan(text: item.goodsDetails, style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "จำนวน: ", style: titleStyle),
                  TextSpan(text: item.qty.toString(), style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "น้ำหนัก: ", style: titleStyle),
                  TextSpan(
                      text: (item.weight == null)
                          ? '0.0'
                          : item.weight.toString(),
                      style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "ความกว้าง: ", style: titleStyle),
                  TextSpan(
                      text:
                          (item.width == null) ? '0.0' : item.width.toString(),
                      style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "ความสูง: ", style: titleStyle),
                  TextSpan(
                      text: (item.high == null) ? '0.0' : item.high.toString(),
                      style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "ความยาว: ", style: titleStyle),
                  TextSpan(
                      text: (item.length == null)
                          ? '0.0'
                          : item.length.toString(),
                      style: detailStyle)
                ])),
              ],
            ),
          ]),
    );
  }

  Widget buildReceiverComponent(JobDetail item) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: ExpansionTileNew(
          initiallyExpanded: true,
          childrenPadding: FxSpacing.symmetric(vertical: 10, horizontal: 20),
          title: FxText.titleLarge("ผู้รับ"),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "ชื่อ: ", style: titleStyle),
                  TextSpan(text: item.receiverName, style: detailStyle)
                ])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "ที่อยู่: ", style: titleStyle),
                  TextSpan(text: item.receiverFullAddress, style: detailStyle)
                ])),
              ],
            )
          ]),
    );
  }

  Widget buildContactComponent(JobDetail item) {
    return (item.contactTelephone.isEmpty) ? Container() : Container(
      padding: const EdgeInsets.all(10.0),
      child: ExpansionTileNew(
          initiallyExpanded: true,
          childrenPadding: FxSpacing.symmetric(vertical: 10, horizontal: 20),
          title: FxText.titleLarge("ผู้ติดต่อ"),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "หมายเลขโทรศัพท์: ", style: titleStyle),
                  TextSpan(text: item.contactTelephone, style: detailStyle)
                ])),
              ],
            )
          ]),
    );
  }

  Widget buildReferenceComponent(JobDetail item) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: ExpansionTileNew(
          initiallyExpanded: true,
          childrenPadding: FxSpacing.symmetric(vertical: 10, horizontal: 20),
          title: FxText.titleLarge("อ้างอิง"),
          children: [
            (item.reference1.isEmpty) ? Container() :
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "อ้างอิง1: ", style: titleStyle),
                  TextSpan(text: item.reference1, style: detailStyle)
                ])),
              ],
            ),
            (item.reference2.isEmpty) ? Container() :
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "อ้างอิง2: ", style: titleStyle),
                  TextSpan(text: item.reference2, style: detailStyle)
                ])),
              ],
            ),
            (item.reference3.isEmpty) ? Container() :
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "อ้างอิง3: ", style: titleStyle),
                  TextSpan(text: item.reference3, style: detailStyle)
                ])),
              ],
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as JobDetail;
    return Scaffold(
      body: Column(
        children: [
          FxContainer(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.zero,
            width: double.infinity,
            color: SLColor.LIGHTBLUE2,
            child: SafeArea(
                child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: Colors.white,
                ),
                FxSpacing.width(20),
                FxText.titleLarge(item.jobNumber, color: Colors.white),
              ],
            )),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                buildGeneralComponent(item),
                buildProductComponent(item),
                buildReceiverComponent(item),
                buildContactComponent(item),
                buildReferenceComponent(item)
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

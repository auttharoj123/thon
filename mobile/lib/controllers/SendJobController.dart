import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realm/realm.dart';
import 'package:signature/signature.dart';
import 'package:slpod/constants/SLConsts.dart';
import 'dart:ui' as ui;
import 'package:slpod/controllers/BaseController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slpod/extensions/extensions.dart';
import 'package:slpod/managers/file_manager.dart';
import 'package:slpod/models/JobDetail.dart';
import 'package:slpod/models/NonUpdatedJob.dart';
import 'package:slpod/repositories/job_repostitory.dart';
import 'package:slpod/utils/UpdateJobForegroundService.dart';
import 'package:slpod/views/Reuseable/GlobalWidget.dart';

class SendJobController extends BaseController {
  late int point = 0;
  late String remarkCatId = "63";
  late String remarkCatIdDump = "";
  late List<String> selectedImages = [];
  late List<String> selectedSpecialRemark = [];
  Uint8List? signatureImage;
  final ImagePicker _picker = ImagePicker();
  late ScrollController scrollController;
  late PageController pageController;
  late int currentPageState = 0;
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  var color = Colors.black;
  var strokeWidth = 3.0;
  var globalWidget = GlobalWidget();
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    pageController = PageController();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  String getTag() {
    return "sendjob_controller";
  }

  bool checkSpecialRemark(String remark) {
    return selectedSpecialRemark.contains(remark);
  }

  void checkedSpecialRemark(String remark) {
    if (checkSpecialRemark(remark)) {
      selectedSpecialRemark.remove(remark);
    } else {
      selectedSpecialRemark.add(remark);
    }
    update();
  }

  Future<void> pickMultiImage() async {
    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 25);
    final paths = images!.map((e) => e.path).toList();

    var totalImage = paths.length + selectedImages.length;
    if (totalImage > 10) {
      selectedImages.addAll(paths.sublist(0, 10 - selectedImages.length));
    } else {
      selectedImages.addAll(paths);
    }

    update();
    scrollController.animateTo(200.0 * selectedImages.length,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  Future<void> pickCameraImage() async {
    try {
      final pickedFile =
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 25);

      if (selectedImages.length == 10) {
        return;
      }
      selectedImages.add(pickedFile!.path);
      update();
      scrollController.animateTo(200.0 * selectedImages.length,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    } catch (e) {
      update();
    }
  }

  void nextPage() async {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (currentPageState == 0) {
      if (args["jobType"] == SendJobType.NORMAL) {
        if (point == 0) {
          showDialog(
              context: context,
              builder: (context) => globalWidget.errorDialog(
                  context, "กรุณาเลือกคะแนนความพึงพอใจ"));
          return;
        }

        if (signatureController.isEmpty) {
          showDialog(
              context: context,
              builder: (context) =>
                  globalWidget.errorDialog(context, "กรุณาลงลายเซ็น"));
          return;
        }

        signatureImage = await signatureController.toPngBytes();

        currentPageState++;
        pageController.animateToPage(currentPageState,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
        update();
      } else if (args["jobType"] == SendJobType.REMARK) {
        if (remarkCatIdDump.isEmpty) {
          showDialog(
              context: context,
              builder: (context) => globalWidget.errorDialog(
                  context, "กรุณาเลือกหมายเหตุการส่งงาน"));
          return;
        }

        currentPageState++;
        pageController.animateToPage(currentPageState,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
        update();
      }
    } else if (currentPageState == 1) {
      var isSendJobRemark = args["jobType"] == SendJobType.REMARK;

      if (selectedImages.length == 0) {
        showDialog(
            context: context,
            builder: (context) => globalWidget.errorDialog(
                context, "กรุณาอัพโหลดรูปอย่างน้อย 1 รูป"));
        return;
      }

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => globalWidget.showLoading());

      final Directory directory = await FileManager.createDirectory("Pictures");
      final String path = directory.path;

      File? signatureFile;
      if (!isSendJobRemark) {
        var signImageId = Uuid.v4().toString();
        signatureFile = File("$path/$signImageId.png");
        await signatureFile.writeAsBytes(signatureImage!);
      }

      List<File> imageFiles = [];
      for (var i = 0; i < selectedImages.length; i++) {
        var imageId = Uuid.v4().toString();
        File file = File(selectedImages[i]);
        File copyFile = file.copySync("$path/$imageId.jpg");
        imageFiles.add(copyFile);
      }

      var jobs = args["jobs"] as List<JobDetail>;

      var barcodes = [];
      for (var i = 0; i < jobs.length; i++) {
        var barcode = jobs[i].barcode;
        if (barcodes.contains(barcode)) {
          continue;
        }
        barcodes.add(barcode);
      }

      String ids = jobs.map((item) => item.id).join(",");
      List<String> imagesPath = imageFiles.map((item) => item.path).toList();

      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      await JobRepository.addNonUpdatedJob(NonUpdatedJob(
          ids,
          barcodes.join(','),
          isSendJobRemark ? JobStatus.SENDING : JobStatus.SENT,
          isSendJobRemark ? remarkCatIdDump.toInt() : remarkCatId.toInt(),
          point,
          isSendJobRemark ? "" : signatureFile!.path,
          false,
          DateTime.now(),
          DateTime.now(),
          imagesPath: imagesPath,
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString(),
          specialRemark: selectedSpecialRemark.length > 0
              ? selectedSpecialRemark.join(',')
              : ""));

      if (!isSendJobRemark) {
        for (var i = 0; i < jobs.length; i++) {
          try {
            await JobRepository.updateJobDetail(jobs[i].id, JobStatus.SENT);
          } catch (e) {
            print(e);
          }
        }
      }

      Navigator.of(context).pop();

      // appController.sendJobEventStreamController.add(true);
      UpdateJobForegroundService.startForegroundTask();
      Navigator.of(context).pop();
    }
  }

  void previousPage() async {
    if (currentPageState == 0) return;

    currentPageState--;
    pageController.animateToPage(currentPageState,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
    update();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

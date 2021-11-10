import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:nearlikes/constants/constants.dart';

class DownloadController extends GetxController {
  final RxDouble _progress = 0.0.obs;
  Directory _directory;

  static final Dio _dio = Dio();
  static const MethodChannel methondChannel =
      MethodChannel("com.example.nearlikes/permission");

  double get progress => _progress.value;

  set progress(double progress) => _progress.value = progress;

  Future<void> downloadMedia(String url, String fileName) async {
    progress = 0;
    await _getDirectory();

    if (!await _directory.exists()) {
      await _directory.create(recursive: true);
    }
    if (await _directory.exists()) {
      File file = File(_directory.path + '/$fileName');
      Get.dialog(const DownloadingDialog(), barrierDismissible: false);
      print('Downloading start');
      try {
        await _dio.download(url, file.path,
            onReceiveProgress: (received, total) {
          progress = received / total;
        });
        GallerySaver.saveImage(file.path);
        print('Downloading end');
        if (Get.isDialogOpen) {
          Get.back(closeOverlays: true);
        }
        Get.snackbar(
          'Downloaded',
          'File has been downloaded to your device.',
          icon: const Icon(Icons.thumb_up_alt_rounded, color: Colors.white),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(file.path, isReturnPathOfIOS: true);
        }
      } catch (e) {
        log("Error downloading file --> $e");
        if (Get.isDialogOpen) Get.back(closeOverlays: true);
        Get.snackbar(
          'Error',
          'Unable to download file',
          icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  ///This method will get the [path] where the media is to be saved
  Future<void> _getDirectory() async {
    try {
      if (await methondChannel.invokeMethod('getPermission')) {
        log("Permission Granted in flutter");

        _directory = await getExternalStorageDirectory();

        String newPath = "";
        print(_directory);

        // Way 1
        List<String> paths = _directory.path.split("/");

        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/Nearlikes";
        // --------- Way 1 ends ----------

        // Way 2
        // newPath = _directory.path + "/Nearlikes";
        // // --------- Way 2 ends ----------

        log(newPath);
        _directory = Directory(newPath);
        return;
      } else {
        Get.snackbar(
          'Permission Required',
          'Storage permission is required to store the file',
          icon: const Icon(Icons.thumb_up_alt_rounded, color: Colors.white),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
    } catch (e) {
      log("Error in getting directory --> $e");
      Get.snackbar(
        'Error',
        'Unable to locate directory',
        icon: const Icon(Icons.error_outline_rounded, color: Colors.white),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// This method is to request for [permission] if required
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      PermissionStatus result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
      log('$permission --> $result');
    }
    return false;
  }
}

///A [dialog] box to show when media is downloading
class DownloadingDialog extends StatelessWidget {
  const DownloadingDialog({Key key}) : super(key: key);

  static DownloadController downloadController = Get.find();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: size.height.tenPercent,
          child: Center(
            child: Obx(
              () => Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: size.height.onePercent,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(kSecondaryColor),
                    value: downloadController.progress,
                  ),
                  SizedBox(width: size.width.fivePercent),
                  Text(
                    '${(downloadController.progress * 100).toPrecision(2)} % Downloaded',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

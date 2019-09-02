import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'toast_util.dart';
import 'check_util.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

typedef ScreenShotSuccess(String imagePath);

class ScreenShotUtil {
  static saveScreenShot(ScreenShotOption option) {
    if (null == option) {
      showShortToast("参数为null");
      return;
    }
    if (null == option.renderOption) {
      showShortToast("widget参数为null");
      return;
    }
    if (null == option.fileOption) {
      showShortToast("文件参数为null");
      return;
    }

    RenderRepaintBoundary boundary;
    if (null != option.renderOption.boundary) {
      boundary = option.renderOption.boundary;
    } else {
      RenderObject renderObject =
          option.renderOption.buildContext?.findRenderObject() ??
              option.renderOption.globalKey?.currentContext?.findRenderObject();
      if (null != renderObject && renderObject is RenderRepaintBoundary) {
        boundary = renderObject;
      }
    }
    captureImage2List(boundary, option.renderOption.pixelRatio,
        option.renderOption.imageFormatType)
        .then((unit8List) async {
      if (unit8List == null || unit8List.length == 0) {
        if (option.fail != null) option.fail();
        return;
      }
      saveImage(unit8List, option.fileOption,
          success: option.success, fail: option.fail);
    });
  }

  static saveImage(Uint8List unit8List, ScreenShotFileOption fileOption,
      {ScreenShotSuccess success, Function fail}) async {
    String fullPath;
    if (stringNotEmpty(fileOption?.fullPath)) {
      fullPath = fileOption.fullPath;
    } else if (null != fileOption?.directory &&
        stringNotEmpty(fileOption?.fileName)) {
      bool isTargetDirExist = await fileOption.directory.exists();
      if (!isTargetDirExist) fileOption.directory.create();

      fullPath = fileOption.directory.absolute.path +
          (fileOption.directory.absolute.path.endsWith("/") ? "" : "/") +
          fileOption.fileName;
    } else if (stringNotEmpty(fileOption?.fileName)) {
      Directory dir = await getApplicationDocumentsDirectory();
      if (null != dir) {
        bool isDirExist = await dir.exists();
        if (!isDirExist) dir.create();
        fullPath = dir.absolute.path +
            (dir.absolute.path.endsWith("/") ? "" : "/") +
            fileOption.fileName;
      }
    }
    if (stringBlank(fullPath)) {
      showShortToast("目标目录生成错误");
      if (null != fail) fail();
      return;
    }

    File image = File(fullPath);
    bool isExist = await image.exists();
    if (isExist) await image.delete();
    File(fullPath).writeAsBytes(unit8List).then((_) async {
      if (fileOption.isNotifyAlbum) {
//        FlutterDeviceInfo deviceInfo = FlutterDeviceInfo();
//        bool isFreshSuccess = await deviceInfo.refreshAlbum(fullPath,
//            isInsertAlbum: fileOption.isInsertAlbum,
//            isReplaceOld: fileOption.isReplaceOld,
//            isNotifyAlbum: fileOption.isNotifyAlbum);
//        if ((null == isFreshSuccess || !isFreshSuccess) && null != fail) {
//          showShortToast("刷新图库失败");
//          fail();
//          return;
//        }
      }
      if (null != success) {
        success(fullPath);
      }
    });
  }

  static Future<Uint8List> captureImage2List(RenderRepaintBoundary boundary,
      double pixelRatio, ImageByteFormat imageFormatType) async {
    try{
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData byteData = await image.toByteData(format: imageFormatType);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    }catch(e){
      print(e);
    }
    return null;
  }
}

class ScreenShotOption {
  ScreenShotRenderOption renderOption;
  ScreenShotFileOption fileOption;
  ScreenShotSuccess success;
  Function fail;

  ScreenShotOption(this.renderOption, this.fileOption,
      {this.success, this.fail});
}

class ScreenShotFileOption {
  String fileName;
  String fullPath;
  Directory directory;
  bool isInsertAlbum;
  bool isNotifyAlbum;
  bool isReplaceOld;

  ScreenShotFileOption.withDefault(this.fileName,
      {this.isInsertAlbum = false,
        this.isNotifyAlbum = false,
        this.isReplaceOld = true});

  ScreenShotFileOption.withDirectory(this.directory, this.fileName,
      {this.isInsertAlbum = false,
        this.isNotifyAlbum = false,
        this.isReplaceOld = true});

  ScreenShotFileOption.withPath(this.fullPath,
      {this.isInsertAlbum = false,
        this.isNotifyAlbum = false,
        this.isReplaceOld = true});
}

class ScreenShotRenderOption {
  GlobalKey globalKey;
  BuildContext buildContext;
  RenderRepaintBoundary boundary;

  //暂时只支持png,jpg等需要加入第三方库处理
  ImageByteFormat imageFormatType;
  double pixelRatio;

  ScreenShotRenderOption.withDefault(this.boundary,
      {this.pixelRatio = 1.0, this.imageFormatType = ImageByteFormat.png});

  ScreenShotRenderOption.withBuildContext(this.buildContext,
      {this.pixelRatio = 1.0, this.imageFormatType = ImageByteFormat.png});

  ScreenShotRenderOption.withGlobalKey(this.globalKey,
      {this.pixelRatio = 1.0, this.imageFormatType = ImageByteFormat.png});
}

import 'dart:io';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const MethodChannel _channel = const MethodChannel("org.sparcs.otlplus");

Future<void> exportImage(RenderRepaintBoundary boundary) async {
  final image = await boundary.toImage(pixelRatio: 3.0);
  final byteData = await image.toByteData(format: ImageByteFormat.png);

  writeImage(byteData?.buffer.asUint8List());
}

Future<void> writeImage(Uint8List? bytes) async {
  final fileName = "OTL-${DateTime.now().millisecondsSinceEpoch}.png";

  if (Platform.isAndroid) {
    if (await Permission.storage.request().isGranted) {
      _channel.invokeMethod("writeImageAsBytes", <String, dynamic>{
        "fileName": fileName,
        "bytes": bytes,
      });
    }
  } else {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/$fileName";
    File(path).writeAsBytesSync(bytes as List<int>);
    OpenFile.open(path);
  }
}

import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageResizerData {
  ImageResizerData({
    @required this.sendPort,
    @required this.imageToResize,
    @required this.size,
    @required this.quality,
  });

  final SendPort sendPort;
  final File imageToResize;
  final int size;
  final int quality;
}

void imageResizerIsolate(ImageResizerData data) async {
  final image = img.decodeImage(data.imageToResize.readAsBytesSync());
  final resizedImage = img.copyResizeCropSquare(image, data.size);
  final jpgImage = img.encodeJpg(resizedImage, quality: data.quality);

  data.sendPort.send(jpgImage);
}

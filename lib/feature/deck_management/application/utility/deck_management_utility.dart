import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DeckManagementUtility {
  static Future<ui.Image> convertCustomPainterToImage(
    CustomPainter painter,
    Size size, {
    double pixelRatio = 1.0,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.scale(pixelRatio);

    painter.paint(canvas, size);

    final picture = recorder.endRecording();

    final image = await picture.toImage(
      (size.width * pixelRatio).toInt(),
      (size.height * pixelRatio).toInt(),
    );
    return image;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../shared/application/application_exception.dart';
import '../../../../shared/data_source/model/request/shared_request.dart';
import '../../model/deck_model/deck_model.dart';

class ExportDeckUtility {
  static const cardSize = Size(300, 600);

  static Future<List<FileItem>> getDeckImages(
    Map<String, Widget> cards,
    double pixelRatio,
    CardPainterState state,
    void Function() onProgress,
  ) async {
    final List<FileItem> files = await _getWidgetImages(
      cards,
      pixelRatio,
      state,
      onProgress,
    );

    if (files.isEmpty) {
      throw InvalidDataException(
        'No images could be generated for export. Please check card data or try again.',
      );
    }
    return files;
  }

  static Future<Uint8List?> _captureWidgetAsPng(
    Widget widget,
    Size size,
    double pixelRatio,
  ) async {
    try {
      final Uint8List byteData = await ScreenshotController().captureFromWidget(
        widget,
        delay: const Duration(milliseconds: 10),
        pixelRatio: pixelRatio,
        targetSize: size,
      );
      return byteData;
    } catch (_) {}
    return null;
  }

  static Future<List<FileItem>> _getWidgetImages(
    Map<String, Widget> cardWidgets,
    double pixelRatio,
    CardPainterState state,
    void Function() onProgress,
  ) async {
    final List<FileItem> files = [];
    List<String> failedCardNames = [];

    for (MapEntry<String, Widget> entry in cardWidgets.entries) {
      Uint8List? byteData;
      try {
        byteData = await _captureWidgetAsPng(entry.value, cardSize, pixelRatio);
      } catch (e, st) {
        debugPrint("Error capturing card ${entry.key}: $e\n$st");
      }

      if (byteData != null) {
        files.add(
          FileItem(
            fileName: entry.key,
            fileExtension: "png",
            fileBytes: byteData,
          ),
        );
        onProgress.call();
      } else {
        failedCardNames.add(entry.key);
      }
    }

    if (failedCardNames.isNotEmpty) {
      throw DataAccessException(
        'Failed to capture images for some cards (${failedCardNames.join(', ')}). They will not be exported.',
      );
    }
    return files;
  }

  static String getDeckTitle(Suit? suit, int? number) {
    final String suitSymbol = suit?.name ?? "";
    final String numberSymbol = number.toString();
    final String title =
        "$numberSymbol${suitSymbol.isNotEmpty && numberSymbol.isNotEmpty ? "of" : ""}$suitSymbol";
    return title;
  }
}

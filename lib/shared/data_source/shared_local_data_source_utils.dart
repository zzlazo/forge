import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

import 'data_source_exception.dart';
import 'model/request/shared_request.dart';
import 'shared_data_source_utils.dart';

abstract class SharedLocalDataSourceUtils {
  Future<T> loadFileAsModel<T>(LoadLocalFileAsModelRequest<T> request);
  Future<List<T>> loadFileAsModelList<T>(
    LoadLocalFileAsModelRequest<T> request,
  );
  Future<T?> loadJsonAsset<T>(LoadAssetRequest request);
  Future<void> saveJsonFile(SaveJsonFileLocalRequest request);
  Future<void> deleteFile(DeleteLocalFileRequest request);
  Future<void> createAndSaveZipFromBytes(ZipLocalFileRequest request);
}

class SharedLocalDataSourceUtilsImpl implements SharedLocalDataSourceUtils {
  @override
  Future<T> loadFileAsModel<T>(LoadLocalFileAsModelRequest<T> request) async {
    try {
      final jsonMap = await _loadFileAsJson<Map<String, dynamic>>(
        LoadLocalFileAsJsonRequest(
          fileName: request.fileName,
          directoryPath: request.directoryPath,
        ),
      );
      return SharedDataSourceUtils.wrapParseJsonToModel(
        () => request.fromJson(jsonMap),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<T>> loadFileAsModelList<T>(
    LoadLocalFileAsModelRequest<T> request,
  ) async {
    try {
      final jsonMap = await _loadFileAsJson<List<dynamic>>(
        LoadLocalFileAsJsonRequest(
          fileName: request.fileName,
          directoryPath: request.directoryPath,
        ),
      );
      return jsonMap
          .map(
            (e) => SharedDataSourceUtils.wrapParseJsonToModel<T>(
              () => request.fromJson(e as Map<String, dynamic>),
            ),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<T> _loadFileAsJson<T>(LoadLocalFileAsJsonRequest request) async {
    try {
      final file = File('${request.directoryPath}/${request.fileName}');

      if (!await file.exists()) {
        throw FileNotFoundException(request.fileName);
      }

      final String jsonString = await file.readAsString();
      final T jsonMap = SharedDataSourceUtils.wrapJsonDecode<T>(
        jsonString,
        request.fileName,
      );
      return jsonMap;
    } on PathNotFoundException catch (_) {
      throw FileNotFoundException(request.fileName);
    } on FileLoadException catch (_) {
      rethrow;
    } on DataSourceException catch (_) {
      rethrow;
    } catch (e) {
      throw FileLoadException(request.fileName, e.toString());
    }
  }

  @override
  Future<void> saveJsonFile(SaveJsonFileLocalRequest request) async {
    try {
      final file = File('${request.directoryPath}/${request.fileName}');
      await file.writeAsString(jsonEncode(request.json));
    } on PathNotFoundException catch (e) {
      throw FileSaveException(
        request.fileName,
        'Directory not found: ${e.message}',
      );
    } catch (e) {
      throw FileSaveException(request.fileName, e.toString());
    }
  }

  @override
  Future<void> deleteFile(DeleteLocalFileRequest request) async {
    for (final item in request.items) {
      try {
        final file = File('${item.directoryPath}/${item.fileName}');
        if (await file.exists()) {
          await file.delete();
        }
      } on PathNotFoundException catch (_) {
      } catch (e) {
        throw FileDeleteException(item.fileName, e.toString());
      }
    }
  }

  @override
  Future<T?> loadJsonAsset<T>(LoadAssetRequest request) async {
    final String path = "assets/${request.directoryPath}/${request.fileName}";
    try {
      String jsonString = await rootBundle.loadString(path);
      if (jsonString.isEmpty) {
        return null;
      } else {
        final T jsonData = SharedDataSourceUtils.wrapJsonDecode<T>(
          jsonString,
          path,
        );
        return jsonData;
      }
    } on FlutterError catch (e) {
      if (e.message.contains('Unable to load asset')) {
        throw FileNotFoundException(path);
      }
      throw FileLoadException(path, 'Failed to load asset: ${e.message}');
    } on FileLoadException catch (_) {
      rethrow;
    } on DataSourceException catch (_) {
      rethrow;
    } catch (e) {
      throw FileLoadException(
        path,
        'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> createAndSaveZipFromBytes(ZipLocalFileRequest request) async {
    Uint8List? zipBytes;
    const String zipFileExtension = 'zip';

    try {
      final archive = Archive();
      for (final entry in request.files) {
        archive.addFile(
          ArchiveFile(
            "${entry.fileName}.${entry.fileExtension}",
            entry.fileBytes.length,
            entry.fileBytes,
          ),
        );
      }

      final List<int> encodedBytes = ZipEncoder().encode(archive);
      if (encodedBytes.isEmpty) {
        throw UnexpectedParsingException(
          'Failed to generate ZIP file: Encoded byte data is empty.',
        );
      }
      zipBytes = Uint8List.fromList(encodedBytes);

      final tempFile = XFile.fromData(zipBytes, mimeType: "application/zip");

      final params = ShareParams(
        files: [tempFile],
        fileNameOverrides: ["${request.fileName}.$zipFileExtension"],
      );

      final result = await SharePlus.instance.share(params);

      switch (result.status) {
        case ShareResultStatus.dismissed:
          throw OperationCanceledException("Share was dismissed");
        case ShareResultStatus.unavailable:
          throw FileSaveException(tempFile.path, "Share is not available ");
        case _:
      }
    } on Exception catch (e) {
      throw FileSaveException(
        e.toString(),
        'An unexpected error occurred during ZIP creation or saving: $e',
      );
    }
  }
}

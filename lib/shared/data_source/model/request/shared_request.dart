import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shared_request.freezed.dart';

@freezed
abstract class SaveJsonFileLocalRequest with _$SaveJsonFileLocalRequest {
  const factory SaveJsonFileLocalRequest({
    required Object json,
    required String directoryPath,
    required String fileName,
  }) = _SaveJsonFileLocalRequest;
}

@freezed
abstract class ZipLocalFileRequest with _$ZipLocalFileRequest {
  const factory ZipLocalFileRequest({
    required List<FileItem> files,
    required String fileName,
  }) = _ZipLocalFileRequest;
}

@freezed
abstract class FileItem with _$FileItem {
  const factory FileItem({
    required String fileName,
    required String fileExtension,
    required Uint8List fileBytes,
  }) = _FileItem;
}

@freezed
abstract class LoadLocalFileAsModelRequest<T>
    with _$LoadLocalFileAsModelRequest<T> {
  factory LoadLocalFileAsModelRequest({
    required String fileName,
    required String directoryPath,
    required T Function(Map<String, dynamic>) fromJson,
  }) = _LoadLocalFileAsModelRequest<T>;
}

@freezed
abstract class LoadAssetRequest with _$LoadAssetRequest {
  const factory LoadAssetRequest({
    required String fileName,
    required String directoryPath,
  }) = _LoadAssetRequest;
}

@freezed
abstract class LoadLocalFileAsJsonRequest with _$LoadLocalFileAsJsonRequest {
  const factory LoadLocalFileAsJsonRequest({
    required String fileName,
    required String directoryPath,
  }) = _LoadLocalFileAsJsonRequest;
}

@freezed
abstract class DeleteLocalFileRequest with _$DeleteLocalFileRequest {
  const factory DeleteLocalFileRequest({
    required List<DeleteLocalFileItem> items,
  }) = _DeleteLocalFileRequest;
}

@freezed
abstract class DeleteLocalFileItem with _$DeleteLocalFileItem {
  const factory DeleteLocalFileItem({
    required String fileName,
    required String directoryPath,
  }) = _DeleteLocalFileItem;
}

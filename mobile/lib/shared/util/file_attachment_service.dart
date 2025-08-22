import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nestcare/shared/util/toast_util.dart';

/// Enum for different types of file selections
enum FileSelectionType { image, document, any, video, audio }

/// Configuration class for file selection options
class FileSelectionConfig {
  final FileSelectionType type;
  final bool allowMultiple;
  final int? maxFiles;
  final int? maxSizeInMB;
  final List<String>? allowedExtensions;
  final int? imageQuality; // For image compression (1-100)

  const FileSelectionConfig({
    required this.type,
    this.allowMultiple = false,
    this.maxFiles,
    this.maxSizeInMB,
    this.allowedExtensions,
    this.imageQuality,
  });

  /// Predefined configurations for common use cases
  static const FileSelectionConfig singleImage = FileSelectionConfig(
    type: FileSelectionType.image,
    allowMultiple: false,
    maxSizeInMB: 10,
    imageQuality: 70,
  );

  static const FileSelectionConfig multipleImages = FileSelectionConfig(
    type: FileSelectionType.image,
    allowMultiple: true,
    maxFiles: 5,
    maxSizeInMB: 10,
    imageQuality: 70,
  );

  static const FileSelectionConfig documents = FileSelectionConfig(
    type: FileSelectionType.document,
    allowMultiple: false,
    maxSizeInMB: 50,
    allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'rtf'],
  );

  static const FileSelectionConfig anyFile = FileSelectionConfig(
    type: FileSelectionType.any,
    allowMultiple: false,
    maxSizeInMB: 100,
  );
}

/// Result class for file selection operations
class FileSelectionResult {
  final List<File> files;
  final bool success;
  final String? errorMessage;
  final FileSelectionType type;

  const FileSelectionResult({
    required this.files,
    required this.success,
    this.errorMessage,
    required this.type,
  });

  /// Factory constructor for successful results
  factory FileSelectionResult.success({
    required List<File> files,
    required FileSelectionType type,
  }) {
    return FileSelectionResult(files: files, success: true, type: type);
  }

  /// Factory constructor for error results
  factory FileSelectionResult.error({
    required String errorMessage,
    required FileSelectionType type,
  }) {
    return FileSelectionResult(
      files: [],
      success: false,
      errorMessage: errorMessage,
      type: type,
    );
  }
}

/// Main service class for file and attachment operations
class FileAttachmentService {
  static final ImagePicker _imagePicker = ImagePicker();

  /// Select files based on the provided configuration
  static Future<FileSelectionResult> selectFiles({
    required BuildContext context,
    required FileSelectionConfig config,
  }) async {
    try {
      HapticFeedback.lightImpact();

      switch (config.type) {
        case FileSelectionType.image:
          return await _selectImages(context, config);
        case FileSelectionType.document:
          return await _selectDocuments(context, config);
        case FileSelectionType.any:
          return await _selectAnyFiles(context, config);
        case FileSelectionType.video:
          return await _selectVideos(context, config);
        case FileSelectionType.audio:
          return await _selectAudio(context, config);
      }
    } catch (e) {
      return FileSelectionResult.error(
        errorMessage: 'Failed to select files: ${e.toString()}',
        type: config.type,
      );
    }
  }

  /// Select images from gallery or camera
  static Future<FileSelectionResult> _selectImages(
    BuildContext context,
    FileSelectionConfig config,
  ) async {
    try {
      List<XFile> pickedFiles = [];

      if (config.allowMultiple) {
        pickedFiles = await _imagePicker.pickMultiImage(
          imageQuality: config.imageQuality ?? 70,
        );
      } else {
        // Show source selection dialog for single image
        final source = await _showImageSourceDialog(context);
        if (source == null) {
          return FileSelectionResult.error(
            errorMessage: 'No source selected',
            type: config.type,
          );
        }

        final pickedFile = await _imagePicker.pickImage(
          source: source,
          imageQuality: config.imageQuality ?? 70,
        );
        if (pickedFile != null) {
          pickedFiles = [pickedFile];
        }
      }

      if (pickedFiles.isEmpty) {
        return FileSelectionResult.error(
          errorMessage: 'No images selected',
          type: config.type,
        );
      }

      // Validate file count
      if (config.maxFiles != null && pickedFiles.length > config.maxFiles!) {
        return FileSelectionResult.error(
          errorMessage: 'Maximum ${config.maxFiles} files allowed',
          type: config.type,
        );
      }

      // Convert to File objects and validate
      final files = pickedFiles.map((xFile) => File(xFile.path)).toList();
      final validationResult = await _validateFiles(files, config);

      if (!validationResult.success) {
        return validationResult;
      }

      HapticFeedback.mediumImpact();
      return FileSelectionResult.success(files: files, type: config.type);
    } catch (e) {
      return FileSelectionResult.error(
        errorMessage: 'Error selecting images: ${e.toString()}',
        type: config.type,
      );
    }
  }

  /// Select documents using file picker
  static Future<FileSelectionResult> _selectDocuments(
    BuildContext context,
    FileSelectionConfig config,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: config.allowedExtensions,
        allowMultiple: config.allowMultiple,
      );

      if (result == null || result.files.isEmpty) {
        return FileSelectionResult.error(
          errorMessage: 'No documents selected',
          type: config.type,
        );
      }

      // Validate file count
      if (config.maxFiles != null && result.files.length > config.maxFiles!) {
        return FileSelectionResult.error(
          errorMessage: 'Maximum ${config.maxFiles} files allowed',
          type: config.type,
        );
      }

      // Convert to File objects
      final files =
          result.files
              .where((file) => file.path != null)
              .map((file) => File(file.path!))
              .toList();

      // Validate files
      final validationResult = await _validateFiles(files, config);
      if (!validationResult.success) {
        return validationResult;
      }

      HapticFeedback.mediumImpact();
      return FileSelectionResult.success(files: files, type: config.type);
    } catch (e) {
      return FileSelectionResult.error(
        errorMessage: 'Error selecting documents: ${e.toString()}',
        type: config.type,
      );
    }
  }

  /// Select any type of files
  static Future<FileSelectionResult> _selectAnyFiles(
    BuildContext context,
    FileSelectionConfig config,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: config.allowMultiple,
      );

      if (result == null || result.files.isEmpty) {
        return FileSelectionResult.error(
          errorMessage: 'No files selected',
          type: config.type,
        );
      }

      // Validate file count
      if (config.maxFiles != null && result.files.length > config.maxFiles!) {
        return FileSelectionResult.error(
          errorMessage: 'Maximum ${config.maxFiles} files allowed',
          type: config.type,
        );
      }

      // Convert to File objects
      final files =
          result.files
              .where((file) => file.path != null)
              .map((file) => File(file.path!))
              .toList();

      // Validate files
      final validationResult = await _validateFiles(files, config);
      if (!validationResult.success) {
        return validationResult;
      }

      HapticFeedback.mediumImpact();
      return FileSelectionResult.success(files: files, type: config.type);
    } catch (e) {
      return FileSelectionResult.error(
        errorMessage: 'Error selecting files: ${e.toString()}',
        type: config.type,
      );
    }
  }

  /// Select video files
  static Future<FileSelectionResult> _selectVideos(
    BuildContext context,
    FileSelectionConfig config,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: config.allowMultiple,
      );

      if (result == null || result.files.isEmpty) {
        return FileSelectionResult.error(
          errorMessage: 'No videos selected',
          type: config.type,
        );
      }

      // Convert to File objects and validate
      final files =
          result.files
              .where((file) => file.path != null)
              .map((file) => File(file.path!))
              .toList();

      final validationResult = await _validateFiles(files, config);
      if (!validationResult.success) {
        return validationResult;
      }

      return FileSelectionResult.success(files: files, type: config.type);
    } catch (e) {
      return FileSelectionResult.error(
        errorMessage: 'Error selecting videos: ${e.toString()}',
        type: config.type,
      );
    }
  }

  /// Select audio files
  static Future<FileSelectionResult> _selectAudio(
    BuildContext context,
    FileSelectionConfig config,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: config.allowMultiple,
      );

      if (result == null || result.files.isEmpty) {
        return FileSelectionResult.error(
          errorMessage: 'No audio files selected',
          type: config.type,
        );
      }

      // Convert to File objects and validate
      final files =
          result.files
              .where((file) => file.path != null)
              .map((file) => File(file.path!))
              .toList();

      final validationResult = await _validateFiles(files, config);
      if (!validationResult.success) {
        return validationResult;
      }

      return FileSelectionResult.success(files: files, type: config.type);
    } catch (e) {
      return FileSelectionResult.error(
        errorMessage: 'Error selecting audio files: ${e.toString()}',
        type: config.type,
      );
    }
  }

  /// Show dialog to select image source (camera or gallery)
  static Future<ImageSource?> _showImageSourceDialog(
    BuildContext context,
  ) async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Validate selected files against configuration constraints
  static Future<FileSelectionResult> _validateFiles(
    List<File> files,
    FileSelectionConfig config,
  ) async {
    try {
      for (final file in files) {
        // Check if file exists
        if (!await file.exists()) {
          return FileSelectionResult.error(
            errorMessage: 'Selected file does not exist',
            type: config.type,
          );
        }

        // Check file size
        if (config.maxSizeInMB != null) {
          final fileSizeInMB = await file.length() / (1024 * 1024);
          if (fileSizeInMB > config.maxSizeInMB!) {
            return FileSelectionResult.error(
              errorMessage: 'File size exceeds ${config.maxSizeInMB}MB limit',
              type: config.type,
            );
          }
        }

        // Check file extension for documents
        if (config.allowedExtensions != null) {
          final extension = file.path.split('.').last.toLowerCase();
          if (!config.allowedExtensions!.contains(extension)) {
            return FileSelectionResult.error(
              errorMessage:
                  'File type not allowed. Allowed: ${config.allowedExtensions!.join(', ')}',
              type: config.type,
            );
          }
        }
      }

      return FileSelectionResult.success(files: files, type: config.type);
    } catch (e) {
      return FileSelectionResult.error(
        errorMessage: 'Error validating files: ${e.toString()}',
        type: config.type,
      );
    }
  }

  /// Utility method to format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Get file extension from file path
  static String getFileExtension(String filePath) {
    return filePath.split('.').last.toLowerCase();
  }

  /// Check if file is an image based on extension
  static bool isImageFile(String filePath) {
    final extension = getFileExtension(filePath);
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  /// Check if file is a document based on extension
  static bool isDocumentFile(String filePath) {
    final extension = getFileExtension(filePath);
    return [
      'pdf',
      'doc',
      'docx',
      'txt',
      'rtf',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
    ].contains(extension);
  }

  /// Handle file selection result and show appropriate feedback
  static void handleFileSelectionResult(
    BuildContext context,
    FileSelectionResult result, {
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) {
    if (result.success) {
      onSuccess?.call();
    } else {
      ToastUtil.showErrorToast(context, result.errorMessage ?? 'Unknown error');
      onError?.call();
    }
  }
}

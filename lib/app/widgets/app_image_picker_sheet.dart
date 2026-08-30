// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../theme/app_text_styles.dart';
import '../utils/extensions/context_extensions.dart';

class AppImagePickerSheet extends StatelessWidget {
  final CropStyle cropStyle;
  final bool isMultiSelect;
  final bool isEnableCrop;

  const AppImagePickerSheet({
    super.key,
    this.cropStyle = CropStyle.circle,
    this.isMultiSelect = false,
    this.isEnableCrop = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: context.bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4.h,
            width: 60.w,
            margin: EdgeInsets.only(top: 8.h, bottom: 24.h),
            decoration: BoxDecoration(
              color: context.customColors.border.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Text(
                    context.translate("choose_photo"),
                    style: AppTextStyles.bodyMedium(
                      context,
                      color: context.customColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                _buildOption(
                  context,
                  title: context.translate("gallery"),
                  icon: "assets/icons/gallery.svg",
                  onTap: () => _pickImage(ImageSource.gallery, context),
                ),
                SizedBox(height: 8.h),
                _buildOption(
                  context,
                  title: context.translate("camera"),
                  icon: "assets/icons/camera.svg",
                  onTap: () => _pickImage(ImageSource.camera, context),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required String icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: context.colors.surface,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: context.customColors.textPrimary,
                ),
              ),
            ),
            SvgPicture.asset(
              icon,
              colorFilter: ColorFilter.mode(
                context.colors.primary,
                BlendMode.srcIn,
              ),
              height: 25.h,
              width: 25.w,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final picker = ImagePicker();

      if (source == ImageSource.gallery && isMultiSelect) {
        final List<XFile> pickedImages = await picker.pickMultiImage(
          imageQuality: 70,
          maxWidth: 1080,
          maxHeight: 1080,
        );

        if (pickedImages.isNotEmpty) {
          final List<String> paths = [];
          for (final img in pickedImages) {
            final file = File(img.path);
            paths.add(await _processFile(file));
          }
          Navigator.pop(context, paths);
        } else {
          Navigator.pop(context);
        }
        return;
      }

      final XFile? picked = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (picked != null) {
        final file = File(picked.path);
        if (isEnableCrop) {
          _cropImage(file, context);
        } else {
          final processedPath = await _processFile(file);
          Navigator.pop(context, processedPath);
        }
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future<String> _processFile(File file, {int maxSizeMB = 10}) async {
    if (file.lengthSync() / (1024 * 1024) > maxSizeMB) {
      final dir = await getTemporaryDirectory();
      final targetPath = join(
        dir.path,
        "${DateTime.now().microsecondsSinceEpoch}.jpg",
      );

      final compressed = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: 90,
        minWidth: 1080,
        minHeight: 1080,
      );

      return compressed?.path ?? file.path;
    }
    return file.path;
  }

  void _cropImage(File file, BuildContext context) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: context.translate("cropper"),
          toolbarColor: context.colors.primary,
          toolbarWidgetColor: context.colors.onPrimary,
          lockAspectRatio: true,
          aspectRatioPresets: const [CropAspectRatioPreset.square],
          cropStyle: cropStyle,
        ),
        IOSUiSettings(
          title: context.translate("cropper"),
          aspectRatioPresets: const [CropAspectRatioPreset.square],
          cropStyle: cropStyle,
        ),
      ],
    );

    if (cropped != null) {
      final processedPath = await _processFile(File(cropped.path));
      Navigator.pop(context, processedPath);
    }
  }
}

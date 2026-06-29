import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../design_system/tokens/app_colors.dart';

/// Shows a bottom sheet letting the user pick an avatar source (camera or
/// gallery), then runs the picker. Centralizes this UX so every "edit
/// avatar" entry point doesn't duplicate the sheet.
Future<XFile?> pickAvatarSource(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined, color: AppColors.parentPrimary),
            title: const Text('Camera'),
            onTap: () => Navigator.of(context).pop(ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_outlined, color: AppColors.parentPrimary),
            title: const Text('Gallery'),
            onTap: () => Navigator.of(context).pop(ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
  if (source == null) return null;
  return ImagePicker().pickImage(source: source, maxWidth: 800, imageQuality: 85);
}

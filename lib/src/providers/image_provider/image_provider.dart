import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_note/src/core/error/custom_exceptions.dart';
import 'package:smart_note/src/providers/image_to_text_provider/image_to_text_provider.dart';

//image index 0
// final scanImageProvider = StateProvider<XFile?>((ref) => null as XFile?);

//image index 1
final attachedImageProvider = StateProvider<List<XFile>>((ref) => []);

class ImagePickerProvider {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage({
    required int source,
    required int imageIndex,
    bool? isMultiImage = false,
    required WidgetRef ref,
    int? limit,
  }) async {
    try {
      if (isMultiImage == true) {
        final List<XFile> images =
            await _imagePicker.pickMultiImage(limit: limit);

        if (images.isNotEmpty && imageIndex == 1) {
          ref.read(attachedImageProvider.notifier).update((state) => images);
        }
      } else {
        final XFile? image = await _imagePicker.pickImage(
          source: source == 1 ? ImageSource.gallery : ImageSource.camera,
        );
        if (image != null) {
          imageIndex == 1
              ? ref
                  .read(attachedImageProvider.notifier)
                  .update((state) => List.from(state)..add(image))
              : ref
                  .read(imageToTextProvider.notifier)
                  .extractText(imagePath: image.path);
        }
      }
    } catch (e) {
      throw CustomExceptions(message: e.toString());
    }
  }

  void resetImage(WidgetRef ref) {
    // ref.read(scanImageProvider.notifier).state = null;
    ref.read(attachedImageProvider.notifier).state = [];
  }

  void removeImage(int index, WidgetRef ref) {
    ref.read(attachedImageProvider.notifier).update(
      (state) {
        final List<XFile> newState = List.from(state);
        newState.removeAt(index);
        return newState;
      },
    );
  }
}

final imagePickerProvider = Provider((ref) {
  return ImagePickerProvider();
});

import 'package:smart_note/src/core/app/medias.dart';

class NoteOptionsModel {
  final String title;
  final String icon;

  NoteOptionsModel({required this.title, required this.icon});
}

List<NoteOptionsModel> noteOptions = [
  NoteOptionsModel(title: "Voice", icon: kMicSvg),
  NoteOptionsModel(title: "Scan", icon: kGallerySvg),
  NoteOptionsModel(title: "Attach", icon: kAttachSvg),
];

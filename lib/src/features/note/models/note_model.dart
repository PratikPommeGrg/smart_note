class NoteModel {
  final int? id;
  final String title;
  final String note;
  final String category;
  final List<String>? attachedImages;

  const NoteModel({
    this.id,
    required this.title,
    required this.note,
    required this.category,
    this.attachedImages,
  });

  NoteModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        note = map['note'],
        category = map['category'],
        attachedImages = map['attachedImages'] != null
            ? List.from(map['attachedImages'].split('--,--'))
            : null;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'note': note,
      'category': category,
    };

    if (attachedImages != null) {
      map['attachedImages'] = attachedImages!.join('--,--');
    }

    return map;
  }

  @override
  String toString() {
    return 'NoteModel{id: $id, title: $title, note: $note, category: $category, attachedImages: $attachedImages}';
  }
}

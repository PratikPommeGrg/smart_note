class NoteModel {
  final int? id;
  final String title;
  final String note;
  final String category;
  final List<String>? images;

  const NoteModel({
    this.id,
    required this.title,
    required this.note,
    required this.category,
    this.images,
  });

  NoteModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        note = map['note'],
        category = map['category'],
        images = map['images'] != null
            ? List.from(map['images'].split('--,--'))
            : null;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'note': note,
      'category': category,
    };

    if (images != null) {
      map['images'] = images!.join('--,--');
    }

    return map;
  }

  @override
  String toString() {
    return 'NoteModel{id: $id, title: $title, note: $note, category: $category, images: $images}';
  }
}

class NoteModel {
  final int? id;
  final String title;
  final String note;
  final String category;
  final List<String>? images;
  final double? cardSize;

  const NoteModel({
    this.id,
    required this.title,
    required this.note,
    required this.category,
    this.images,
    this.cardSize,
  });

  NoteModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        note = map['note'],
        category = map['category'],
        images = map['images'] != null
            ? List.from(map['images'].split('--,--'))
            : null,
        cardSize = map['cardSize'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'title': title,
      'note': note,
      'category': category,
      'cardSize': cardSize
    };

    if (images != null) {
      map['images'] = images!.join('--,--');
    }

    return map;
  }

  @override
  String toString() {
    return 'NoteModel{id: $id, title: $title, note: $note, category: $category, images: $images}, cardSize: $cardSize';
  }
}

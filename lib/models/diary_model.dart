class Diary {
  final int id;
  final DateTime date;
  final List<String> tags;
  bool favorite;

  Diary({
    required this.id,
    required this.date,
    required this.tags,
    this.favorite = false,
  });

  String get assetName => 'sorry.png';
}

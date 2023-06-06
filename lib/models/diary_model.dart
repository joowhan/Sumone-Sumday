class Diary {
  const Diary({
    required this.id,
    required this.date,
    required this.tags,
    required this.favorite,
  });

  final int id;
  final DateTime date;
  final List<String> tags;
  final bool favorite;

  String get assetName => 'sorry.png';
}

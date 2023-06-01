class Diary {
  const Diary({
    required this.id,
    required this.date,
    required this.tags,
  });

  final int id;
  final DateTime date;
  final List<String> tags;

  String get assetName => 'sorry.png';
}

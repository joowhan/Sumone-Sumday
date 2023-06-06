import 'diary_model.dart';

// test data set

class DiariesRepository {
  static List<Diary> loadDiaries() {
    var allDiaries = <Diary>[
      Diary(
        id: 0,
        date: DateTime.now(),
        tags: ['Vagabond', 'sack', 'new'],
        favorite: false,
      ),
      Diary(
        id: 1,
        date: DateTime.now(),
        tags: ['Stella', 'sunglasses', 'new'],
        favorite: true,
      ),
      Diary(
        id: 2,
        date: DateTime.now(),
        tags: ['Whitney', 'belt', 'new'],
        favorite: false,
      ),
      Diary(
        id: 3,
        date: DateTime.now(),
        tags: ['Garden', 'strand', 'new'],
        favorite: false,
      ),
      Diary(
        id: 4,
        date: DateTime.now(),
        tags: ['Strut', 'earrings', 'new'],
        favorite: false,
      ),
      Diary(
        id: 5,
        date: DateTime.now(),
        tags: ['Varsity', 'socks', 'new'],
        favorite: true,
      ),
      Diary(
        id: 6,
        date: DateTime.now(),
        tags: ['Weave', 'keyring', 'new'],
        favorite: false,
      ),
      Diary(
        id: 7,
        date: DateTime.now(),
        tags: ['Gatsby', 'hat', 'new'],
        favorite: true,
      ),
      Diary(
        id: 8,
        date: DateTime.now(),
        tags: ['Shrug', 'bag', 'new'],
        favorite: false,
      ),
      Diary(
        id: 9,
        date: DateTime.now(),
        tags: ['Gilt', 'desk trio', 'new'],
        favorite: false,
      ),
      Diary(
        id: 10,
        date: DateTime.now(),
        tags: ['Copper', 'wire rack', 'new'],
        favorite: false,
      ),
      Diary(
        id: 11,
        date: DateTime.now(),
        tags: ['Soothe', 'ceramic set', 'new'],
        favorite: false,
      ),
      Diary(
        id: 12,
        date: DateTime.now(),
        tags: ['Hurrahs', 'tea set', 'new'],
        favorite: false,
      ),
      Diary(
        id: 13,
        date: DateTime.now(),
        tags: ['Blue', 'stone mug', 'new'],
        favorite: false,
      ),
      Diary(
        id: 14,
        date: DateTime.now(),
        tags: ['Rainwater', 'tray', 'new'],
        favorite: false,
      ),
      Diary(
        id: 15,
        date: DateTime.now(),
        tags: ['Chambray', 'napkins', 'new'],
        favorite: true,
      ),
      Diary(
        id: 16,
        date: DateTime.now(),
        tags: ['Succulent', 'planters', 'new'],
        favorite: true,
      ),
      Diary(
        id: 17,
        date: DateTime.now(),
        tags: ['Quartet', 'table', 'new'],
        favorite: false,
      ),
      Diary(
        id: 18,
        date: DateTime.now(),
        tags: ['Kitchen', 'quattro', 'new'],
        favorite: false,
      ),
      Diary(
        id: 19,
        date: DateTime.now(),
        tags: ['Clay', 'sweater', 'new'],
        favorite: false,
      ),
      Diary(
        id: 20,
        date: DateTime.now(),
        tags: ['Sea', 'tunic', 'new'],
        favorite: false,
      ),
      Diary(
        id: 21,
        date: DateTime.now(),
        tags: ['Plaster', 'tunic', 'new'],
        favorite: true,
      ),
      Diary(
        id: 22,
        date: DateTime.now(),
        tags: ['White', 'pinstripe shirt', 'new'],
        favorite: false,
      ),
      Diary(
        id: 23,
        date: DateTime.now(),
        tags: ['Chambray', 'shirt', 'new'],
        favorite: false,
      ),
      Diary(
        id: 24,
        date: DateTime.now(),
        tags: ['Seabreeze', 'sweater', 'new'],
        favorite: false,
      ),
      Diary(
        id: 25,
        date: DateTime.now(),
        tags: ['Gentry', 'jacket', 'new'],
        favorite: false,
      ),
      Diary(
        id: 26,
        date: DateTime.now(),
        tags: ['Navy', 'trousers', 'new'],
        favorite: false,
      ),
      Diary(
        id: 27,
        date: DateTime.now(),
        tags: ['Walter', 'henley (white)', 'new'],
        favorite: true,
      ),
      Diary(
        id: 28,
        date: DateTime.now(),
        tags: ['Surf', 'and perf shirt', 'new'],
        favorite: false,
      ),
      Diary(
        id: 29,
        date: DateTime.now(),
        tags: ['Ginger', 'scarf', 'new'],
        favorite: false,
      ),
      Diary(
        id: 30,
        date: DateTime.now(),
        tags: ['Ramona', 'crossover', 'new'],
        favorite: false,
      ),
      Diary(
        id: 31,
        date: DateTime.now(),
        tags: ['Chambray', 'shirt', 'new'],
        favorite: false,
      ),
      Diary(
        id: 32,
        date: DateTime.now(),
        tags: ['Classic', 'white collar', 'new'],
        favorite: false,
      ),
      Diary(
        id: 33,
        date: DateTime.now(),
        tags: ['Cerise', 'scallop tee', 'new'],
        favorite: false,
      ),
      Diary(
        id: 34,
        date: DateTime.now(),
        tags: ['Shoulder', 'rolls tee', 'new'],
        favorite: false,
      ),
      Diary(
        id: 35,
        date: DateTime.now(),
        tags: ['Grey', 'slouch tank', 'new'],
        favorite: false,
      ),
      Diary(
        id: 36,
        date: DateTime.now(),
        tags: ['Sunshirt', 'dress', 'new'],
        favorite: false,
      ),
      Diary(
        id: 37,
        date: DateTime.now(),
        tags: ['Fine', 'lines tee', 'new'],
        favorite: false,
      ),
    ];

    return allDiaries.toList();
  }
}

import 'package:hive/hive.dart';
part 'musica_db.g.dart';

@HiveType(typeId: 1)
class MusicaModel extends HiveObject {
  MusicaModel({required this.name, required this.songId});

  @HiveField(0)
  String name;

  @HiveField(1)
  List<int> songId;

  add(int id) async {
    songId.add(id);
    save();
    print(songId.length);
  }

  deleteData(int id) {
    songId.remove(id);
    save();
  }

  bool isValueIn(int id) {
    return songId.contains(id);
  }
}

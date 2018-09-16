abstract class IMappable {
  String tableName;
  String idColumnName;
  int id;
  IMappable.fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toMap();
}

import 'package:golfstroke/database/dbutils.dart';
import 'package:golfstroke/model/IMappable.dart';

class Setting<T> implements IMappable {
  String tableName = tableSetting;
  String idColumnName = columnSettingId;
  int id;
  String name;
  T _value;
  T get value => _value;
  set value(T newValue) {
    this._value = newValue;
    appDb.save(this);
  }

  Setting(this.name, this._value);

  Setting.fromMap(Map<String, dynamic> map) {
    id = map[idColumnName];
    name = map[columnSettingName];
    _value = _tryParse(map[columnSettingValue]);
  }

  Map<String, dynamic> toMap() => {
        columnSettingId: id,
        columnSettingName: name,
        columnSettingValue: _value,
      };
}

T _tryParse<T>(String data) => (T is int) ? int.tryParse(data) as T : data as T;

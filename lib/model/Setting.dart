import 'package:golfstroke/database/DbUtils.dart';
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
    _value = _tryParse<T>(map[columnSettingValue]);
  }

  Map<String, dynamic> toMap() => {
        columnSettingId: id,
        columnSettingName: name,
        columnSettingValue: _value,
      };
}

T _tryParse<T>(String data) => _parseFuncs[T](data);

Map<Type, Function> _parseFuncs = <Type, Function>{
  int: ((String x) => int.tryParse(x)),
  double: ((String x) => double.tryParse(x)),
  String: ((String x) => x),
};

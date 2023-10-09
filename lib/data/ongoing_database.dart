import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

class TaskDataBaseOngoing {
  List ongoing = [];

  final _myBoxOngoing = Hive.box('myBoxOngoing');

  void createInitialDataOngoing() {
    ongoing = [
      ['Default Task', 'Default Content', '10:00 AM', false]
    ];
  }

  void loadDataOngoing() {
    ongoing = _myBoxOngoing.get('ONGOING');
  }

  void updateDataBaseOngoing() {
    _myBoxOngoing.put('ONGOING', ongoing);
  }
}

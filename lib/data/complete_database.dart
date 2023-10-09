import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';

class TaskDataBaseComplete {
  List complete = [];

  final _myBoxComplete = Hive.box('myBoxComplete');

  void createInitialDataComplete() {
    complete = [
      ['Default Task', 'Default Content', '10:00 AM', true]
    ];
  }

  void loadDataComplete() {
    complete = _myBoxComplete.get('COMPLETE');
  }

  void updateDataBaseComplete() {
    _myBoxComplete.put('COMPLETE', complete);
  }
}

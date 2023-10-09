import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_task/data/complete_database.dart';
import 'package:todo_task/data/ongoing_database.dart';
import 'package:todo_task/utils/task_tile.dart';

import '../utils/dialog_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // refrence the hive box;
  final _myBoxOngoing = Hive.box('myBoxOngoing');
  TaskDataBaseOngoing dbo = TaskDataBaseOngoing();

  final _myBoxComplete = Hive.box('myBoxComplete');
  TaskDataBaseComplete dbc = TaskDataBaseComplete();

  @override
  void initState() {
    if (_myBoxOngoing.get('ONGOING') == null) {
      dbo.createInitialDataOngoing();
    } else {
      dbo.loadDataOngoing();
    }
    if (_myBoxComplete.get('COMPLETE') == null) {
      dbc.createInitialDataComplete();
    } else {
      dbc.loadDataComplete();
    }
    super.initState();
  }

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController();

  void checkBoxChangedOngoing(bool? value, int index) {
    setState(() {
      dbo.ongoing[index][3] = !dbo.ongoing[index][3];
      if (dbo.ongoing[index][3] == true) {
        dbc.complete.add([
          dbo.ongoing[index][0],
          dbo.ongoing[index][1],
          dbo.ongoing[index][2],
          true,
        ]);
        dbo.ongoing.removeAt(index);
      }
    });
    dbo.updateDataBaseOngoing();
    dbc.updateDataBaseComplete();
  }

  void checkBoxChangedComplete(bool? value, int index) {
    setState(() {
      dbc.complete[index][3] = !dbc.complete[index][3];
      if (dbc.complete[index][3] == false) {
        dbo.ongoing.add([
          dbc.complete[index][0],
          dbc.complete[index][1],
          dbc.complete[index][2],
          false,
        ]);
        dbc.complete.removeAt(index);
      }
    });
    dbc.updateDataBaseComplete();
    dbo.updateDataBaseOngoing();
  }

  // cancel new task
  void cancelNewTask() {
    _titleController.clear();
    _contentController.clear();
    _dateController.clear();

    Navigator.of(context).pop();
  }

  // save new task
  void saveNewTask() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plese fill all required values!!')));
    } else {
      setState(() {
        dbo.ongoing.add([
          _titleController.text,
          _contentController.text,
          _dateController.text,
          false,
        ]);
      });
      _titleController.clear();
      _contentController.clear();
      _dateController.clear();
      Navigator.of(context).pop();
      dbo.updateDataBaseOngoing();
    }
  }

  // create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          titleController: _titleController,
          contentController: _contentController,
          dateController: _dateController,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void taskUpdate(int index) {
    _titleController.text = dbo.ongoing[index][0];
    _contentController.text = dbo.ongoing[index][1];
    _dateController.text = dbo.ongoing[index][2];
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          titleController: _titleController,
          contentController: _contentController,
          dateController: _dateController,
          onSave: () => saveExistingTask(index),
          onCancel: () => cancelNewTask(),
        );
      },
    );
  }

  void saveExistingTask(int index) {
    setState(() {
      dbo.ongoing[index][0] = _titleController.text;
      dbo.ongoing[index][1] = _contentController.text;
      dbo.ongoing[index][2] = _dateController.text;
    });
    _titleController.clear();
    _contentController.clear();
    _dateController.clear();
    Navigator.pop(context);
    dbo.updateDataBaseOngoing();
  }

  // delete task
  void deleteTaskOngoing(int index) {
    setState(() {
      dbo.ongoing.removeAt(index);
    });
    dbo.updateDataBaseOngoing();
  }

  void deleteTaskComplete(int index) {
    setState(() {
      dbc.complete.removeAt(index);
    });
    dbc.updateDataBaseComplete();
  }

  @override
  Widget build(BuildContext context) {
    int cnto = dbo.ongoing.length;
    int cntc = dbc.complete.length;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.menu,
          color: Colors.grey.shade600,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.notifications,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hello, Champ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                // Text(
                //   '$count total task ',
                //   style: TextStyle(
                //     color: Colors.red.shade200,
                //     fontSize: 14,
                //   ),
                // ),
                Text(
                  '$cnto task pending',
                  style: TextStyle(
                    color: Colors.green.shade200,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            bottom: const TabBar(
              indicatorColor: Colors.orange,
              labelColor: Colors.amber,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(
                  text: 'Ongoing Task',
                ),
                Tab(
                  text: 'Completed Task',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Content of Tab 1
              Center(
                child: (cnto > 0)
                    ? ListView.builder(
                        itemCount: dbo.ongoing.length,
                        itemBuilder: (context, index) {
                          return TaskTile(
                              taskTitle: dbo.ongoing[index][0],
                              taskContent: dbo.ongoing[index][1],
                              taskTime: dbo.ongoing[index][2],
                              taskCompleted: dbo.ongoing[index][3],
                              onChanged: (value) =>
                                  checkBoxChangedOngoing(value, index),
                              deleteTask: (context) => deleteTaskOngoing(index),
                              updateTask: (context) => taskUpdate(index));
                        })
                    : const Center(
                        child: Text("No Task Yet"),
                      ),
              ),

              // Content of Tab 2
              Center(
                child: (cntc > 0)
                    ? ListView.builder(
                        itemCount: dbc.complete.length,
                        itemBuilder: (context, index) {
                          return TaskTile(
                            taskTitle: dbc.complete[index][0],
                            taskContent: dbc.complete[index][1],
                            taskTime: dbc.complete[index][2],
                            taskCompleted: dbc.complete[index][3],
                            onChanged: (value) =>
                                checkBoxChangedComplete(value, index),
                            deleteTask: (context) => deleteTaskComplete(index),
                            updateTask: (context) => taskUpdate(index),
                          );
                        })
                    : const Center(
                        child: Text("No Task Yet"),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          createNewTask();
        },
        backgroundColor: Colors.amber.shade900,
        label: const Text('Add New Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

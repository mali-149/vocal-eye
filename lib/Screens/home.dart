import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/alarm_service.dart';

class home extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<home> {
  List<Map<String, dynamic>> alarms = [];

  @override
  void initState() {
    super.initState();
    loadAlarms();
  }

  Future<void> loadAlarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final alarmList = prefs.getStringList('alarms') ?? [];

    setState(() {
      alarms = alarmList
          .map((e) => json.decode(e) as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> saveAlarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final alarmList = alarms.map((e) => json.encode(e)).toList();
    await prefs.setStringList('alarms', alarmList);
  }

  Future<void> _pickTime({int? editIndex}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: editIndex != null
          ? TimeOfDay(
        hour: alarms[editIndex]['hour'],
        minute: alarms[editIndex]['minute'],
      )
          : TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      DateTime alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      if (alarmTime.isBefore(now)) {
        alarmTime = alarmTime.add(Duration(days: 1));
      }

      final int id = alarmTime.millisecondsSinceEpoch.remainder(100000);

      if (editIndex != null) {
        // Cancel previous alarm
        await AndroidAlarmManager.cancel(alarms[editIndex]['id']);

        alarms[editIndex] = {
          'hour': picked.hour,
          'minute': picked.minute,
          'enabled': true,
          'id': id,
        };
      } else {
        alarms.add({
          'hour': picked.hour,
          'minute': picked.minute,
          'enabled': true,
          'id': id,
        });
      }

      await AndroidAlarmManager.oneShotAt(
        alarmTime,
        id,
        AlarmService.triggerAlarm,
        exact: true,
        wakeup: true,
      );

      await saveAlarms();
      setState(() {});
    }
  }

  void _toggleAlarm(int index) async {
    setState(() {
      alarms[index]['enabled'] = !alarms[index]['enabled'];
    });

    final alarm = alarms[index];
    final id = alarm['id'];
    final time = TimeOfDay(hour: alarm['hour'], minute: alarm['minute']);
    final now = DateTime.now();
    DateTime alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(Duration(days: 1));
    }

    if (alarm['enabled']) {
      await AndroidAlarmManager.oneShotAt(
        alarmTime,
        id,
        AlarmService.triggerAlarm,
        exact: true,
        wakeup: true,
      );
    } else {
      await AndroidAlarmManager.cancel(id);
    }

    await saveAlarms();
  }

  void _deleteAlarm(int index) async {
    final id = alarms[index]['id'];
    await AndroidAlarmManager.cancel(id);

    setState(() {
      alarms.removeAt(index);
    });

    await saveAlarms();
  }

  String _getNextAlarmTime() {
    final now = DateTime.now();
    final enabledAlarms = alarms.where((a) => a['enabled']).map((alarm) {
      DateTime time = DateTime(
        now.year,
        now.month,
        now.day,
        alarm['hour'],
        alarm['minute'],
      );
      if (time.isBefore(now)) time = time.add(Duration(days: 1));
      return time;
    }).toList();

    if (enabledAlarms.isEmpty) return "No alarm set";

    enabledAlarms.sort();
    final nextAlarm = enabledAlarms.first;
    final difference = nextAlarm.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return "Alarm in $hours hour${hours != 1 ? 's' : ''} ${minutes.toString().padLeft(2, '0')} minute${minutes != 1 ? 's' : ''}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alarm')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getNextAlarmTime(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (_, index) {
                  final alarm = alarms[index];
                  final time = TimeOfDay(
                    hour: alarm['hour'],
                    minute: alarm['minute'],
                  );
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text(
                        time.format(context),
                        style: TextStyle(fontSize: 24),
                      ),
                      subtitle: Text("Once"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _pickTime(editIndex: index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteAlarm(index),
                          ),
                          Switch(
                            value: alarm['enabled'],
                            onChanged: (_) => _toggleAlarm(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickTime,
        child: Icon(Icons.add),
      ),
    );
  }
}

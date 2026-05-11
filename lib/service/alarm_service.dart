import 'package:shared_preferences/shared_preferences.dart';
import 'dart:isolate';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AlarmService {
  static Future<void> triggerAlarm() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmList = prefs.getStringList('alarms') ?? [];

    if (alarmList.isNotEmpty) {
      final alarm = alarmList.last; // Simplified: play last alarm tone
      final tonePath = alarm.contains('tone') ? alarm.split('"tone":"')[1].split('"')[0] : null;

      final player = AudioPlayer();
      if (tonePath != null) {
        await player.play(DeviceFileSource(tonePath));
      } else {
        // Fallback to ringtone
        // FlutterRingtonePlayer.playAlarm(asAlarm: true, looping: true);
      }
    }
  }
}

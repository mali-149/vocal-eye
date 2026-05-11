import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:analog_clock/analog_clock.dart';
import 'dart:async';

class clock extends StatefulWidget {
  @override
  _ClockScreenState createState() => _ClockScreenState();
}

class _ClockScreenState extends State<clock> {
  late Timer _timer;
  late DateTime _pakistanTime;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final nowUtc = DateTime.now().toUtc();
    final offset = Duration(hours: 5); // Pakistan Time UTC+5
    setState(() {
      _pakistanTime = nowUtc.add(offset);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final digitalTime = DateFormat('HH:mm:ss').format(_pakistanTime);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("World Clock", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.add, color: Colors.black)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.black)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40),

          // Analog clock
          Center(
            child: Container(
              width: 200,
              height: 200,
              child: AnalogClock(
                datetime: _pakistanTime,
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                showNumbers: true,
                showTicks: true,
                isLive: false,
                hourHandColor: Colors.white,
                minuteHandColor: Colors.white,
                secondHandColor: Colors.blue,
                numberColor: Colors.white,
                textScaleFactor: 1.3,
              ),
            ),
          ),

          SizedBox(height: 20),

          // Digital Time
          Text(
            digitalTime,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          SizedBox(height: 8),
          Text(
            "Local time ${DateFormat('MM/dd/yy').format(_pakistanTime)}",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          SizedBox(height: 40),

          // Location Card (like Abidjan box in screenshot)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Karachi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("${DateFormat('dd MMM').format(_pakistanTime)} | +5 hrs", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Spacer(),
                  Text(
                    DateFormat('hh:mm').format(_pakistanTime),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0),
                    child: Text(
                      DateFormat('a').format(_pakistanTime).toLowerCase(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

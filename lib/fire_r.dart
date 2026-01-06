
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'package:ec/home.dart';


class FireAlarm extends StatefulWidget {
  const FireAlarm({super.key});

  @override
  State<FireAlarm> createState() => _FireAlarmState();
}

class _FireAlarmState extends State<FireAlarm> {
  int smokeValue = 0;
  bool isSmokeDetected = false;
  bool manualAlarm = false;

  @override
  void initState() {
    super.initState();
    _listenToSmokeSensor();
  }

  void _listenToSmokeSensor() {
    final ref = FirebaseDatabase.instance.ref("smoke/value");
    ref.onValue.listen((event) {
      final value = event.snapshot.value;
      if (value != null) {
        setState(() {
          smokeValue = int.tryParse(value.toString()) ?? 0;
          isSmokeDetected = smokeValue > 2000; // الحد اللي تحدده أنت
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final alarmActive = isSmokeDetected || manualAlarm;

    return Scaffold(
      appBar: AppBar(
        title: const Text("نظام إنذار الحريق"),
        backgroundColor: alarmActive ? Colors.red : Colors.purpleAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              alarmActive ? Icons.warning : Icons.check_circle,
              color: alarmActive ? Colors.red : Colors.purpleAccent,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              "قيمة الحساس: $smokeValue",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 10),
            Text(
              alarmActive
                  ? "🚨 دخان مكتشف! يجب اتخاذ إجراء"
                  : "✅ لا يوجد دخان. الوضع آمن",
              style: TextStyle(
                fontSize: 20,
                color: alarmActive ? Colors.red : Colors.purple,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  manualAlarm = true;
                });
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text("تشغيل الإنذار يدويًا"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white54,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 10),
            if (manualAlarm)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    manualAlarm = false;
                  });
                },
                icon: const Icon(Icons.cancel),
                label: const Text("إيقاف الإنذار"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

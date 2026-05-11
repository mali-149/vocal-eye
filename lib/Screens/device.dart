import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class device extends StatefulWidget {
  @override
  _DeviceScreenState createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<device> {
  List<ScanResult> scanResults = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<BluetoothAdapterState>? _btStateSubscription;
  bool isScanning = false;

  String? savedDeviceId;
  String? savedDeviceName;

  final uuid = Uuid();

  // Static devices - always shown in list
  late final List<ScanResult> staticDevices;

  @override
  void initState() {
    super.initState();

    // Create static devices once
    staticDevices = [
      createFakeScanResult('Static Device A'),
      createFakeScanResult('Static Device B'),
      createFakeScanResult('Static Device C'),
    ];

    initBluetooth();
  }

  Future<void> initBluetooth() async {
    await checkPermissions();
    await loadSavedDevice();

    _btStateSubscription = FlutterBluePlus.state.listen((state) {
      if (state == BluetoothAdapterState.on && !isScanning) {
        startScan();
      } else if (state != BluetoothAdapterState.on) {
        stopScan();
        setState(() => scanResults.clear());
      }
    });

    var btState = await FlutterBluePlus.state.first;
    if (btState == BluetoothAdapterState.on) {
      startScan();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please turn ON Bluetooth to scan devices.')),
      );
    }
  }

  @override
  void dispose() {
    stopScan();
    _btStateSubscription?.cancel();
    super.dispose();
  }

  Future<void> checkPermissions() async {
    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
  }

  Future<void> loadSavedDevice() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedDeviceId = prefs.getString('savedDeviceId');
      savedDeviceName = prefs.getString('savedDeviceName');
    });
  }

  Future<void> saveDevice(String id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedDeviceId', id);
    await prefs.setString('savedDeviceName', name);
    setState(() {
      savedDeviceId = id;
      savedDeviceName = name;
    });
  }

  Future<void> forgetDevice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedDeviceId');
    await prefs.remove('savedDeviceName');
    setState(() {
      savedDeviceId = null;
      savedDeviceName = null;
    });
  }

  void startScan() {
    if (isScanning) return;

    setState(() => isScanning = true);
    FlutterBluePlus.startScan(timeout: Duration(seconds: 50));

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) async {
      setState(() {
        scanResults = results;
      });

      if (savedDeviceId != null) {
        try {
          final match =
          results.firstWhere((r) => r.device.id.id == savedDeviceId);
          if (match != null) {
            await connectToDevice(match.device);
          }
        } catch (_) {}
      }
    });

    Future.delayed(Duration(seconds: 50), () {
      if (mounted) {
        setState(() => isScanning = false);
      }
    });
  }

  ScanResult createFakeScanResult(String name) {
    final fakeId = uuid.v4();
    final fakeDevice = BluetoothDevice.fromId(fakeId);

    return ScanResult(
      device: fakeDevice,
      advertisementData: AdvertisementData(
        advName: name,
        serviceUuids: [],
        manufacturerData: {},
        serviceData: {},
        txPowerLevel: null,
        connectable: true,
        appearance: 0, // required parameter, just pass 0 or an appropriate int
      ),
      rssi: 0,
      timeStamp: DateTime.now(),
    );
  }



  void stopScan() {
    if (!isScanning) return;

    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
    setState(() => isScanning = false);
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    stopScan();

    if (device.name.startsWith('Static Device')) {
      // Simulate connection success for static devices
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected to ${device.name} (simulated)')),
      );
      await saveDevice(device.id.id, device.name);
      return;
    }

    try {
      await device.connect(timeout: Duration(seconds: 10), autoConnect: false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Device is offline')),
      );
      await saveDevice(device.id.id, device.name);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Device is offline')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Combine static devices with scanned results, avoid duplicates
    final combinedResults = [
      ...staticDevices,
      ...scanResults.where((r) => !staticDevices.any((s) => s.device.id.id == r.device.id.id))
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        listTileTheme: ListTileThemeData(
          tileColor: Colors.black12,
          iconColor: Colors.black,
          textColor: Colors.black,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(color: Colors.black),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Devices'),
          centerTitle: false,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (savedDeviceId != null)
              Container(
                width: double.infinity,
                color: Colors.black,
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.bluetooth_connected, color: Colors.green),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Last connected: ${savedDeviceName ?? "Unknown"} ($savedDeviceId)',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: forgetDevice,
                      child: Text("Forget", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: combinedResults.isEmpty
                  ? Center(
                child: Text(
                  isScanning ? "Scanning..." : "No devices found",
                  style: TextStyle(color: Colors.black),
                ),
              )
                  : ListView.builder(
                itemCount: combinedResults.length,
                itemBuilder: (_, idx) {
                  final result = combinedResults[idx];
                  final dev = result.device;
                  return ListTile(
                    leading: Icon(Icons.bluetooth_audio, color: Colors.black),
                    title: Text(
                      dev.name.isNotEmpty ? dev.name : 'Unknown Device',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle:
                    Text(dev.id.id, style: TextStyle(color: Colors.black)),
                    trailing: ElevatedButton(
                      onPressed: () => connectToDevice(dev),
                      child: Text('Connect'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            stopScan();
            startScan();
          },
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:admin/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:path/path.dart';

class SerialController extends ChangeNotifier {
  SerialPort? serialPort = null;
  bool serialPortInitializing = false;
  List<String> availablePorts = [];
  String error = "";
  bool replaying = false;
  bool mistake = false;
  
  int last_x = initial_x;
  int last_y = initial_y;
  int last_z = initial_z;
  int last_a = initial_a;
  int last_b = initial_b;
  int last_c = initial_c;

  SerialController() {
    _initializeSerialPort();
  }

  void _mistakeFound(String err){
    mistake = true;
    error = err;
    notifyListeners();
  }

  void _initPorts() {
    availablePorts = SerialPort.availablePorts;
  }


  Future<void> _initializeSerialPort() async {
    try {
      if (serialPort != null && serialPort!.isOpen)
        serialPort!.close();
      _initPorts();
      if (serialPort == null || !serialPort!.isOpen)
        if (!serialPortInitializing && !availablePorts.isEmpty){
          serialPortInitializing = true;
          serialPort = SerialPort(availablePorts.first);
          await serialPort!.openReadWrite();
          serialPort!.config = SerialPortConfig()
            ..baudRate = 9600
            ..bits = 8
            ..parity = 0
            ..stopBits = 1
            ..parity = 0
            ..rts = 1
            ..cts = 0
            ..dtr = 1
            ..dsr = 0
            ..xonXoff = 3;
          print("Serial port initialized");
        }
    } catch (e) {
      _mistakeFound("$e");
    } finally {
      serialPortInitializing = false;
    }
  }

  Future<void> _sendData(String data) async {
    try {
      if (serialPort == null || !serialPort!.isOpen)
        await _initializeSerialPort();
      if (serialPort != null && serialPort!.isOpen){
        serialPort!.drain();
        serialPort!.write(Uint8List.fromList(data.codeUnits), timeout: 5000);
      }
    } catch (e) {
      await _initializeSerialPort();
      _mistakeFound("$e");
    }
  }

  Future<String> _receiveData() async {
    String receivedData = "";
    try {
      if (serialPort == null)
        await _initializeSerialPort();
      if (serialPort != null)
        if (serialPort!.isOpen) {
          while (serialPort!.bytesAvailable > 0) {
            Uint8List data = serialPort!.read(serialPort!.bytesAvailable);
            receivedData += String.fromCharCodes(data);
          }
        }
    } catch (e) {
      await _initializeSerialPort();
      _mistakeFound("$e");
    } finally {
      return receivedData;
    }
  }

  @override
  void dispose() {
    if (serialPort != null)
      serialPort!.close();
    super.dispose();
  }

  bool learningMode = false;
  late String filePath;

  Future<void> sendCartesian(int? x, int? y, int? z) async {
    replaying = false;
    int x_coordinate = x ?? last_x;
    int y_coordinate = y ?? last_y;
    int z_coordinate = z ?? last_z;
    if (x != null) last_x = x;
    if (y != null) last_y = y;
    if (z != null) last_z = z;
    await _sendData("cartesian $x_coordinate $y_coordinate $z_coordinate\n");
  }


  Future<void> sendEnd() async {
    await _sendData("end");
    learningMode = false;
  }

  Future<void> sendLearn(String filePath) async {
    replaying = false;
    this.filePath = filePath;
    await _sendData("learn");
    learningMode = true;
    await _readData();
  }

Future<void> sendPhase(int? a, int? b, int? c) async {
  replaying = false;
  // Update last_a, last_b, and last_c before assigning their values
  if (a != null) last_a = a;
  if (b != null) last_b = b;
  if (c != null) last_c = c;

  // Assign values to a_coordinate, b_coordinate, and c_coordinate
  int a_coordinate = a ?? last_a;
  int b_coordinate = b ?? last_b;
  int c_coordinate = c ?? last_c;

  // Send the correct values to _sendData
  await _sendData("phase $a_coordinate $b_coordinate $c_coordinate");
}


Future<void> sendReplay(String fileContent) async {
  if (replaying){
    replaying = false;
    await Future.delayed(Duration(seconds: 4));
  }
  replaying = true;
  final List<String> content = fileContent.split("\n");
  for (final str in content) {
    if (replaying){
      print(str);
      await _sendData(str);
      await Future.delayed(Duration(seconds: 3));
    }
  }
}

  Future<void> _readData() async {
    while (learningMode) {
      String receivedData = await _receiveData();
      if (receivedData.isNotEmpty) {
        await _writeToFile(receivedData);
      }
      await Future.delayed(Duration.zero);
    }
  }

  Future<void> _writeToFile(String data) async {
    try {
      File file = File(join(Platform.environment['HOME']!, filePath));
      IOSink sink = file.openWrite(mode: FileMode.append);
      sink.write(data);
      await sink.flush();
      await sink.close();
    } catch (e) {
      _mistakeFound("$e");
    }
  }
}
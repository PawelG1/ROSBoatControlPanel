import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ros_visualizer/providers/ros_params_providers.dart';


final ipProvider = StateProvider<String>((ref) => '192.168.1.1');

final connectionStatusProvider = StateProvider<String>((ref) => 'Disconnected');

final socketServiceProvider = StateNotifierProvider<SocketService, bool>((ref) {
  return SocketService(ref);
});

class SocketService extends StateNotifier<bool> {
  final Ref ref;
  Socket? _socket;
  bool _isConnecting = false;
  String _messageBuffer = ''; // Dodaj bufor dla niepełnych wiadomości

  SocketService(this.ref) : super(false);

  Future<void> connect(String ip) async {
    if (_isConnecting || _socket != null) {
      return;
    }

    _isConnecting = true;
    ref.read(connectionStatusProvider.notifier).state = 'Connecting...';

    try {
      _socket = await Socket.connect(ip, 8765);
      state = true;
      _isConnecting = false;
      ref.read(connectionStatusProvider.notifier).state = 'Connected';

      _socket!.listen((data) {
        final message = String.fromCharCodes(data);
        _messageBuffer += message; // Dodaj do bufora
        
        // Przetwarzaj kompletne linie (zakończone \n)
        while (_messageBuffer.contains('\n')) {
          final newlineIndex = _messageBuffer.indexOf('\n');
          final completeLine = _messageBuffer.substring(0, newlineIndex).trim();
          _messageBuffer = _messageBuffer.substring(newlineIndex + 1);
          
          if (completeLine.isNotEmpty) {
            try {
              final jsonData = jsonDecode(completeLine);
              
              // Aktualizuj pitch
              final pitch = jsonData['pitch'] as num?;
              if (pitch != null) {
                ref.read(pitchProvider.notifier).state = pitch.toDouble();
              }
              
              // Aktualizuj roll
              final roll = jsonData['roll'] as num?;
              if (roll != null) {
                ref.read(rollProvider.notifier).state = roll.toDouble();
              }
              
              // Aktualizuj battery voltage
              final batteryVoltage = jsonData['battery_voltage'] as num?;
              if (batteryVoltage != null) {
                ref.read(batteryVoltageProvider.notifier).state = batteryVoltage.toDouble();
              }
              
              // Aktualizuj rudder angle
              final rudderAngle = jsonData['rudder_angle'] as num?;
              if (rudderAngle != null) {
                ref.read(rudderAngleProvider.notifier).state = rudderAngle.toDouble();
              }
              
            } catch (e) {
              debugPrint('JSON decode error: $e');
              debugPrint('Problematic line: "$completeLine"');
            }
          }
        }
      }, onError: (error) {
        debugPrint("Socket error: $error");
        _handleDisconnection();
      }, onDone: () {
        debugPrint("Socket connection closed");
        _handleDisconnection();
      });
      
    } catch (e) {
      debugPrint('Connection error: $e');
      _isConnecting = false;
      state = false;
      ref.read(connectionStatusProvider.notifier).state = 'Failed';
    }
  }

  void _handleDisconnection() {
    _socket = null;
    _isConnecting = false;
    state = false;
    _messageBuffer = ''; // Wyczyść bufor przy rozłączeniu
    ref.read(connectionStatusProvider.notifier).state = 'Disconnected';
  }

  void disconnect() {
    _socket?.close();
    _handleDisconnection();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
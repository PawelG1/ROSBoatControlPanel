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
      ref.read(connectionStatusProvider.notifier).state = 'Connected'; // Upewnij się że to jest "Connected"

      _socket!.listen((data) {
        final message = String.fromCharCodes(data).trim();
        if (message.isNotEmpty) {
          final lines = message.split('\n');
          for (final line in lines) {
            if (line.trim().isNotEmpty) {
              try {
                final jsonData = jsonDecode(line.trim());
                
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
                
                // Aktualizuj speed
                final speed = jsonData['speed'] as num?;
                if (speed != null) {
                  //ref.read(speedProvider.notifier).state = speed.toDouble();
                }
                
                // Możesz dodać więcej parametrów jak yaw, temperature, itp.
                
              } catch (e) {
                debugPrint('JSON decode error: $e');
              }
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
    ref.read(connectionStatusProvider.notifier).state = 'Disconnected'; // I to "Disconnected"
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
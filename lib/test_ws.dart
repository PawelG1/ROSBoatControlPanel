import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Test',
      home: SocketTestPage(),
    );
  }
}

class SocketTestPage extends StatefulWidget {
  @override
  _SocketTestPageState createState() => _SocketTestPageState();
}

class _SocketTestPageState extends State<SocketTestPage> {
  Socket? _socket;
  List<String> _messages = [];
  String _connectionStatus = 'Disconnected';
  double _lastPitch = 0.0;
  String _ipAddress = '192.168.0.123'; // Zmień na IP swojego RPi
  
  final ScrollController _scrollController = ScrollController();

  void _addMessage(String message) {
    setState(() {
      _messages.add('${DateTime.now().toString().substring(11, 19)}: $message');
      if (_messages.length > 50) {
        _messages.removeAt(0); // Keep only last 50 messages
      }
    });
    
    // Auto scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _connect() async {
    _addMessage('🔄 Trying to connect to $_ipAddress:8765...');
    
    try {
      _socket = await Socket.connect(_ipAddress, 8765);
      
      setState(() {
        _connectionStatus = 'Connected';
      });
      
      _addMessage('✅ Connected successfully!');
      
      _socket!.listen(
        (data) {
          final message = String.fromCharCodes(data).trim();
          _addMessage('📨 Raw: $message');
          
          // Parse JSON
          final lines = message.split('\n');
          for (final line in lines) {
            if (line.trim().isNotEmpty) {
              try {
                final jsonData = jsonDecode(line.trim());
                final pitch = jsonData['pitch'];
                if (pitch != null) {
                  setState(() {
                    _lastPitch = pitch.toDouble();
                  });
                  _addMessage('🎯 Pitch: $pitch°');
                }
              } catch (e) {
                _addMessage('❌ JSON error: $e');
                _addMessage('   Line: "$line"');
              }
            }
          }
        },
        onError: (error) {
          _addMessage('❌ Socket error: $error');
          setState(() {
            _connectionStatus = 'Error';
          });
        },
        onDone: () {
          _addMessage('🔌 Connection closed');
          setState(() {
            _connectionStatus = 'Disconnected';
          });
        },
      );
      
    } catch (e) {
      _addMessage('❌ Connection failed: $e');
      setState(() {
        _connectionStatus = 'Failed';
      });
    }
  }

  void _disconnect() {
    _socket?.close();
    _socket = null;
    setState(() {
      _connectionStatus = 'Disconnected';
    });
    _addMessage('🔌 Disconnected');
  }

  void _clearMessages() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  void dispose() {
    _socket?.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Connection info
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          _connectionStatus,
                          style: TextStyle(
                            color: _connectionStatus == 'Connected' 
                                ? Colors.green 
                                : _connectionStatus == 'Failed' 
                                  ? Colors.red 
                                  : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Server: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'IP Address',
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            ),
                            onChanged: (value) => _ipAddress = value,
                            controller: TextEditingController(text: _ipAddress),
                          ),
                        ),
                        Text(':8765'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Last Pitch: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${_lastPitch.toStringAsFixed(2)}°',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 16),
            
            // Buttons
            Row(
              children: [
                ElevatedButton(
                  onPressed: _connectionStatus == 'Connected' ? null : _connect,
                  child: Text('Connect'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _connectionStatus == 'Connected' ? _disconnect : null,
                  child: Text('Disconnect'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _clearMessages,
                  child: Text('Clear'),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // Messages
            Expanded(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Messages:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 1),
                              child: Text(
                                _messages[index],
                                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
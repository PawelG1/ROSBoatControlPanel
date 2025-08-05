import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ros_visualizer/services/socketService.dart';
import 'package:ros_visualizer/widgets/menuSideBar.dart';

class ConnectionScreen extends ConsumerWidget{
  const ConnectionScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionStatus = ref.watch(connectionStatusProvider);
    final isConnected = ref.watch(socketServiceProvider);
    final ipController = TextEditingController(text: ref.read(ipProvider));

    return Scaffold(
      appBar: AppBar(
        title: Text('Connection Settings'),
      ),
      body: Row(
        children: [
          // Sidebar
          Menusidebar(),
          // Main content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connection Status',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                isConnected ? Icons.check_circle : Icons.error,
                                color: isConnected ? Colors.green : Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text(
                                connectionStatus,
                                style: TextStyle(
                                  color: isConnected ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Server Settings',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: ipController,
                                  decoration: InputDecoration(
                                    labelText: 'IP Address',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    ref.read(ipProvider.notifier).state = value;
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: isConnected 
                                  ? () => ref.read(socketServiceProvider.notifier).disconnect()
                                  : () => ref.read(socketServiceProvider.notifier).connect(ref.read(ipProvider)),
                                child: Text(isConnected ? 'Disconnect' : 'Connect'),
                              ),
                            ],
                          ),
                        ],
                      ),
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
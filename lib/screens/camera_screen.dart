import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ros_visualizer/providers/ros_params_providers.dart';
import 'package:ros_visualizer/services/socketService.dart';
import 'package:ros_visualizer/widgets/battery_ind.dart';
import 'package:ros_visualizer/widgets/dashboard_card.dart';
import 'package:ros_visualizer/widgets/gauges/attitudeInd.dart';
import 'package:ros_visualizer/widgets/gauges/azimuthInd.dart';
import 'package:ros_visualizer/widgets/menuSideBar.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;
import 'dart:developer' as developer;

class CameraScreen extends ConsumerWidget {
  const CameraScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const Menusidebar(),
        Expanded(
          child: Stack(
            children: [
              DashboardCard(
                height: double.infinity,
                title: "addr: ${ref.watch(ipProvider.notifier).state}",
                child: const SizedBox(
                  child: VideoStreamWidget(),
                ),
              ),
              Positioned(
                top: 20, right: 20,
                child: BatteryInd(batteryVoltageStateProvider: batteryVoltageProvider),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 320,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: AttitudeInd(
                          pitchProvider: pitchProvider, 
                          rollProvider: rollProvider,
                          radius: 200,
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Azimuthind(radius: 200),
                      ),
                    ],
                  ),
                )
              )
            ]
          ),
        ),
      ],
    );
  }
}

class VideoStreamWidget extends ConsumerStatefulWidget {
  const VideoStreamWidget({super.key});
  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return VideoStreamWidgetState();
  }
}

class VideoStreamWidgetState extends ConsumerState<VideoStreamWidget> {
  String _viewId = '';
  web.HTMLImageElement? _imageElement;
  bool _hasError = false;
  String _debugInfo = 'Inicjalizacja...';
  
  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  @override
  void dispose() {
    _imageElement?.remove();
    super.dispose();
  }

  void _initializeWebView() {
    final String videoSourceAddr = ref.read(ipProvider.notifier).state;
    final String streamUrl = 'http://$videoSourceAddr:8080/camera/stream?topic=/image_raw&type=mjpeg&quality=30&width=1280&height=720';
    
    _viewId = 'camera-stream-${DateTime.now().millisecondsSinceEpoch}';
    
    // Tworzenie elementu IMG w HTML
    _imageElement = web.document.createElement('img') as web.HTMLImageElement;
    _imageElement!.src = streamUrl;
    _imageElement!.style.width = '100%';
    _imageElement!.style.height = '100%';
    _imageElement!.style.objectFit = 'cover';
    _imageElement!.style.border = 'none';
    _imageElement!.crossOrigin = 'anonymous';

    // Obsługa zdarzeń
    _imageElement!.onload = (web.Event event) {
      if (mounted) {
        setState(() {
          _debugInfo = 'Stream załadowany pomyślnie';
          _hasError = false;
        });
      }
    }.toJS;

    _imageElement!.onerror = (web.Event event) {
      developer.log('Image load error: $event');
      if (mounted) {
        setState(() {
          _debugInfo = 'Błąd ładowania streamu';
          _hasError = true;
        });
      }
    }.toJS;

    // Rejestracja widoku w Flutter Web
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) => _imageElement!,
    );

    setState(() {
      _debugInfo = 'Łączenie ze streamem...';
    });
  }

  void _refreshStream() {
    final String videoSourceAddr = ref.read(ipProvider.notifier).state;
    final String newUrl = 'http://$videoSourceAddr:8080/camera/stream?topic=/image_raw&type=mjpeg&quality=30&width=1280&height=720&t=${DateTime.now().millisecondsSinceEpoch}';
    
    setState(() {
      _debugInfo = 'Odświeżanie streamu...';
      _hasError = false;
    });

    if (_imageElement != null) {
      _imageElement!.src = newUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            const Text('Błąd ładowania streamu'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshStream,
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: HtmlElementView(
        key: ValueKey(_viewId),
        viewType: _viewId,
      ),
    );
  }
}
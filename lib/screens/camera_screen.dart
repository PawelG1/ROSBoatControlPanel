import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ros_visualizer/providers/ros_params_providers.dart';
import 'package:ros_visualizer/services/socketService.dart';
import 'package:ros_visualizer/widgets/battery_ind.dart';
import 'package:ros_visualizer/widgets/dashboard_card.dart';
import 'package:ros_visualizer/widgets/gauges/attitudeInd.dart';
import 'package:ros_visualizer/widgets/gauges/azimuthInd.dart';
import 'package:ros_visualizer/widgets/menuSideBar.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class CameraScreen extends ConsumerWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const Menusidebar(),
        Expanded(
          child: Container(
            color: Colors.black,
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
                  top: 20, 
                  right: 20,
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
  html.ImageElement? _imageElement;
  bool _hasError = false;
  String? _currentStreamUrl;

  @override
  void initState() {
    super.initState();
    // Opóźnienie inicjalizacji aby mieć dostęp do ref
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeStream();
    });
  }

  @override
  void dispose() {
    _imageElement?.remove();
    super.dispose();
  }

  void _initializeStream() {
    final String videoSourceAddr = ref.read(ipProvider.notifier).state;
    final String streamUrl = 'http://$videoSourceAddr:8080/stream?topic=/camera/image_raw&type=mjpeg&quality=30&width=1280&height=720';
    
    _currentStreamUrl = streamUrl;
    _viewId = 'mjpeg-stream-${DateTime.now().millisecondsSinceEpoch}';
    
    // Tworzenie elementu IMG z wszystkimi potrzebnymi ustawieniami
    _imageElement = html.ImageElement()
      ..src = streamUrl
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..style.border = 'none'
      ..crossOrigin = 'anonymous';

    // Obsługa załadowania streamu
    _imageElement!.onLoad.listen((_) {
      if (mounted) {
        setState(() {
          _hasError = false;
        });
      }
    });

    // Obsługa błędów
    _imageElement!.onError.listen((event) {
      debugPrint('MJPEG Stream Error: $event');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    });

    // Rejestracja w Flutter Web
    ui_web.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) => _imageElement!,
    );

    setState(() {
      _hasError = false;
    });
  }

  void _refreshStream() {
    final String videoSourceAddr = ref.read(ipProvider.notifier).state;
    final String newStreamUrl = 'http://$videoSourceAddr:8080/stream?topic=/camera/image_raw&type=mjpeg&quality=30&width=1280&height=720&t=${DateTime.now().millisecondsSinceEpoch}';
    
    _currentStreamUrl = newStreamUrl;
    if (_imageElement != null) {
      _imageElement!.src = newStreamUrl;
    }
    
    setState(() {
      _hasError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sprawdź czy IP się zmienił
    final String currentVideoSourceAddr = ref.watch(ipProvider.notifier).state;
    final String expectedStreamUrl = 'http://$currentVideoSourceAddr:8080/stream?topic=/camera/image_raw&type=mjpeg&quality=30&width=1280&height=720';
    
    // Jeśli IP się zmienił, odśwież stream
    if (_currentStreamUrl != null && !_currentStreamUrl!.startsWith('http://$currentVideoSourceAddr:8080/stream')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _refreshStream();
      });
    }

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: _hasError 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 32),
                  const SizedBox(height: 8),
                  const Text('Stream Error', style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _refreshStream,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _viewId.isNotEmpty 
            ? HtmlElementView(
                key: ValueKey(_viewId),
                viewType: _viewId,
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
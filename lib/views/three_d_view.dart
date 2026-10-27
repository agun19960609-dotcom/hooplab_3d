import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class ThreeDView extends StatefulWidget {
  const ThreeDView({super.key, required this.playbookJson});

  final String playbookJson;

  @override
  State<ThreeDView> createState() => _ThreeDViewState();
}

class _ThreeDViewState extends State<ThreeDView> {
  late final WebViewController controller;
  String _cameraView = '3d';
  int currentZoom = 1;

  void _setCameraView(String viewType) {
    setState(() => _cameraView = viewType);
    controller.runJavaScript("window.setCameraView('$viewType');");
  }

  void _setZoomLevel(int level) {
    setState(() => currentZoom = level);
    controller.runJavaScript("window.setZoomLevel($level);");
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setOnConsoleMessage((message) {
        debugPrint('JS Console: ${message.message}');
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _injectAssetsAndPlaybook();
          },
        ),
      );
    final platform = controller.platform;
    if (platform is AndroidWebViewController) {
      platform.setAllowFileAccess(true);
      platform.setAllowContentAccess(true);
    }
    controller.loadFlutterAsset('assets/3d_court.html');
  }

  Future<void> _injectAssetsAndPlaybook() async {
    final payload = jsonEncode(widget.playbookJson);
    await controller.runJavaScript('window.loadPlaybook($payload);');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10141C),
      appBar: AppBar(
        backgroundColor: const Color(0xE610141C),
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('3D Preview'),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: WebViewWidget(controller: controller)),
          Positioned(
            top: 20,
            left: 20,
            child: Material(
              color: const Color(0xCC121824),
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(Icons.zoom_in, color: Colors.white, size: 20),
                    ),
                    _CameraChip(
                      label: '1x',
                      selected: currentZoom == 1,
                      onTap: () => _setZoomLevel(1),
                    ),
                    _CameraChip(
                      label: '2x',
                      selected: currentZoom == 2,
                      onTap: () => _setZoomLevel(2),
                    ),
                    _CameraChip(
                      label: '3x',
                      selected: currentZoom == 3,
                      onTap: () => _setZoomLevel(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Material(
              color: const Color(0xCC121824),
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CameraChip(
                      label: '3D',
                      selected: _cameraView == '3d',
                      onTap: () => _setCameraView('3d'),
                    ),
                    _CameraChip(
                      label: '俯仰',
                      selected: _cameraView == 'top',
                      onTap: () => _setCameraView('top'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CameraChip extends StatelessWidget {
  const _CameraChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE86100) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

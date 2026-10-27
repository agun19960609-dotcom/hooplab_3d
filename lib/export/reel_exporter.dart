import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooplab_3d/export/mjpeg_mp4.dart';
import 'package:hooplab_3d/export/play_replay.dart';
import 'package:hooplab_3d/views/playboard_view.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// iPad share sheets need a source rectangle. Phones ignore it.
Rect shareSheetOrigin(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null || !box.attached || !box.hasSize) {
    return const Rect.fromLTWH(0, 0, 1, 1);
  }
  return box.localToGlobal(Offset.zero) & box.size;
}

class ReelExporter {
  static const channel = MethodChannel('hooplab/reel');
  static const width = 540;
  static const height = 960;
  static const fps = 10;

  static Future<File> exportJson(String playbookJson) async {
    final steps = replaySteps(playbookJson);
    final frames = steps.isEmpty
        ? [const ReplayStep(lines: [], progress: 0)]
        : steps;
    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final frameDir = Directory('${dir.path}/hooplab_frames_$stamp');
    await frameDir.create(recursive: true);
    final jpgs = <Uint8List>[];
    try {
      for (var i = 0; i < frames.length; i++) {
        final jpg = await _render(frames[i]);
        jpgs.add(jpg);
        await File('${frameDir.path}/frame_${i.toString().padLeft(3, '0')}.jpg')
            .writeAsBytes(jpg, flush: true);
      }
      final out = File('${dir.path}/hooplab_$stamp.mp4');
      final encoded = await _encode(
        dir: frameDir.path,
        output: out.path,
        fallback: jpgs,
      );
      if (!await out.exists() || await out.length() < 32) {
        await out.writeAsBytes(encoded, flush: true);
      }
      return out;
    } finally {
      if (await frameDir.exists()) {
        await frameDir.delete(recursive: true);
      }
    }
  }

  static Future<Uint8List> _encode({
    required String dir,
    required String output,
    required List<Uint8List> fallback,
  }) async {
    try {
      final ok = await channel.invokeMethod<bool>('encode', {
        'dir': dir,
        'fps': fps,
        'width': width,
        'height': height,
        'output': output,
      });
      if (ok == true) {
        final file = File(output);
        if (await file.exists() && await file.length() > 32) {
          return file.readAsBytes();
        }
      }
    } on MissingPluginException {
      // Desktop tests and unsupported hosts use the bundled muxer.
    } catch (_) {
      // Fall through to the portable muxer.
    }
    return muxMjpegMp4(fallback, width: width, height: height, fps: fps);
  }

  static Future<Uint8List> _render(ReplayStep step) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      Paint()..color = const Color(0xFF10141C),
    );
    final court = CourtGeometry.fitTo(
      const Size(width.toDouble(), height.toDouble()),
      padding: 36,
    );
    CourtPainter(
      courtRect: court,
      offense: step.offense,
      defense: step.defense,
      offenseOnCourt: step.offenseOn,
      defenseOnCourt: step.defenseOn,
      drawnLines: step.lines,
      playerRadius: CourtGeometry.playerRadius(court),
      currentProgress: step.progress,
      ballCarrierId: step.ballCarrierId,
      standaloneBallPosition: step.standaloneBall,
    ).paint(canvas, const Size(width.toDouble(), height.toDouble()));
    final title = ui.ParagraphBuilder(
      ui.ParagraphStyle(textAlign: TextAlign.center, fontSize: 22),
    )
      ..pushStyle(ui.TextStyle(color: const Color(0xFFF4F4F4)))
      ..addText(step.title);
    final paragraph = title.build()
      ..layout(const ui.ParagraphConstraints(width: width.toDouble()));
    canvas.drawParagraph(paragraph, const Offset(0, 18));
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final raw = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    if (raw == null) {
      throw StateError('Could not read a reel frame');
    }
    final decoded = img.Image.fromBytes(
      width: width,
      height: height,
      bytes: raw.buffer,
      bytesOffset: raw.offsetInBytes,
      numChannels: 4,
      order: img.ChannelOrder.rgba,
    );
    return Uint8List.fromList(img.encodeJpg(decoded, quality: 72));
  }
}

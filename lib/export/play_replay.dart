import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooplab_3d/models/playbook_models.dart';
import 'package:hooplab_3d/views/playboard_view.dart';

class ReplayStep {
  const ReplayStep({
    required this.lines,
    required this.progress,
    this.offense = const [
      Offset(0.50, 0.42),
      Offset(0.86, 0.30),
      Offset(0.14, 0.30),
      Offset(0.74, 0.18),
      Offset(0.26, 0.18),
    ],
    this.defense = const [
      Offset(0.50, 0.33),
      Offset(0.72, 0.24),
      Offset(0.28, 0.24),
      Offset(0.60, 0.10),
      Offset(0.40, 0.10),
    ],
    this.offenseOn = const [false, false, false, false, false],
    this.defenseOn = const [false, false, false, false, false],
    this.ballCarrierId,
    this.standaloneBall,
    this.title = 'Hooplab',
  });

  final List<Offset> offense;
  final List<Offset> defense;
  final List<bool> offenseOn;
  final List<bool> defenseOn;
  final List<DrawnLine> lines;
  final double progress;
  final int? ballCarrierId;
  final Offset? standaloneBall;
  final String title;
}

List<ReplayStep> replaySteps(String raw) {
  final decoded = jsonDecode(raw);
  final map = decoded is Map<String, dynamic>
      ? decoded
      : jsonDecode(decoded as String) as Map<String, dynamic>;
  final playbook = Playbook.fromJson(map);
  if (playbook.steps.isEmpty) return const [];

  final offense = List<Offset>.filled(5, const Offset(0.5, 0.4));
  final defense = List<Offset>.filled(5, const Offset(0.5, 0.5));
  final offenseOn = List<bool>.filled(5, false);
  final defenseOn = List<bool>.filled(5, false);
  final frames = <ReplayStep>[];
  const samples = [0.0, 0.22, 0.48, 0.74, 1.0];

  for (final step in playbook.steps) {
    int? carrier;
    Offset? looseBall;
    final lines = <DrawnLine>[];
    for (final action in step.actions) {
      if (action.path.isEmpty) continue;
      final spot = Offset(action.path.first[0], action.path.first[1]);
      final id = action.playerId;
      if (id >= 1 && id <= 5) {
        offense[id - 1] = spot;
        offenseOn[id - 1] = true;
      } else if (id >= 11 && id <= 15) {
        defense[id - 11] = spot;
        defenseOn[id - 11] = true;
      }
      if (action.actionType == ActionType.dribble) {
        if (id >= 1 && id <= 5) {
          carrier = id;
          looseBall = null;
        } else {
          carrier = null;
          looseBall = spot;
        }
      }
      if (action.path.length < 2) continue;
      final type = _lineType(action.actionType);
      if (type == null) continue;
      lines.add(
        DrawnLine(
          points: [
            for (final point in action.path)
              if (point.length >= 2) Offset(point[0], point[1]),
          ],
          type: type,
        ),
      );
    }
    for (final progress in samples) {
      frames.add(
        ReplayStep(
          offense: List<Offset>.from(offense),
          defense: List<Offset>.from(defense),
          offenseOn: List<bool>.from(offenseOn),
          defenseOn: List<bool>.from(defenseOn),
          lines: lines.map((line) => line.copy()).toList(),
          progress: progress,
          ballCarrierId: carrier,
          standaloneBall: looseBall,
          title: playbook.playName,
        ),
      );
    }
  }
  return frames;
}

LineType? _lineType(ActionType type) {
  switch (type) {
    case ActionType.run:
      return LineType.run;
    case ActionType.pass:
      return LineType.pass;
    case ActionType.screen:
      return LineType.screen;
    case ActionType.shoot:
      return LineType.shoot;
    case ActionType.dribble:
      return null;
  }
}

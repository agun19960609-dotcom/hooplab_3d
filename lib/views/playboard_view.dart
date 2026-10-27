import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hooplab_3d/models/playbook_models.dart';
import 'package:hooplab_3d/views/three_d_view.dart';

/// NBA full-court proportions in feet, fitted uniformly to the paint area.
class CourtGeometry {
  static const widthFeet = 50.0;
  static const lengthFeet = 94.0;
  static const hoopFromBaseline = 5.25;
  static const hoopRadius = 0.75;
  static const backboardFromBaseline = 4.0;
  static const backboardWidth = 6.0;
  static const laneWidth = 16.0;
  static const freeThrowLineFromBaseline = 19.0;
  static const freeThrowRadius = 6.0;
  static const threePointRadius = 23.75;
  /// Inset from each sideline so the corner 3 has a visible alley.
  static const cornerThreeFromSideline = 5.0;
  static const centerCircleRadius = 6.0;
  static const restrictedRadius = 4.0;

  static const aspectRatio = widthFeet / lengthFeet;

  static Rect fitTo(Size size, {double padding = 12}) {
    final maxWidth = math.max(0.0, size.width - padding * 2);
    final maxHeight = math.max(0.0, size.height - padding * 2);
    late final double width;
    late final double height;
    if (maxWidth / math.max(maxHeight, 0.001) > aspectRatio) {
      height = maxHeight;
      width = height * aspectRatio;
    } else {
      width = maxWidth;
      height = width / aspectRatio;
    }
    return Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: width,
      height: height,
    );
  }

  static Offset toCanvas(Offset feet, Rect court) {
    return Offset(
      court.left + (feet.dx / widthFeet) * court.width,
      court.top + (feet.dy / lengthFeet) * court.height,
    );
  }

  static Offset normalizedToCanvas(Offset normalized, Rect court) {
    return Offset(
      court.left + normalized.dx * court.width,
      court.top + normalized.dy * court.height,
    );
  }

  static Offset canvasToNormalized(Offset canvas, Rect court) {
    return Offset(
      (canvas.dx - court.left) / court.width,
      (canvas.dy - court.top) / court.height,
    );
  }

  static double playerRadius(Rect court) {
    return (math.min(court.width, court.height) * 0.028).clamp(11.0, 18.0);
  }

  /// Painted basketball radius. Keep well below [playerRadius].
  static const basketballVisualRadius = 8.0;

  /// Generous finger target; independent of the painted size.
  static const basketballHitRadius = 36.0;

  static double scale(Rect court) => court.width / widthFeet;
}

const _initialOffense = <Offset>[
  Offset(0.50, 0.42), // 1 — PG
  Offset(0.86, 0.30), // 2 — SG
  Offset(0.14, 0.30), // 3 — SF
  Offset(0.74, 0.18), // 4 — PF
  Offset(0.26, 0.18), // 5 — C
];

const _initialDefense = <Offset>[
  Offset(0.50, 0.33), // X1
  Offset(0.72, 0.24), // X2
  Offset(0.28, 0.24), // X3
  Offset(0.60, 0.10), // X4
  Offset(0.40, 0.10), // X5
];

enum LineType { run, pass, screen, shoot }

enum DrawTool { move, run, pass, screen, shoot }

class DrawnLine {
  const DrawnLine({required this.points, required this.type});

  final List<Offset> points;
  final LineType type;

  DrawnLine copy() => DrawnLine(points: List<Offset>.from(points), type: type);
}

const pathSnapRadius = 40.0;

class ResolvedBoard {
  ResolvedBoard({
    required List<Offset> offense,
    required List<Offset> defense,
    this.ballCarrierId,
    this.standaloneBallPosition,
  })  : offense = List<Offset>.from(offense),
        defense = List<Offset>.from(defense);

  final List<Offset> offense;
  final List<Offset> defense;
  int? ballCarrierId;
  Offset? standaloneBallPosition;

  ResolvedBoard copy() => ResolvedBoard(
        offense: offense,
        defense: defense,
        ballCarrierId: ballCarrierId,
        standaloneBallPosition: standaloneBallPosition,
      );
}

AssignedPaths assignMovingPaths({
  required List<DrawnLine> lines,
  required List<Offset> offense,
  required List<Offset> defense,
  required Rect court,
  int visibleCount = 5,
  Set<LineType> types = const {LineType.run, LineType.screen},
}) {
  final assignedOffense = <int, List<Offset>>{};
  final assignedDefense = <int, List<Offset>>{};
  final claimed = <String>{};
  final offenseCount = math.min(visibleCount, offense.length);
  final defenseCount = math.min(visibleCount, defense.length);

  for (final line in lines) {
    if (!types.contains(line.type) || line.points.length < 2) continue;
    final start = CourtGeometry.normalizedToCanvas(line.points.first, court);
    String? bestId;
    var bestDistance = pathSnapRadius;

    void consider(List<Offset> nodes, String prefix, int count) {
      for (var i = 0; i < count; i++) {
        final id = '$prefix$i';
        if (claimed.contains(id)) continue;
        final player = CourtGeometry.normalizedToCanvas(nodes[i], court);
        final distance = (player - start).distance;
        if (distance <= bestDistance) {
          bestDistance = distance;
          bestId = id;
        }
      }
    }

    consider(offense, 'o', offenseCount);
    consider(defense, 'd', defenseCount);
    if (bestId == null) continue;
    claimed.add(bestId!);
    final index = int.parse(bestId!.substring(1));
    if (bestId!.startsWith('d')) {
      assignedDefense[index] = line.points;
    } else {
      assignedOffense[index] = line.points;
    }
  }
  return AssignedPaths(offense: assignedOffense, defense: assignedDefense);
}

class AssignedPaths {
  const AssignedPaths({required this.offense, required this.defense});

  final Map<int, List<Offset>> offense;
  final Map<int, List<Offset>> defense;
}

int? nearestOffenseId({
  required Offset normalized,
  required List<Offset> offense,
  required Rect court,
  int visibleCount = 5,
  double snap = pathSnapRadius,
}) {
  final point = CourtGeometry.normalizedToCanvas(normalized, court);
  int? best;
  var bestDistance = snap;
  final count = math.min(visibleCount, offense.length);
  for (var i = 0; i < count; i++) {
    final player = CourtGeometry.normalizedToCanvas(offense[i], court);
    final distance = (player - point).distance;
    if (distance <= bestDistance) {
      bestDistance = distance;
      best = i + 1;
    }
  }
  return best;
}

List<Offset>? passPathForCarrier({
  required List<DrawnLine> lines,
  required int? ballCarrierId,
  required List<Offset> offense,
  required Rect court,
}) {
  if (ballCarrierId == null) return null;
  final index = ballCarrierId - 1;
  if (index < 0 || index >= offense.length) return null;
  final carrier = CourtGeometry.normalizedToCanvas(offense[index], court);
  List<Offset>? best;
  var bestDistance = pathSnapRadius;
  for (final line in lines) {
    if ((line.type != LineType.pass && line.type != LineType.shoot) ||
        line.points.length < 2) {
      continue;
    }
    final start = CourtGeometry.normalizedToCanvas(line.points.first, court);
    final distance = (start - carrier).distance;
    if (distance <= bestDistance) {
      bestDistance = distance;
      best = line.points;
    }
  }
  return best;
}

ResolvedBoard applyFrameLines({
  required ResolvedBoard start,
  required List<DrawnLine> lines,
  required Rect court,
  int visibleCount = 5,
}) {
  final next = start.copy();
  final moved = assignMovingPaths(
    lines: lines,
    offense: start.offense,
    defense: start.defense,
    court: court,
    visibleCount: visibleCount,
  );
  moved.offense.forEach((index, path) {
    if (index >= 0 && index < next.offense.length && path.length >= 2) {
      next.offense[index] = path.last;
    }
  });
  moved.defense.forEach((index, path) {
    if (index >= 0 && index < next.defense.length && path.length >= 2) {
      next.defense[index] = path.last;
    }
  });

  final pass = passPathForCarrier(
    lines: lines,
    ballCarrierId: start.ballCarrierId,
    offense: start.offense,
    court: court,
  );
  if (pass != null && pass.length >= 2) {
    final receiver = nearestOffenseId(
      normalized: pass.last,
      offense: next.offense,
      court: court,
      visibleCount: visibleCount,
    );
    if (receiver != null) {
      next.ballCarrierId = receiver;
      next.standaloneBallPosition = null;
    } else {
      next.ballCarrierId = null;
      next.standaloneBallPosition = pass.last;
    }
  }
  return next;
}

/// Interpolates along a polyline. [progress] is 0.0 at the start and 1.0 at the end.
Offset getPositionAlongPath(List<Offset> points, double progress) {
  if (points.isEmpty) return Offset.zero;
  if (points.length == 1 || progress <= 0) return points.first;
  if (progress >= 1) return points.last;

  var total = 0.0;
  final lengths = <double>[];
  for (var i = 1; i < points.length; i++) {
    final length = (points[i] - points[i - 1]).distance;
    lengths.add(length);
    total += length;
  }
  if (total <= 0) return points.last;

  var remaining = total * progress.clamp(0.0, 1.0);
  for (var i = 0; i < lengths.length; i++) {
    final length = lengths[i];
    if (remaining <= length) {
      final t = length == 0 ? 0.0 : remaining / length;
      return Offset.lerp(points[i], points[i + 1], t)!;
    }
    remaining -= length;
  }
  return points.last;
}

/// Ease-in/out for playback time. [getPositionAlongPath] stays linear.
double playbackEase(double t) {
  final x = t.clamp(0.0, 1.0);
  return x * x * x * (x * (x * 6 - 15) + 10);
}

/// A pass reaches the catch before the step ends. Shoot flights use [playbackEase].
double passFlight(double t) {
  const passEnd = 0.55;
  final u = (t / passEnd).clamp(0.0, 1.0);
  final inv = 1.0 - u;
  return 1.0 - inv * inv * inv;
}

class PlayboardView extends StatefulWidget {
  const PlayboardView({super.key, this.initialPlayData});

  final String? initialPlayData;

  @override
  State<PlayboardView> createState() => _PlayboardViewState();
}

class _PlayboardViewState extends State<PlayboardView>
    with SingleTickerProviderStateMixin {
  final List<Offset> _offense = List<Offset>.from(_initialOffense);
  final List<Offset> _defense = List<Offset>.from(_initialDefense);
  final List<List<DrawnLine>> frames = [[]];
  int currentFrameIndex = 0;
  final List<_BoardSnapshot> _undoStack = [];
  final List<_BoardSnapshot> _redoStack = [];

  DrawTool selectedTool = DrawTool.move;
  bool is3v3Mode = false;
  bool isPlaying = false;
  double currentProgress = 0.0;
  double playbackSpeed = 1.0;
  int? ballCarrierId = 1;
  Offset? standaloneBallPosition;
  DrawnLine? _activeStroke;
  int? _draggingIndex;
  bool _draggingDefense = false;
  bool _draggingBall = false;
  Offset? _ballDragPosition;
  _BoardSnapshot? _dragOrigin;
  Rect? _lastCourtRect;

  late final AnimationController _playbackController;

  static const _basePlaybackMs = 5000;

  @override
  void initState() {
    super.initState();
    _playbackController = AnimationController(
      vsync: this,
      duration: _durationForSpeed(1.0),
    );
    _playbackController.addListener(() {
      setState(() => currentProgress = _playbackController.value);
    });
    _playbackController.addStatusListener((status) {
      if (status != AnimationStatus.completed || !mounted) return;
      if (currentFrameIndex < frames.length - 1) {
        setState(() {
          currentFrameIndex += 1;
          currentProgress = 0;
        });
        _playbackController.forward(from: 0.0);
      } else {
        setState(() => isPlaying = false);
        _playbackController.stop();
      }
    });
    final initial = widget.initialPlayData;
    if (initial != null && initial.trim().isNotEmpty) {
      _applyPlaybookJson(initial);
    }
  }

  LineType? _lineTypeForAction(ActionType type) {
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

  void _applyPlaybookJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      final map = decoded is Map<String, dynamic>
          ? decoded
          : jsonDecode(decoded as String) as Map<String, dynamic>;
      final playbook = Playbook.fromJson(map);
      if (playbook.steps.isEmpty) return;

      final offense = List<Offset>.from(_initialOffense);
      final defenseIds = <int>{};
      for (final step in playbook.steps) {
        for (final action in step.actions) {
          if (action.playerId >= 11 && action.playerId <= 15) {
            defenseIds.add(action.playerId);
          }
        }
      }
      final defense = defenseIds.isEmpty
          ? <Offset>[]
          : List<Offset>.from(_initialDefense);
      int? carrier = 1;

      void placePlayer(int id, List<double> point) {
        if (point.length < 2) return;
        final pos = Offset(point[0], point[1]);
        if (id >= 1 && id <= 5) offense[id - 1] = pos;
        if (id >= 11 && id <= 15 && defense.isNotEmpty) {
          defense[id - 11] = pos;
        }
      }

      for (final action in playbook.steps.first.actions) {
        if (action.actionType == ActionType.dribble) {
          carrier = action.playerId > 0 ? action.playerId : null;
        }
        if (action.path.isNotEmpty) {
          placePlayer(action.playerId, action.path.first);
        }
      }

      final loadedFrames = <List<DrawnLine>>[];
      for (final step in playbook.steps) {
        final lines = <DrawnLine>[];
        for (final action in step.actions) {
          if (action.path.length < 2) continue;
          final type = _lineTypeForAction(action.actionType);
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
        loadedFrames.add(lines);
      }
      if (loadedFrames.isEmpty) loadedFrames.add(<DrawnLine>[]);

      setState(() {
        _offense
          ..clear()
          ..addAll(offense);
        _defense
          ..clear()
          ..addAll(defense);
        frames
          ..clear()
          ..addAll(loadedFrames);
        currentFrameIndex = 0;
        currentProgress = 0;
        isPlaying = false;
        ballCarrierId = carrier;
        standaloneBallPosition =
            carrier == null ? const Offset(0.50, 0.50) : null;
      });
    } catch (err) {
      debugPrint('Failed to load initial play data: $err');
    }
  }

  @override
  void dispose() {
    _playbackController.dispose();
    super.dispose();
  }

  Duration _durationForSpeed(double speed) {
    final ms = (_basePlaybackMs / speed.clamp(0.1, 8.0)).round();
    return Duration(milliseconds: math.max(1, ms));
  }

  void _togglePlayPause() {
    if (isPlaying) {
      _playbackController.stop();
      setState(() => isPlaying = false);
      return;
    }
    _playbackController.duration = _durationForSpeed(playbackSpeed);
    if (currentFrameIndex == frames.length - 1 &&
        _playbackController.value == 1.0) {
      setState(() {
        currentFrameIndex = 0;
        currentProgress = 0;
        isPlaying = true;
      });
      _playbackController.forward(from: 0.0);
      return;
    }
    _playbackController.forward();
    setState(() => isPlaying = true);
  }

  void _setPlaybackSpeed(double speed) {
    final value = _playbackController.value;
    _playbackController.duration = _durationForSpeed(speed);
    _playbackController.value = value;
    setState(() => playbackSpeed = speed);
    if (isPlaying) {
      _playbackController.forward();
    }
  }

  void _scrubProgress(double value) {
    _playbackController.value = value;
    setState(() => currentProgress = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10141C),
      appBar: AppBar(
        backgroundColor: const Color(0xE610141C),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                tooltip: '返回',
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                onPressed: () => Navigator.pop(context),
              )
            : IconButton(
                tooltip: 'Folders',
                icon: const Icon(Icons.folder_outlined),
                onPressed: () => _notify('Folders'),
              ),
        title: const Text(
          'Playboard',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: '3D Preview',
            icon: const Icon(Icons.view_in_ar_outlined),
            onPressed: _open3DPreview,
          ),
          IconButton(
            tooltip: 'Save',
            icon: const Icon(Icons.save_outlined),
            onPressed: () => _notify('Play saved'),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _notify('Settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                final courtRect = CourtGeometry.fitTo(size);
                _lastCourtRect = courtRect;
                final radius = CourtGeometry.playerRadius(courtRect);
                final resolved = _resolveThrough(currentFrameIndex, courtRect);

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (details) => _onPanStart(
                    details.localPosition,
                    courtRect,
                    radius,
                    resolved,
                  ),
                  onPanUpdate: (details) =>
                      _onPanUpdate(details.localPosition, courtRect, radius),
                  onPanEnd: (_) => _onPanEnd(courtRect, resolved),
                  onPanCancel: () => _onPanEnd(courtRect, resolved),
                  child: CustomPaint(
                    size: size,
                    painter: CourtPainter(
                      courtRect: courtRect,
                      offense: List<Offset>.from(resolved.offense),
                      defense: List<Offset>.from(resolved.defense),
                      drawnLines: drawnLines.map((line) => line.copy()).toList(),
                      activeStroke: _activeStroke?.copy(),
                      playerRadius: radius,
                      draggingIndex: _draggingIndex,
                      draggingDefense: _draggingDefense,
                      is3v3Mode: is3v3Mode,
                      currentProgress: currentProgress,
                      ballCarrierId: resolved.ballCarrierId,
                      standaloneBallPosition: resolved.standaloneBallPosition,
                      draggingBall: _draggingBall,
                      ballDragPosition: _ballDragPosition,
                    ),
                  ),
                );
              },
            ),
          ),
          _PlaybackTimeline(
            isPlaying: isPlaying,
            currentProgress: currentProgress,
            playbackSpeed: playbackSpeed,
            currentFrameIndex: currentFrameIndex,
            frameCount: frames.length,
            onPlayPause: _togglePlayPause,
            onSpeedSelected: _setPlaybackSpeed,
            onProgressChanged: _scrubProgress,
            onPreviousFrame: _previousFrame,
            onNextFrame: _nextFrame,
            onAddFrame: _addFrame,
            onDeleteFrame: deleteCurrentFrame,
          ),
          _PlayboardToolbar(
            canUndo: _undoStack.isNotEmpty,
            canRedo: _redoStack.isNotEmpty,
            is3v3Mode: is3v3Mode,
            selectedTool: selectedTool,
            onUndo: _undo,
            onRedo: _redo,
            onModeSelected: _set3v3Mode,
            onClear: _clear,
            onSelectTool: (tool) {
              setState(() {
                selectedTool = tool;
                _activeStroke = null;
                _draggingIndex = null;
                _draggingBall = false;
                _ballDragPosition = null;
              });
            },
          ),
        ],
      ),
    );
  }

  int get _visiblePlayerCount => is3v3Mode ? 3 : 5;

  List<DrawnLine> get drawnLines => frames[currentFrameIndex];

  bool get _isDrawing => selectedTool != DrawTool.move;

  LineType get _activeLineType {
    switch (selectedTool) {
      case DrawTool.run:
        return LineType.run;
      case DrawTool.pass:
        return LineType.pass;
      case DrawTool.screen:
        return LineType.screen;
      case DrawTool.shoot:
        return LineType.shoot;
      case DrawTool.move:
        return LineType.run;
    }
  }

  void _set3v3Mode(bool value) {
    setState(() {
      is3v3Mode = value;
      if (is3v3Mode && _draggingIndex != null && _draggingIndex! >= 3) {
        _draggingIndex = null;
        _dragOrigin = null;
      }
    });
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1200),
        ),
      );
  }

  static const _exportSnapPx = 40.0;

  Rect get _exportCourt =>
      _lastCourtRect ?? const Rect.fromLTWH(0, 0, 400, 752);

  List<List<double>> _offsetsToPath(List<Offset> points) {
    return points.map((point) => <double>[point.dx, point.dy]).toList();
  }

  ActionType _actionTypeFor(LineType type) {
    switch (type) {
      case LineType.run:
        return ActionType.run;
      case LineType.pass:
        return ActionType.pass;
      case LineType.screen:
        return ActionType.screen;
      case LineType.shoot:
        return ActionType.shoot;
    }
  }

  ResolvedBoard _baseBoard() {
    return ResolvedBoard(
      offense: _offense,
      defense: _defense,
      ballCarrierId: ballCarrierId,
      standaloneBallPosition: standaloneBallPosition,
    );
  }

  ResolvedBoard _resolveThrough(int exclusiveFrame, Rect court) {
    var state = _baseBoard();
    final end = exclusiveFrame.clamp(0, frames.length);
    for (var i = 0; i < end; i++) {
      state = applyFrameLines(
        start: state,
        lines: frames[i],
        court: court,
        visibleCount: _visiblePlayerCount,
      );
    }
    return state;
  }

  /// Offense 1–5, defense 11–15 (X1–X5).
  int? _nearestPlayer({
    required Offset startNormalized,
    required Set<int> claimed,
    required ResolvedBoard board,
    bool offenseOnly = false,
  }) {
    final court = _exportCourt;
    final start = CourtGeometry.normalizedToCanvas(startNormalized, court);
    int? bestId;
    var bestDistance = _exportSnapPx;

    void consider(List<Offset> nodes, int idOffset) {
      final count = math.min(nodes.length, 5);
      for (var i = 0; i < count; i++) {
        final playerId = idOffset + i;
        if (claimed.contains(playerId)) continue;
        final player = CourtGeometry.normalizedToCanvas(nodes[i], court);
        final distance = (player - start).distance;
        if (distance <= bestDistance) {
          bestDistance = distance;
          bestId = playerId;
        }
      }
    }

    consider(board.offense, 1);
    if (!offenseOnly) consider(board.defense, 11);
    return bestId;
  }

  List<PlayerAction> _formationActionsFrom(ResolvedBoard board) {
    final actions = <PlayerAction>[];
    for (var i = 0; i < board.offense.length; i++) {
      actions.add(
        PlayerAction(
          playerId: i + 1,
          actionType: ActionType.run,
          path: _offsetsToPath([board.offense[i]]),
        ),
      );
    }
    for (var i = 0; i < board.defense.length; i++) {
      actions.add(
        PlayerAction(
          playerId: 11 + i,
          actionType: ActionType.run,
          path: _offsetsToPath([board.defense[i]]),
        ),
      );
    }

    final ballPath = <Offset>[];
    if (board.ballCarrierId != null) {
      final index = board.ballCarrierId! - 1;
      if (index >= 0 && index < board.offense.length) {
        ballPath.add(board.offense[index]);
      }
    } else if (board.standaloneBallPosition != null) {
      ballPath.add(board.standaloneBallPosition!);
    }
    if (ballPath.isNotEmpty) {
      actions.add(
        PlayerAction(
          playerId: board.ballCarrierId ?? 0,
          actionType: ActionType.dribble,
          path: _offsetsToPath(ballPath),
          targetPlayerId: board.ballCarrierId,
        ),
      );
    }
    return actions;
  }

  List<PlayerAction> _drawnLineActionsFrom(
    List<DrawnLine> lines,
    ResolvedBoard board,
  ) {
    final actions = <PlayerAction>[];
    final claimedRuns = <int>{};

    for (final line in lines) {
      if (line.points.length < 2) continue;
      final type = _actionTypeFor(line.type);
      final offenseOnly =
          line.type == LineType.pass || line.type == LineType.shoot;
      var playerId = _nearestPlayer(
        startNormalized: line.points.first,
        claimed: line.type == LineType.run ? claimedRuns : <int>{},
        board: board,
        offenseOnly: offenseOnly,
      );

      if (playerId == null &&
          (line.type == LineType.pass || line.type == LineType.shoot)) {
        playerId = board.ballCarrierId;
      }
      if (playerId == null) continue;
      if (line.type == LineType.run) claimedRuns.add(playerId);

      int? targetPlayerId;
      if (line.type == LineType.pass) {
        targetPlayerId = _nearestPlayer(
          startNormalized: line.points.last,
          claimed: {playerId},
          board: board,
          offenseOnly: true,
        );
      }

      actions.add(
        PlayerAction(
          playerId: playerId,
          actionType: type,
          path: _offsetsToPath(line.points),
          targetPlayerId: targetPlayerId,
        ),
      );
    }
    return actions;
  }

  Playbook _buildPlaybook() {
    final court = _exportCourt;
    final steps = <PlayStep>[];
    for (var i = 0; i < frames.length; i++) {
      final start = _resolveThrough(i, court);
      steps.add(
        PlayStep(
          phaseId: i,
          actions: [
            ..._formationActionsFrom(start),
            ..._drawnLineActionsFrom(frames[i], start),
          ],
        ),
      );
    }
    return Playbook(playName: 'Playboard Export', steps: steps);
  }

  String exportToJson() {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(_buildPlaybook().toJson());
  }

  void _open3DPreview() {
    final json = exportToJson();
    debugPrint(json);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ThreeDView(playbookJson: json),
      ),
    );
  }

  Offset _attachedBallCanvas(Offset playerNormalized, Rect court, double radius) {
    final center = CourtGeometry.normalizedToCanvas(playerNormalized, court);
    return center + Offset(radius * 0.58, radius * 0.58);
  }

  Offset? _ballCanvasForHit(Rect court, double radius, ResolvedBoard board) {
    if (_draggingBall && _ballDragPosition != null) {
      return CourtGeometry.normalizedToCanvas(_ballDragPosition!, court);
    }
    if (board.ballCarrierId != null) {
      final index = board.ballCarrierId! - 1;
      if (index >= 0 && index < board.offense.length) {
        return _attachedBallCanvas(board.offense[index], court, radius);
      }
    }
    if (board.standaloneBallPosition != null) {
      return CourtGeometry.normalizedToCanvas(board.standaloneBallPosition!, court);
    }
    return null;
  }

  void _onPanStart(
    Offset local,
    Rect court,
    double radius,
    ResolvedBoard board,
  ) {
    if (_isDrawing) {
      if (!court.contains(local)) return;
      setState(() {
        _activeStroke = DrawnLine(
          points: [CourtGeometry.canvasToNormalized(local, court)],
          type: _activeLineType,
        );
        _draggingIndex = null;
        _draggingBall = false;
      });
      return;
    }

    int? hit;
    var defenseHit = false;
    var closest = radius * 1.2;

    void consider(List<Offset> nodes, bool defense) {
      final count = math.min(_visiblePlayerCount, nodes.length);
      for (var i = 0; i < count; i++) {
        final center = CourtGeometry.normalizedToCanvas(nodes[i], court);
        final distance = (local - center).distance;
        if (distance <= closest) {
          closest = distance;
          hit = i;
          defenseHit = defense;
        }
      }
    }

    consider(board.offense, false);
    consider(board.defense, true);

    final ballPos = _ballCanvasForHit(court, radius, board);
    const ballHitRadius = CourtGeometry.basketballHitRadius;
    final onPlayerBody = hit != null && closest <= radius * 0.55;
    final onBall =
        ballPos != null && (local - ballPos).distance <= ballHitRadius;
    if (onBall && !onPlayerBody) {
      setState(() {
        _draggingBall = true;
        _ballDragPosition = CourtGeometry.canvasToNormalized(local, court);
        _draggingIndex = null;
      });
      return;
    }

    setState(() {
      _draggingIndex = hit;
      _draggingDefense = defenseHit;
      _dragOrigin = hit == null ? null : _snapshot();
    });
  }

  void _onPanUpdate(Offset local, Rect court, double radius) {
    if (_isDrawing) {
      final stroke = _activeStroke;
      if (stroke == null) return;
      final point = CourtGeometry.canvasToNormalized(
        Offset(
          local.dx.clamp(court.left, court.right),
          local.dy.clamp(court.top, court.bottom),
        ),
        court,
      );
      setState(() => stroke.points.add(point));
      return;
    }

    if (_draggingBall) {
      final clamped = Offset(
        local.dx.clamp(court.left, court.right),
        local.dy.clamp(court.top, court.bottom),
      );
      setState(() {
        _ballDragPosition = CourtGeometry.canvasToNormalized(clamped, court);
      });
      return;
    }

    final index = _draggingIndex;
    if (index == null) return;
    if (is3v3Mode && index >= 3) return;

    final normalized = CourtGeometry.canvasToNormalized(local, court);
    final inset = radius / math.max(court.width, 1);
    final insetY = (radius + 14) / math.max(court.height, 1);
    final next = Offset(
      normalized.dx.clamp(inset, 1 - inset),
      normalized.dy.clamp(insetY, 1 - insetY),
    );

    setState(() {
      if (_draggingDefense) {
        _defense[index] = next;
      } else {
        _offense[index] = next;
      }
    });
  }

  void _onPanEnd(Rect court, ResolvedBoard board) {
    if (_isDrawing) {
      final stroke = _activeStroke;
      if (stroke != null && stroke.points.length >= 2) {
        setState(() {
          _undoStack.add(_snapshot());
          _redoStack.clear();
          drawnLines.add(stroke.copy());
          _activeStroke = null;
        });
      } else {
        setState(() => _activeStroke = null);
      }
      return;
    }

    if (_draggingBall) {
      final drop = _ballDragPosition;
      setState(() {
        if (drop != null) {
          final dropCanvas = CourtGeometry.normalizedToCanvas(drop, court);
          int? nearestId;
          var nearest = 40.0;
          final count = math.min(_visiblePlayerCount, board.offense.length);
          for (var i = 0; i < count; i++) {
            final player = CourtGeometry.normalizedToCanvas(board.offense[i], court);
            final distance = (dropCanvas - player).distance;
            if (distance <= nearest) {
              nearest = distance;
              nearestId = i + 1;
            }
          }
          if (nearestId != null) {
            ballCarrierId = nearestId;
            standaloneBallPosition = null;
          } else {
            ballCarrierId = null;
            standaloneBallPosition = drop;
          }
        }
        _draggingBall = false;
        _ballDragPosition = null;
      });
      return;
    }

    final origin = _dragOrigin;
    final index = _draggingIndex;
    if (origin != null && index != null) {
      final current = _draggingDefense ? _defense[index] : _offense[index];
      final previous = _draggingDefense ? origin.defense[index] : origin.offense[index];
      if (current != previous) {
        _undoStack.add(origin);
        _redoStack.clear();
      }
    }
    setState(() {
      _draggingIndex = null;
      _dragOrigin = null;
    });
  }

  _BoardSnapshot _snapshot() {
    return _BoardSnapshot(
      offense: List<Offset>.from(_offense),
      defense: List<Offset>.from(_defense),
      lines: drawnLines.map((line) => line.copy()).toList(),
    );
  }

  void _restore(_BoardSnapshot snapshot) {
    _offense
      ..clear()
      ..addAll(snapshot.offense);
    _defense
      ..clear()
      ..addAll(snapshot.defense);
    drawnLines
      ..clear()
      ..addAll(snapshot.lines.map((line) => line.copy()));
  }

  void _undo() {
    if (_undoStack.isEmpty) return;
    setState(() {
      _redoStack.add(_snapshot());
      _restore(_undoStack.removeLast());
    });
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    setState(() {
      _undoStack.add(_snapshot());
      _restore(_redoStack.removeLast());
    });
  }

  void _clear() {
    if (drawnLines.isEmpty && _activeStroke == null) return;
    setState(() {
      _undoStack.add(_snapshot());
      _redoStack.clear();
      frames[currentFrameIndex].clear();
      _activeStroke = null;
    });
  }

  void _resetPlayback() {
    _playbackController.stop();
    _playbackController.value = 0;
    currentProgress = 0;
    isPlaying = false;
    _activeStroke = null;
    _undoStack.clear();
    _redoStack.clear();
  }

  void _previousFrame() {
    if (currentFrameIndex <= 0) return;
    setState(() {
      currentFrameIndex -= 1;
      _resetPlayback();
    });
  }

  void _nextFrame() {
    if (currentFrameIndex >= frames.length - 1) return;
    setState(() {
      currentFrameIndex += 1;
      _resetPlayback();
    });
  }

  void _addFrame() {
    setState(() {
      frames.add([]);
      currentFrameIndex = frames.length - 1;
      _resetPlayback();
    });
  }

  void deleteCurrentFrame() {
    setState(() {
      if (frames.length > 1) {
        frames.removeAt(currentFrameIndex);
        if (currentFrameIndex >= frames.length) {
          currentFrameIndex = frames.length - 1;
        }
      } else {
        frames[0].clear();
      }
      _resetPlayback();
    });
  }
}

class _BoardSnapshot {
  const _BoardSnapshot({
    required this.offense,
    required this.defense,
    required this.lines,
  });

  final List<Offset> offense;
  final List<Offset> defense;
  final List<DrawnLine> lines;
}

class _PlaybackTimeline extends StatelessWidget {
  const _PlaybackTimeline({
    required this.isPlaying,
    required this.currentProgress,
    required this.playbackSpeed,
    required this.currentFrameIndex,
    required this.frameCount,
    required this.onPlayPause,
    required this.onSpeedSelected,
    required this.onProgressChanged,
    required this.onPreviousFrame,
    required this.onNextFrame,
    required this.onAddFrame,
    required this.onDeleteFrame,
  });

  final bool isPlaying;
  final double currentProgress;
  final double playbackSpeed;
  final int currentFrameIndex;
  final int frameCount;
  final VoidCallback onPlayPause;
  final ValueChanged<double> onSpeedSelected;
  final ValueChanged<double> onProgressChanged;
  final VoidCallback onPreviousFrame;
  final VoidCallback onNextFrame;
  final VoidCallback onAddFrame;
  final VoidCallback onDeleteFrame;

  static const _durationSeconds = 5.0;
  static const _speeds = [0.5, 1.0, 2.0];

  static String _speedLabel(double speed) {
    if (speed == 0.5) return '0.5x';
    if (speed == 1.0) return '1x';
    if (speed == 2.0) return '2x';
    return '${speed}x';
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = (currentProgress * _durationSeconds).toStringAsFixed(1);
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0C1018),
        border: Border(
          top: BorderSide(color: Color(0x22FFFFFF)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 14, 8),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: const Color(0xFFE86100),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onPlayPause,
                  child: SizedBox(
                    width: 42,
                    height: 42,
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              for (final speed in _speeds) ...[
                _SpeedChip(
                  label: _speedLabel(speed),
                  selected: playbackSpeed == speed,
                  onTap: () => onSpeedSelected(speed),
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                    activeTrackColor: const Color(0xFFE86100),
                    inactiveTrackColor: Colors.white24,
                    thumbColor: const Color(0xFFE86100),
                    overlayColor: const Color(0x33E86100),
                  ),
                  child: Slider(
                    min: 0,
                    max: 1,
                    value: currentProgress.clamp(0.0, 1.0),
                    onChanged: onProgressChanged,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 78,
                child: Text(
                  '${elapsed}s / ${_durationSeconds.toStringAsFixed(1)}s',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    fontFeatures: [ui.FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              IconButton(
                tooltip: 'Previous Frame',
                onPressed: currentFrameIndex > 0 ? onPreviousFrame : null,
                color: Colors.white,
                disabledColor: Colors.white24,
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  'Step ${currentFrameIndex + 1}/$frameCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Next Frame',
                onPressed: currentFrameIndex < frameCount - 1 ? onNextFrame : null,
                color: Colors.white,
                disabledColor: Colors.white24,
                icon: const Icon(Icons.chevron_right),
              ),
              IconButton(
                tooltip: 'Add Step',
                onPressed: onAddFrame,
                color: const Color(0xFFE86100),
                icon: const Icon(Icons.add),
              ),
              IconButton(
                tooltip: 'Delete Step',
                onPressed: onDeleteFrame,
                color: const Color(0xFFE57373),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpeedChip extends StatelessWidget {
  const _SpeedChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFE86100) : const Color(0x22FFFFFF),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayboardToolbar extends StatelessWidget {
  const _PlayboardToolbar({
    required this.canUndo,
    required this.canRedo,
    required this.is3v3Mode,
    required this.selectedTool,
    required this.onUndo,
    required this.onRedo,
    required this.onModeSelected,
    required this.onClear,
    required this.onSelectTool,
  });

  final bool canUndo;
  final bool canRedo;
  final bool is3v3Mode;
  final DrawTool selectedTool;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final ValueChanged<bool> onModeSelected;
  final VoidCallback onClear;
  final ValueChanged<DrawTool> onSelectTool;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xD6121824),
            border: Border(
              top: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ToolButton(
                        icon: Icons.undo_rounded,
                        label: 'Undo',
                        onPressed: canUndo ? onUndo : null,
                      ),
                      _ToolButton(
                        icon: Icons.redo_rounded,
                        label: 'Redo',
                        onPressed: canRedo ? onRedo : null,
                      ),
                      _ModeMenuButton(
                        is3v3Mode: is3v3Mode,
                        onSelected: onModeSelected,
                      ),
                      _ToolButton(
                        icon: Icons.delete_outline_rounded,
                        label: 'Clear',
                        onPressed: onClear,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ToolButton(
                        icon: Icons.open_with_rounded,
                        label: 'Move',
                        selected: selectedTool == DrawTool.move,
                        onPressed: () => onSelectTool(DrawTool.move),
                      ),
                      _ToolButton(
                        icon: Icons.directions_run_rounded,
                        label: 'Run',
                        accent: const Color(0xFFE23B2F),
                        selected: selectedTool == DrawTool.run,
                        onPressed: () => onSelectTool(DrawTool.run),
                      ),
                      _ToolButton(
                        icon: Icons.swap_horiz_rounded,
                        label: 'Pass',
                        accent: const Color(0xFF4DA3FF),
                        selected: selectedTool == DrawTool.pass,
                        onPressed: () => onSelectTool(DrawTool.pass),
                      ),
                      _ToolButton(
                        icon: Icons.horizontal_rule_rounded,
                        label: 'Screen',
                        accent: const Color(0xFFD8D8D8),
                        selected: selectedTool == DrawTool.screen,
                        onPressed: () => onSelectTool(DrawTool.screen),
                      ),
                      _ToolButton(
                        icon: Icons.sports_basketball,
                        label: '射波',
                        accent: const Color(0xFFF26A21),
                        selected: selectedTool == DrawTool.shoot,
                        onPressed: () => onSelectTool(DrawTool.shoot),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeMenuButton extends StatelessWidget {
  const _ModeMenuButton({
    required this.is3v3Mode,
    required this.onSelected,
  });

  final bool is3v3Mode;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final current = is3v3Mode ? '3v3' : '5v5';
    const itemStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    );

    return PopupMenuButton<bool>(
      tooltip: 'Player mode',
      offset: const Offset(0, -118),
      color: const Color(0xFF1C2430),
      initialValue: is3v3Mode,
      onSelected: onSelected,
      itemBuilder: (context) => [
        const PopupMenuItem<bool>(
          value: false,
          child: Text('5v5', style: itemStyle),
        ),
        const PopupMenuItem<bool>(
          value: true,
          child: Text('3v3', style: itemStyle),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              current,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            const Icon(
              Icons.arrow_drop_up,
              color: Colors.white,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.accent,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final base = accent ?? Colors.white;
    final color = selected
        ? base
        : base.withValues(alpha: enabled ? (accent == null ? 0.92 : 0.78) : 0.28);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? base.withValues(alpha: 0.16) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourtPainter extends CustomPainter {
  CourtPainter({
    required this.courtRect,
    required this.offense,
    required this.defense,
    required this.drawnLines,
    required this.playerRadius,
    this.activeStroke,
    this.draggingIndex,
    this.draggingDefense = false,
    this.is3v3Mode = false,
    this.currentProgress = 0.0,
    this.ballCarrierId,
    this.standaloneBallPosition,
    this.draggingBall = false,
    this.ballDragPosition,
  });

  final Rect courtRect;
  final List<Offset> offense;
  final List<Offset> defense;
  final List<DrawnLine> drawnLines;
  final DrawnLine? activeStroke;
  final double playerRadius;
  final int? draggingIndex;
  final bool draggingDefense;
  final bool is3v3Mode;
  final double currentProgress;
  final int? ballCarrierId;
  final Offset? standaloneBallPosition;
  final bool draggingBall;
  final Offset? ballDragPosition;

  Map<int, List<Offset>> _offensePaths = const {};
  Map<int, List<Offset>> _defensePaths = const {};

  /// Exposed for widget tests that still read `players` as offense.
  List<Offset> get players => offense;

  static const _woodLight = Color(0xFFE6B77C);
  static const _woodDark = Color(0xFFD7A266);
  static const _lane = Color(0xFF1A2B4C);
  static const _line = Color(0xFFFFFFFF);
  static const _offenseFill = Color(0xFFE23B2F);
  static const _defenseFill = Color(0xFF2F3E52);
  static const _runColor = Color(0xFFE23B2F);
  static const _passColor = Color(0xFF4DA3FF);
  static const _screenColor = Color(0xFFE6E6E6);
  static const _shootColor = Color(0xFFF26A21);

  double get _scale => CourtGeometry.scale(courtRect);

  @override
  void paint(Canvas canvas, Size size) {
    if (courtRect.width <= 0 || courtRect.height <= 0) return;

    final lineWidth = (_scale * 0.22).clamp(1.6, 2.8);

    _drawFloor(canvas);
    _drawLane(canvas, top: true);
    _drawLane(canvas, top: false);
    _drawMarkings(canvas, lineWidth);
    _drawStrokes(canvas);
    _offensePaths = _assignPaths(defenseTeam: false);
    _defensePaths = _assignPaths(defenseTeam: true);
    _drawOffense(canvas);
    _drawDefense(canvas);
    _drawBasketball(canvas);
  }

  void _drawFloor(Canvas canvas) {
    const plankCount = 12;
    final plankWidth = courtRect.width / plankCount;
    for (var i = 0; i < plankCount; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          courtRect.left + i * plankWidth,
          courtRect.top,
          plankWidth + 0.5,
          courtRect.height,
        ),
        Paint()..color = i.isEven ? _woodLight : _woodDark,
      );
    }

    canvas.drawRect(
      courtRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.08),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.10),
          ],
        ).createShader(courtRect),
    );
  }

  void _drawLane(Canvas canvas, {required bool top}) {
    final laneLeft = (CourtGeometry.widthFeet - CourtGeometry.laneWidth) / 2;
    final y0 = top ? 0.0 : CourtGeometry.lengthFeet;
    final y1 = _fromBaseline(CourtGeometry.freeThrowLineFromBaseline, top: top);
    canvas.drawRect(
      Rect.fromPoints(
        _ft(laneLeft, y0),
        _ft(laneLeft + CourtGeometry.laneWidth, y1),
      ),
      Paint()..color = _lane,
    );
  }

  void _drawMarkings(Canvas canvas, double lineWidth) {
    final paint = Paint()
      ..color = _line
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawRect(courtRect, paint);

    canvas.drawLine(
      _ft(0, CourtGeometry.lengthFeet / 2),
      _ft(CourtGeometry.widthFeet, CourtGeometry.lengthFeet / 2),
      paint,
    );
    canvas.drawCircle(
      _ft(CourtGeometry.widthFeet / 2, CourtGeometry.lengthFeet / 2),
      CourtGeometry.centerCircleRadius * _scale,
      paint,
    );

    _drawBasket(canvas, paint, lineWidth, top: true);
    _drawBasket(canvas, paint, lineWidth, top: false);
  }

  void _drawBasket(Canvas canvas, Paint paint, double lineWidth, {required bool top}) {
    final hoop = _ft(
      CourtGeometry.widthFeet / 2,
      _fromBaseline(CourtGeometry.hoopFromBaseline, top: top),
    );
    final laneLeft = (CourtGeometry.widthFeet - CourtGeometry.laneWidth) / 2;
    final y0 = top ? 0.0 : CourtGeometry.lengthFeet;
    final ftY = _fromBaseline(CourtGeometry.freeThrowLineFromBaseline, top: top);

    canvas.drawRect(
      Rect.fromPoints(
        _ft(laneLeft, y0),
        _ft(laneLeft + CourtGeometry.laneWidth, ftY),
      ),
      paint,
    );

    canvas.drawCircle(
      _ft(CourtGeometry.widthFeet / 2, ftY),
      CourtGeometry.freeThrowRadius * _scale,
      paint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: hoop, radius: CourtGeometry.restrictedRadius * _scale),
      top ? 0 : math.pi,
      math.pi,
      false,
      paint,
    );

    canvas.drawPath(_threePointPath(top: top), paint);

    final boardY = _fromBaseline(CourtGeometry.backboardFromBaseline, top: top);
    final boardHalf = CourtGeometry.backboardWidth / 2;
    canvas.drawLine(
      _ft(CourtGeometry.widthFeet / 2 - boardHalf, boardY),
      _ft(CourtGeometry.widthFeet / 2 + boardHalf, boardY),
      Paint()
        ..color = _line
        ..strokeWidth = lineWidth * 1.6
        ..strokeCap = StrokeCap.round,
    );

    final rimRadius = CourtGeometry.hoopRadius * _scale;
    canvas.drawCircle(hoop, rimRadius, paint);
    final rimJoin = top ? hoop.dy - rimRadius : hoop.dy + rimRadius;
    canvas.drawLine(
      _ft(CourtGeometry.widthFeet / 2, boardY),
      Offset(hoop.dx, rimJoin),
      paint,
    );
  }

  Path _threePointPath({required bool top}) {
    final leftX = CourtGeometry.cornerThreeFromSideline;
    final rightX = CourtGeometry.widthFeet - CourtGeometry.cornerThreeFromSideline;
    final hoopX = CourtGeometry.widthFeet / 2;
    final hoopY = _fromBaseline(CourtGeometry.hoopFromBaseline, top: top);
    final radius = CourtGeometry.threePointRadius;
    final dx = hoopX - leftX;
    final cornerOffsetY = math.sqrt(radius * radius - dx * dx);
    final sign = top ? 1.0 : -1.0;
    final cornerY = hoopY + sign * cornerOffsetY;
    final baselineY = top ? 0.0 : CourtGeometry.lengthFeet;
    final leftAngle = math.atan2(sign * cornerOffsetY, -dx);
    final rightAngle = math.atan2(sign * cornerOffsetY, dx);

    final path = Path()
      ..moveTo(_ft(leftX, baselineY).dx, _ft(leftX, baselineY).dy)
      ..lineTo(_ft(leftX, cornerY).dx, _ft(leftX, cornerY).dy);

    const steps = 56;
    for (var i = 1; i <= steps; i++) {
      final t = i / steps;
      final angle = leftAngle + (rightAngle - leftAngle) * t;
      final point = _ft(
        hoopX + radius * math.cos(angle),
        hoopY + radius * math.sin(angle),
      );
      path.lineTo(point.dx, point.dy);
    }
    path.lineTo(_ft(rightX, baselineY).dx, _ft(rightX, baselineY).dy);
    return path;
  }

  void _drawStrokes(Canvas canvas) {
    for (final line in drawnLines) {
      _drawSemanticLine(canvas, line);
    }
    if (activeStroke != null) {
      _drawSemanticLine(canvas, activeStroke!);
    }
  }

  void _drawSemanticLine(Canvas canvas, DrawnLine line) {
    if (line.points.length < 2) return;
    final points = [
      for (final point in line.points)
        CourtGeometry.normalizedToCanvas(point, courtRect),
    ];
    final color = switch (line.type) {
      LineType.run => _runColor,
      LineType.pass => _passColor,
      LineType.screen => _screenColor,
      LineType.shoot => _shootColor,
    };
    final dashed = line.type == LineType.pass || line.type == LineType.shoot;
    final paint = Paint()
      ..color = color.withValues(alpha: dashed ? 0.48 : 0.72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = dashed ? 1.5 : 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    if (dashed) {
      _drawDashedPolyline(canvas, points, paint);
    } else {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, paint);
    }

    final tip = _strokeTip(points);
    if (tip == null) return;
    if (line.type == LineType.screen) {
      _drawScreenTee(canvas, tip.$1, tip.$2, paint);
    } else {
      _drawArrowhead(canvas, tip.$1, tip.$2, paint.color);
    }
  }

  (Offset, Offset)? _strokeTip(List<Offset> points) {
    for (var i = points.length - 1; i > 0; i--) {
      if ((points[i] - points[i - 1]).distance > 1.5) {
        return (points[i - 1], points[i]);
      }
    }
    return null;
  }

  void _drawDashedPolyline(Canvas canvas, List<Offset> points, Paint paint) {
    const dash = 6.0;
    const gap = 4.5;
    var drawing = true;
    var remaining = dash;
    for (var i = 1; i < points.length; i++) {
      var start = points[i - 1];
      final end = points[i];
      var segment = end - start;
      var distance = segment.distance;
      if (distance < 0.5) continue;
      while (distance > 0) {
        final step = math.min(remaining, distance);
        final direction = (end - start) / (end - start).distance;
        final next = start + direction * step;
        if (drawing) {
          canvas.drawLine(start, next, paint);
        }
        start = next;
        distance -= step;
        remaining -= step;
        if (remaining <= 0.01) {
          drawing = !drawing;
          remaining = drawing ? dash : gap;
        }
      }
    }
  }

  void _drawArrowhead(Canvas canvas, Offset from, Offset to, Color color) {
    final delta = to - from;
    if (delta.distance < 1) return;
    final angle = math.atan2(delta.dy, delta.dx);
    const size = 8.0;
    const spread = 0.5;
    final path = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(
        to.dx - size * math.cos(angle - spread),
        to.dy - size * math.sin(angle - spread),
      )
      ..lineTo(
        to.dx - size * math.cos(angle + spread),
        to.dy - size * math.sin(angle + spread),
      )
      ..close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  void _drawScreenTee(Canvas canvas, Offset from, Offset to, Paint paint) {
    final delta = to - from;
    if (delta.distance < 1) return;
    final direction = delta / delta.distance;
    final perp = Offset(-direction.dy, direction.dx);
    const half = 8.0;
    canvas.drawLine(to - perp * half, to + perp * half, paint);
  }

  int get _visiblePlayerCount => is3v3Mode ? 3 : 5;

  Map<int, List<Offset>> _assignPaths({required bool defenseTeam}) {
    final assigned = assignMovingPaths(
      lines: drawnLines,
      offense: offense,
      defense: defense,
      court: courtRect,
      visibleCount: _visiblePlayerCount,
    );
    return defenseTeam ? assigned.defense : assigned.offense;
  }

  Offset _displayPosition(Offset base, int index, {required bool defense}) {
    if (currentProgress <= 0) return base;
    final path = (defense ? _defensePaths : _offensePaths)[index];
    if (path == null) return base;
    return getPositionAlongPath(path, playbackEase(currentProgress));
  }

  DrawnLine? _carrierFlightLine() {
    if (ballCarrierId == null) return null;
    final index = ballCarrierId! - 1;
    if (index < 0 || index >= offense.length) return null;
    final carrier = CourtGeometry.normalizedToCanvas(offense[index], courtRect);
    DrawnLine? best;
    var bestDistance = pathSnapRadius;
    for (final line in drawnLines) {
      if ((line.type != LineType.pass && line.type != LineType.shoot) ||
          line.points.length < 2) {
        continue;
      }
      final start = CourtGeometry.normalizedToCanvas(line.points.first, courtRect);
      final distance = (start - carrier).distance;
      if (distance <= bestDistance) {
        bestDistance = distance;
        best = line;
      }
    }
    return best;
  }

  Offset? _ballCanvasPosition() {
    if (draggingBall && ballDragPosition != null) {
      return CourtGeometry.normalizedToCanvas(ballDragPosition!, courtRect);
    }
    if (currentProgress > 0) {
      final flight = _carrierFlightLine();
      if (flight != null) {
        final t = flight.type == LineType.pass
            ? passFlight(currentProgress)
            : playbackEase(currentProgress);
        return CourtGeometry.normalizedToCanvas(
          getPositionAlongPath(flight.points, t),
          courtRect,
        );
      }
    }
    if (ballCarrierId != null) {
      final index = ballCarrierId! - 1;
      if (index >= 0 && index < offense.length) {
        final display = _displayPosition(offense[index], index, defense: false);
        final center = CourtGeometry.normalizedToCanvas(display, courtRect);
        return center + Offset(playerRadius * 0.58, playerRadius * 0.58);
      }
    }
    if (standaloneBallPosition != null) {
      return CourtGeometry.normalizedToCanvas(standaloneBallPosition!, courtRect);
    }
    return null;
  }

  void _drawBasketball(Canvas canvas) {
    final center = _ballCanvasPosition();
    if (center == null) return;
    const radius = CourtGeometry.basketballVisualRadius;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
    );
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFE86100));
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.55),
      -0.4,
      2.2,
      false,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  void _drawOffense(Canvas canvas) {
    final count = math.min(_visiblePlayerCount, offense.length);
    for (var i = 0; i < count; i++) {
      final selected = !draggingDefense && i == draggingIndex;
      final display = _displayPosition(offense[i], i, defense: false);
      final center = CourtGeometry.normalizedToCanvas(display, courtRect);
      final radius = selected ? playerRadius * 1.08 : playerRadius;
      final oval = Path()..addOval(Rect.fromCircle(center: center, radius: radius));

      canvas.drawShadow(oval, Colors.black, selected ? 10 : 6, false);
      canvas.drawPath(oval, Paint()..color = _offenseFill);
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2,
      );
      _drawCenteredText(
        canvas,
        '${i + 1}',
        center,
        fontSize: radius * 0.95,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        width: radius * 2,
      );
    }
  }

  void _drawDefense(Canvas canvas) {
    final count = math.min(_visiblePlayerCount, defense.length);
    for (var i = 0; i < count; i++) {
      final selected = draggingDefense && i == draggingIndex;
      final display = _displayPosition(defense[i], i, defense: true);
      final center = CourtGeometry.normalizedToCanvas(display, courtRect);
      final radius = selected ? playerRadius * 1.08 : playerRadius;
      final rect = Rect.fromCircle(center: center, radius: radius);
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius * 0.28));
      final path = Path()..addRRect(rrect);

      canvas.drawShadow(path, Colors.black, selected ? 10 : 6, false);
      canvas.drawPath(path, Paint()..color = _defenseFill);
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2,
      );
      _drawCenteredText(
        canvas,
        'X${i + 1}',
        center,
        fontSize: radius * 0.72,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        width: radius * 2,
      );
    }
  }

  void _drawCenteredText(
    Canvas canvas,
    String text,
    Offset center, {
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    required double width,
  }) {
    final builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    )
      ..pushStyle(ui.TextStyle(color: color))
      ..addText(text);
    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: width));
    canvas.drawParagraph(
      paragraph,
      Offset(center.dx - width / 2, center.dy - paragraph.height / 2),
    );
  }

  double _fromBaseline(double feet, {required bool top}) {
    return top ? feet : CourtGeometry.lengthFeet - feet;
  }

  Offset _ft(double xFeet, double yFeet) {
    return CourtGeometry.toCanvas(Offset(xFeet, yFeet), courtRect);
  }

  @override
  bool shouldRepaint(covariant CourtPainter oldDelegate) {
    return oldDelegate.courtRect != courtRect ||
        oldDelegate.playerRadius != playerRadius ||
        oldDelegate.draggingIndex != draggingIndex ||
        oldDelegate.draggingDefense != draggingDefense ||
        oldDelegate.activeStroke != activeStroke ||
        !_samePlayers(oldDelegate.offense, offense) ||
        !_samePlayers(oldDelegate.defense, defense) ||
        oldDelegate.drawnLines.length != drawnLines.length ||
        oldDelegate.is3v3Mode != is3v3Mode ||
        oldDelegate.currentProgress != currentProgress ||
        oldDelegate.ballCarrierId != ballCarrierId ||
        oldDelegate.standaloneBallPosition != standaloneBallPosition ||
        oldDelegate.draggingBall != draggingBall ||
        oldDelegate.ballDragPosition != ballDragPosition;
  }

  bool _samePlayers(List<Offset> a, List<Offset> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

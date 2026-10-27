import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooplab_3d/data/playbook_data.dart';
import 'package:hooplab_3d/main.dart';
import 'package:hooplab_3d/models/playbook_model.dart';
import 'package:hooplab_3d/models/playbook_models.dart';
import 'package:hooplab_3d/views/playboard_view.dart';
import 'package:hooplab_3d/views/three_d_view.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

Finder courtPaint() {
  return find.byWidgetPredicate(
    (widget) => widget is CustomPaint && widget.painter is CourtPainter,
  );
}

Future<void> openBoard(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.tap(find.text('畫板'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  test('playbook repository has ten playable plays per category', () {
    expect(PlaybookRepository.allPlays, hasLength(60));
    for (final category in PlaybookCategory.all) {
      final plays = PlaybookRepository.playsForCategory(category);
      expect(plays, hasLength(10), reason: category);
      final playbook = Playbook.fromJson(
        jsonDecode(plays.first.jsonData) as Map<String, dynamic>,
      );
      expect(playbook.steps.length, greaterThanOrEqualTo(2));
      expect(playbook.steps.first.actions, isNotEmpty);
    }
    final spain = convertGrokToAppJson('西班牙擋拆');
    expect(spain, isNotNull);
    final converted = Playbook.fromJson(
      jsonDecode(spain!) as Map<String, dynamic>,
    );
    expect(converted.steps, hasLength(3));
    final firstPath = converted.steps.first.actions
        .firstWhere((action) => action.playerId == 1 && action.actionType == ActionType.run)
        .path
        .first;
    expect(firstPath[0], closeTo((200 / 400.0) * 0.8 + 0.1, 0.0001));
    expect(firstPath[1], closeTo((320 / 400.0) * 0.40 + 0.06, 0.0001));
    expect(convertGrokToAppJson('不存在的戰術'), isNull);
  });

  test('getPositionAlongPath interpolates along polyline segments', () {
    const points = [Offset(0, 0), Offset(10, 0), Offset(10, 10)];
    expect(getPositionAlongPath(points, 0), const Offset(0, 0));
    expect(getPositionAlongPath(points, 1), const Offset(10, 10));
    expect(getPositionAlongPath(points, 0.25), const Offset(5, 0));
    expect(getPositionAlongPath(points, 0.5), const Offset(10, 0));
    expect(getPositionAlongPath(points, 0.75), const Offset(10, 5));
  });

  testWidgets('dashboard is the home tab', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('先選類型，再上場。'), findsOneWidget);
    expect(find.text('半場戰術'), findsOneWidget);
    expect(find.text('主頁'), findsOneWidget);
    expect(find.text('畫板'), findsOneWidget);
  });

  testWidgets('category grid opens ten plays and loads one onto the board', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('半場戰術'));
    await tester.pumpAndSettle();

    expect(find.text('西班牙擋拆'), findsOneWidget);
    expect(find.text('Spain Pick & Roll'), findsOneWidget);
    expect(find.text('Elevator Doors'), findsOneWidget);

    await tester.tap(find.text('西班牙擋拆'));
    await tester.pumpAndSettle();

    expect(find.text('Playboard'), findsWidgets);
    final painter = tester.widget<CustomPaint>(courtPaint()).painter! as CourtPainter;
    expect(painter.drawnLines, isNotEmpty);
    expect(painter.drawnLines.any((line) => line.type == LineType.run), isTrue);
  });

  testWidgets('dragging a player updates its stored position', (WidgetTester tester) async {
    await openBoard(tester);

    final paintFinder = courtPaint();
    final origin = tester.getTopLeft(paintFinder);
    final size = tester.getSize(paintFinder);
    final court = CourtGeometry.fitTo(size);
    const startNormalized = Offset(0.50, 0.42);
    final start = origin + CourtGeometry.normalizedToCanvas(startNormalized, court);

    await tester.dragFrom(start, const Offset(40, 60));
    await tester.pump();

    final painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    expect(painter.offense[0], isNot(startNormalized));
  });

  testWidgets('run tool captures a semantic stroke and clear removes it', (WidgetTester tester) async {
    await openBoard(tester);

    await tester.tap(find.text('Run'));
    await tester.pump();

    final paintFinder = courtPaint();
    var painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    final origin = tester.getTopLeft(paintFinder);
    final start = origin + CourtGeometry.normalizedToCanvas(
      const Offset(0.50, 0.55),
      painter.courtRect,
    );

    await tester.dragFrom(start, const Offset(80, 40));
    await tester.pump();

    painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    expect(painter.drawnLines, isNotEmpty);
    expect(painter.drawnLines.first.type, LineType.run);
    expect(painter.offense[0], const Offset(0.50, 0.42));

    await tester.tap(find.text('Clear'));
    await tester.pump();

    painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    expect(painter.drawnLines, isEmpty);
  });

  testWidgets('mode menu switches 3v3 and keeps hidden player positions', (WidgetTester tester) async {
    await openBoard(tester);

    expect(find.text('5v5'), findsOneWidget);
    var painter = tester.widget<CustomPaint>(courtPaint()).painter! as CourtPainter;
    expect(painter.is3v3Mode, isFalse);
    final savedFour = painter.offense[3];

    await tester.tap(find.byType(PopupMenuButton<bool>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('3v3').last);
    await tester.pumpAndSettle();

    expect(find.text('3v3'), findsOneWidget);
    painter = tester.widget<CustomPaint>(courtPaint()).painter! as CourtPainter;
    expect(painter.is3v3Mode, isTrue);
    expect(painter.offense[3], savedFour);

    await tester.tap(find.byType(PopupMenuButton<bool>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('5v5').last);
    await tester.pumpAndSettle();

    expect(find.text('5v5'), findsOneWidget);
    painter = tester.widget<CustomPaint>(courtPaint()).painter! as CourtPainter;
    expect(painter.is3v3Mode, isFalse);
    expect(painter.offense[3], savedFour);
  });

  testWidgets('playback timeline toggles play, speed, and progress', (WidgetTester tester) async {
    await openBoard(tester);

    expect(find.text('0.0s / 5.0s'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);

    await tester.tap(find.byIcon(Icons.play_arrow_rounded));
    await tester.pump();
    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);

    await tester.tap(find.text('2x'));
    await tester.pump();
    expect(find.text('2x'), findsOneWidget);

    await tester.drag(find.byType(Slider), const Offset(80, 0));
    await tester.pump();
    expect(find.text('0.0s / 5.0s'), findsNothing);
  });

  testWidgets('dropping the ball on empty court clears possession', (WidgetTester tester) async {
    await openBoard(tester);

    final paintFinder = courtPaint();
    var painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    expect(painter.ballCarrierId, 1);

    final origin = tester.getTopLeft(paintFinder);
    final court = painter.courtRect;
    final player = CourtGeometry.normalizedToCanvas(const Offset(0.50, 0.42), court);
    final ballStart = origin + player + Offset(painter.playerRadius * 0.58, painter.playerRadius * 0.58);

    await tester.dragFrom(ballStart, const Offset(-180, 160));
    await tester.pump();

    painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    expect(painter.ballCarrierId, isNull);
    expect(painter.standaloneBallPosition, isNotNull);
  });

  testWidgets('3D Preview pushes ThreeDView with playbook JSON', (WidgetTester tester) async {
    await openBoard(tester);

    await tester.tap(find.byTooltip('3D Preview'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ThreeDView), findsOneWidget);
    final view = tester.widget<ThreeDView>(find.byType(ThreeDView));
    expect(view.playbookJson, contains('"playName": "Playboard Export"'));
  });

  testWidgets('frame controls add steps and isolate drawings', (WidgetTester tester) async {
    await openBoard(tester);

    expect(find.text('Step 1/1'), findsOneWidget);

    await tester.tap(find.text('Run'));
    await tester.pump();
    final paintFinder = courtPaint();
    var painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    final origin = tester.getTopLeft(paintFinder);
    final start = origin + CourtGeometry.normalizedToCanvas(
      const Offset(0.50, 0.55),
      painter.courtRect,
    );
    await tester.dragFrom(start, const Offset(80, 40));
    await tester.pump();
    painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    expect(painter.drawnLines, isNotEmpty);

    await tester.tap(find.byTooltip('Add Step'));
    await tester.pump();
    expect(find.text('Step 2/2'), findsOneWidget);
    painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    expect(painter.drawnLines, isEmpty);

    await tester.tap(find.byTooltip('Previous Frame'));
    await tester.pump();
    expect(find.text('Step 1/2'), findsOneWidget);
    painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    expect(painter.drawnLines, isNotEmpty);

    await tester.tap(find.byTooltip('Next Frame'));
    await tester.pump();
    await tester.tap(find.byTooltip('Delete Step'));
    await tester.pump();
    expect(find.text('Step 1/1'), findsOneWidget);
    painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    expect(painter.drawnLines, isNotEmpty);
  });
}

class _FakeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return _FakeWebViewController(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return _FakeWebViewWidget(params);
  }

  @override
  PlatformWebViewCookieManager createPlatformCookieManager(
    PlatformWebViewCookieManagerCreationParams params,
  ) {
    return _FakeCookieManager(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return _FakeNavigationDelegate(params);
  }
}

class _FakeWebViewController extends PlatformWebViewController {
  _FakeWebViewController(super.params) : super.implementation();

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setOnConsoleMessage(
    void Function(JavaScriptConsoleMessage message) onConsoleMessage,
  ) async {}

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {}

  @override
  Future<void> loadFlutterAsset(String key) async {}

  @override
  Future<void> runJavaScript(String javaScript) async {}
}

class _FakeCookieManager extends PlatformWebViewCookieManager {
  _FakeCookieManager(super.params) : super.implementation();
}

class _FakeWebViewWidget extends PlatformWebViewWidget {
  _FakeWebViewWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}

class _FakeNavigationDelegate extends PlatformNavigationDelegate {
  _FakeNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {}
}

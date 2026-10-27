import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooplab_3d/data/launch_prefs.dart';
import 'package:hooplab_3d/data/local_playbook.dart';
import 'package:hooplab_3d/data/playbook_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({
      LaunchPrefs.seenOnboardingKey: true,
    });
    LaunchPrefs
      ..ready = true
      ..seenOnboarding = true;
    LocalPlaybook.instance
      ..ready = false
      ..plays = const [];
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  test('playbook repository has a coach starter pack', () {
    expect(
      PlaybookRepository.playsForCategory(PlaybookCategory.halfCourt).length,
      greaterThanOrEqualTo(14),
    );
    expect(
      PlaybookRepository.playsForCategory(PlaybookCategory.fastBreak).length,
      greaterThanOrEqualTo(8),
    );
    for (final category in [
      PlaybookCategory.inbound,
      PlaybookCategory.pressBreak,
      PlaybookCategory.lastFive,
      PlaybookCategory.defense,
    ]) {
      final plays = PlaybookRepository.playsForCategory(category);
      expect(plays, hasLength(10), reason: category);
      final playbook = Playbook.fromJson(
        jsonDecode(plays.first.jsonData) as Map<String, dynamic>,
      );
      expect(playbook.steps.length, greaterThanOrEqualTo(2));
      expect(playbook.steps.first.actions, isNotEmpty);
    }
    expect(PlaybookRepository.playsForCategory(PlaybookCategory.mine), isEmpty);
    final fast = Playbook.fromJson(
      jsonDecode(
        PlaybookRepository.playsForCategory(PlaybookCategory.fastBreak)
            .first
            .jsonData,
      ) as Map<String, dynamic>,
    );
    final ys = [
      for (final step in fast.steps)
        for (final action in step.actions)
          for (final point in action.path) point[1],
    ];
    expect(ys.any((y) => y > 0.7), isTrue);
    expect(ys.any((y) => y < 0.2), isTrue);
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
    expect(PlaybookRepository.featured?.title, '西班牙擋拆');
  });

  test('getPositionAlongPath interpolates along polyline segments', () {
    const points = [Offset(0, 0), Offset(10, 0), Offset(10, 10)];
    expect(getPositionAlongPath(points, 0), const Offset(0, 0));
    expect(getPositionAlongPath(points, 1), const Offset(10, 10));
    expect(getPositionAlongPath(points, 0.25), const Offset(5, 0));
    expect(getPositionAlongPath(points, 0.5), const Offset(10, 0));
    expect(getPositionAlongPath(points, 0.75), const Offset(10, 5));
  });

  test('playback eases in and out and a pass arrives before the jog', () {
    expect(playbackEase(0), 0);
    expect(playbackEase(1), 1);
    expect(playbackEase(0.5), 0.5);
    expect(playbackEase(0.25), lessThan(0.25));
    expect(playbackEase(0.75), greaterThan(0.75));
    expect(passFlight(0), 0);
    expect(passFlight(0.55), 1);
    expect(passFlight(1), 1);
    expect(passFlight(0.2), greaterThan(playbackEase(0.2)));
    const points = [Offset(0, 0), Offset(10, 0)];
    final eased = getPositionAlongPath(points, playbackEase(0.25));
    expect(eased.dx, greaterThan(0));
    expect(eased.dx, lessThan(2.5));
    final pass = getPositionAlongPath(points, passFlight(0.55));
    expect(pass.dx, 10);
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

    await tester.tap(find.byKey(const Key('chip-o-0')));
    await tester.pump();
    await tester.tapAt(start);
    await tester.pump();
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
    expect(painter.ballCarrierId, isNull);
    expect(painter.offenseOnCourt[0], isFalse);

    final origin = tester.getTopLeft(paintFinder);
    final court = painter.courtRect;
    final player = CourtGeometry.normalizedToCanvas(const Offset(0.50, 0.42), court);
    await tester.tap(find.byKey(const Key('chip-o-0')));
    await tester.pump();
    await tester.tapAt(origin + player);
    await tester.pump();
    await tester.tap(find.byKey(const Key('chip-ball')));
    await tester.pump();
    await tester.tapAt(origin + player);
    await tester.pump();
    painter = tester.widget<CustomPaint>(paintFinder).painter! as CourtPainter;
    expect(painter.ballCarrierId, 1);
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

  testWidgets('dock chip places a player and can be recalled', (tester) async {
    await openBoard(tester);
    expect(find.byTooltip('放上 1'), findsOneWidget);
    var painter = tester.widget<CustomPaint>(courtPaint()).painter! as CourtPainter;
    expect(painter.offenseOnCourt[0], isFalse);

    await tester.tap(find.byKey(const Key('chip-o-0')));
    await tester.pump();
    final origin = tester.getTopLeft(courtPaint());
    final spot = origin + CourtGeometry.normalizedToCanvas(
      const Offset(0.40, 0.50),
      painter.courtRect,
    );
    await tester.tapAt(spot);
    await tester.pump();

    painter = tester.widget<CustomPaint>(courtPaint()).painter! as CourtPainter;
    expect(painter.offenseOnCourt[0], isTrue);
    expect(find.byTooltip('收回 1'), findsOneWidget);

    await tester.tap(find.byKey(const Key('chip-o-0')));
    await tester.pump();
    painter = tester.widget<CustomPaint>(courtPaint()).painter! as CourtPainter;
    expect(painter.offenseOnCourt[0], isFalse);
  });

  testWidgets('saved plays can be renamed and deleted locally', (tester) async {
    await LocalPlaybook.instance.save(
      title: '測試進攻',
      jsonData: buildBasicTwoStepJson('測試進攻'),
    );
    await tester.pumpWidget(const MyApp());
    await tester.scrollUntilVisible(find.text('我的戰術'), 300);
    await tester.tap(find.text('我的戰術'));
    await tester.pumpAndSettle();
    expect(find.text('測試進攻'), findsOneWidget);
    expect(find.text('還沒有儲存的戰術'), findsNothing);

    await tester.tap(find.byTooltip('重新命名'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '改名進攻');
    await tester.tap(find.text('儲存'));
    await tester.pumpAndSettle();
    expect(find.text('改名進攻'), findsOneWidget);

    await tester.tap(find.byTooltip('刪除'));
    await tester.pumpAndSettle();
    expect(find.text('改名進攻'), findsNothing);
    expect(find.text('還沒有儲存的戰術'), findsOneWidget);
  });

  testWidgets('first open points at the featured play', (tester) async {
    SharedPreferences.setMockInitialValues({});
    LaunchPrefs
      ..ready = true
      ..seenOnboarding = false;
    await tester.pumpWidget(const MyApp());
    expect(find.text('30 秒上手'), findsOneWidget);

    await tester.tap(find.text('看西班牙擋拆'));
    await tester.pumpAndSettle();

    expect(LaunchPrefs.seenOnboarding, isTrue);
    expect(find.textContaining('西班牙擋拆。下一步：按 3D'), findsOneWidget);
    expect(find.byTooltip('3D Preview'), findsOneWidget);
    expect(find.byTooltip('分享影片'), findsOneWidget);
  });

  testWidgets('settings opens the local privacy policy', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('設定'));
    await tester.pumpAndSettle();
    expect(find.text(LaunchPrefs.supportEmail), findsOneWidget);
    await tester.tap(find.text('隱私權政策'));
    await tester.pumpAndSettle();
    expect(find.textContaining('不會上傳'), findsWidgets);
  });

  testWidgets('a named play keeps its title in the 3D export', (tester) async {
    final play = PlaybookRepository.featured!;
    await tester.pumpWidget(
      MaterialApp(
        home: PlayboardView(
          initialPlayData: play.jsonData,
          playTitle: play.title,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('3D Preview'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final view = tester.widget<ThreeDView>(find.byType(ThreeDView));
    expect(view.playTitle, '西班牙擋拆');
    expect(view.playbookJson, contains('"playName": "西班牙擋拆"'));
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

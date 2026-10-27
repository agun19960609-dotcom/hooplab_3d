import 'dart:convert';

import 'package:hooplab_3d/data/extra_plays.dart';
import 'package:hooplab_3d/models/playbook_model.dart';

part 'grok_half_court.dart';

class PlaybookRepository {
  static List<BasketballPlay> get allPlays => List<BasketballPlay>.unmodifiable(
        _plays,
      );

  static List<BasketballPlay> playsForCategory(String category) {
    return _plays.where((play) => play.category == category).toList();
  }
}

const _o1 = <double>[0.50, 0.42];
const _o2 = <double>[0.86, 0.30];
const _o3 = <double>[0.14, 0.30];
const _o4 = <double>[0.74, 0.18];
const _o5 = <double>[0.26, 0.18];
const _d1 = <double>[0.50, 0.33];
const _d2 = <double>[0.72, 0.24];
const _d3 = <double>[0.28, 0.24];
const _d4 = <double>[0.60, 0.10];
const _d5 = <double>[0.40, 0.10];
const _cut = <double>[0.70, 0.20];
const _rim = <double>[0.50, 0.06];

Map<String, dynamic> _action(
  int playerId,
  String actionType,
  List<List<double>> path, [
  int? targetPlayerId,
]) {
  return <String, dynamic>{
    'playerId': playerId,
    'actionType': actionType,
    'path': path,
    'targetPlayerId': targetPlayerId,
  };
}

List<Map<String, dynamic>> _formation() {
  return <Map<String, dynamic>>[
    _action(1, 'run', [_o1]),
    _action(2, 'run', [_o2]),
    _action(3, 'run', [_o3]),
    _action(4, 'run', [_o4]),
    _action(5, 'run', [_o5]),
    _action(11, 'run', [_d1]),
    _action(12, 'run', [_d2]),
    _action(13, 'run', [_d3]),
    _action(14, 'run', [_d4]),
    _action(15, 'run', [_d5]),
  ];
}

String buildBasicTwoStepJson(String playName) {
  return jsonEncode(<String, dynamic>{
    'playName': playName,
    'steps': <Map<String, dynamic>>[
      <String, dynamic>{
        'phaseId': 0,
        'actions': <Map<String, dynamic>>[
          ..._formation(),
          _action(1, 'dribble', [_o1], 1),
          _action(1, 'pass', [_o1, _o2], 2),
        ],
      },
      <String, dynamic>{
        'phaseId': 1,
        'actions': <Map<String, dynamic>>[
          ..._formation(),
          _action(2, 'dribble', [_o2], 2),
          _action(2, 'run', [_o2, _cut]),
          _action(2, 'shoot', [_cut, _rim]),
        ],
      },
    ],
  });
}

String _mapGrokActionType(String raw) {
  switch (raw) {
    case 'move':
      return 'run';
    default:
      return raw;
  }
}

List<List<double>> _normalizeGrokPath(dynamic path) {
  if (path is! List) return const [];
  final points = <List<double>>[];
  for (final point in path) {
    if (point is! Map) continue;
    final x = (point['x'] as num?)?.toDouble();
    final y = (point['y'] as num?)?.toDouble();
    if (x == null || y == null) continue;
    points.add(<double>[
      (x / 400.0) * 0.8 + 0.1,
      (y / 400.0) * 0.40 + 0.06,
    ]);
  }
  return points;
}

String? convertGrokToAppJson(String title) {
  try {
    final decoded = jsonDecode(_grokHalfCourtJson);
    if (decoded is! List) return null;
    Map<String, dynamic>? match;
    for (final item in decoded) {
      if (item is! Map) continue;
      final map = Map<String, dynamic>.from(item);
      if (map['title'] == title || map['englishTitle'] == title) {
        match = map;
        break;
      }
    }
    if (match == null) return null;

    final frames = match['frames'];
    if (frames is! List || frames.isEmpty) return null;

    final steps = <Map<String, dynamic>>[];
    for (var i = 0; i < frames.length; i++) {
      final frame = frames[i];
      if (frame is! Map) continue;
      final frameMap = Map<String, dynamic>.from(frame);
      final players = frameMap['players'];
      final actions = <Map<String, dynamic>>[];
      final carrier = (frameMap['ballCarrierId'] as num?)?.toInt();
      if (players is List) {
        for (final player in players) {
          if (player is! Map) continue;
          final id = (player['id'] as num?)?.toInt();
          if (id == null) continue;
          final path = _normalizeGrokPath(player['path']);
          if (path.isEmpty) continue;
          if (path.length > 1) {
            actions.add(_action(id, 'run', [path.first]));
          }
          actions.add(
            _action(
              id,
              _mapGrokActionType('${player['actionType'] ?? 'run'}'),
              path,
            ),
          );
        }
      }
      if (carrier != null && carrier > 0) {
        final hold = <List<double>>[];
        if (players is List) {
          for (final player in players) {
            if (player is! Map) continue;
            if ((player['id'] as num?)?.toInt() != carrier) continue;
            final path = _normalizeGrokPath(player['path']);
            if (path.isNotEmpty) hold.add(path.first);
          }
        }
        actions.add(
          _action(carrier, 'dribble', hold.isEmpty ? [_o1] : hold, carrier),
        );
      }
      steps.add(<String, dynamic>{
        'phaseId': i,
        'actions': actions,
      });
    }
    if (steps.isEmpty) return null;
    return jsonEncode(<String, dynamic>{
      'playName': match['englishTitle'] ?? match['title'] ?? title,
      'steps': steps,
    });
  } catch (_) {
    return null;
  }
}

BasketballPlay _play({
  required String id,
  required String category,
  required String title,
  required String englishTitle,
  required List<String> tags,
}) {
  return BasketballPlay(
    id: id,
    category: category,
    title: title,
    englishTitle: englishTitle,
    tags: tags,
    jsonData: extraPlayJson[id] ??
        convertGrokToAppJson(title) ??
        convertGrokToAppJson(englishTitle) ??
        buildBasicTwoStepJson(englishTitle),
  );
}

final List<BasketballPlay> _plays = <BasketballPlay>[
  _play(
    id: 'half-01',
    category: PlaybookCategory.halfCourt,
    title: '西班牙擋拆',
    englishTitle: 'Spain Pick & Roll',
    tags: const ['半場', '擋拆', '西班牙'],
  ),
  _play(
    id: 'half-02',
    category: PlaybookCategory.halfCourt,
    title: '牛角外彈',
    englishTitle: 'Horns Flare',
    tags: const ['半場', '牛角', '外彈'],
  ),
  _play(
    id: 'half-03',
    category: PlaybookCategory.halfCourt,
    title: '軟盤掩護',
    englishTitle: 'Floppy',
    tags: const ['半場', '軟盤', '掩護'],
  ),
  _play(
    id: 'half-04',
    category: PlaybookCategory.halfCourt,
    title: '電梯門',
    englishTitle: 'Elevator Doors',
    tags: const ['半場', '電梯門', '投籃'],
  ),
  _play(
    id: 'half-05',
    category: PlaybookCategory.halfCourt,
    title: '五外空手切',
    englishTitle: '5-Out Backdoor',
    tags: const ['半場', '五外', '空手切'],
  ),
  _play(
    id: 'half-06',
    category: PlaybookCategory.halfCourt,
    title: '側翼雙擋',
    englishTitle: 'Wing Double Screen',
    tags: const ['半場', '雙擋', '側翼'],
  ),
  _play(
    id: 'half-07',
    category: PlaybookCategory.halfCourt,
    title: '高位手遞手',
    englishTitle: 'High Handoff',
    tags: const ['半場', '手遞手', '高位'],
  ),
  _play(
    id: 'half-08',
    category: PlaybookCategory.halfCourt,
    title: '底角 trans 擋拆',
    englishTitle: 'Corner Pick & Roll',
    tags: const ['半場', '擋拆', '底角'],
  ),
  _play(
    id: 'half-09',
    category: PlaybookCategory.halfCourt,
    title: '箱形切入',
    englishTitle: 'Box Cut',
    tags: const ['半場', '箱形', '切入'],
  ),
  _play(
    id: 'half-10',
    category: PlaybookCategory.halfCourt,
    title: '弱側交叉掩護',
    englishTitle: 'Weak-side Cross Screen',
    tags: const ['半場', '交叉掩護', '弱側'],
  ),
  _play(
    id: 'half-11',
    category: PlaybookCategory.halfCourt,
    title: '牛角扭轉',
    englishTitle: 'Horns Twist',
    tags: const ['半場', '牛角', '錯位'],
  ),
  _play(
    id: 'half-12',
    category: PlaybookCategory.halfCourt,
    title: '側翼擋拆',
    englishTitle: 'Wing Pick & Roll',
    tags: const ['半場', '擋拆', '側翼'],
  ),
  _play(
    id: 'half-13',
    category: PlaybookCategory.halfCourt,
    title: 'UCLA 反跑',
    englishTitle: 'UCLA Cut',
    tags: const ['半場', 'UCLA', '切入'],
  ),
  _play(
    id: 'half-14',
    category: PlaybookCategory.halfCourt,
    title: '下沉掩護',
    englishTitle: 'Pin Down',
    tags: const ['半場', '下沉', '外線'],
  ),
  _play(
    id: 'fast-01',
    category: PlaybookCategory.fastBreak,
    title: '兩人快攻',
    englishTitle: 'Two-Man Break',
    tags: const ['全場', '快攻', '人數'],
  ),
  _play(
    id: 'fast-02',
    category: PlaybookCategory.fastBreak,
    title: '三線快攻',
    englishTitle: 'Three-Lane Break',
    tags: const ['全場', '快攻', '三線'],
  ),
  _play(
    id: 'fast-03',
    category: PlaybookCategory.fastBreak,
    title: '長傳出口',
    englishTitle: 'Outlet Ahead',
    tags: const ['全場', '出口', '長傳'],
  ),
  _play(
    id: 'fast-04',
    category: PlaybookCategory.fastBreak,
    title: '籃下衝框',
    englishTitle: 'Rim Runner',
    tags: const ['全場', '快攻', '衝框'],
  ),
  _play(
    id: 'fast-05',
    category: PlaybookCategory.fastBreak,
    title: '邊線推進',
    englishTitle: 'Sideline Push',
    tags: const ['全場', '邊線', '推進'],
  ),
  _play(
    id: 'fast-06',
    category: PlaybookCategory.fastBreak,
    title: '拖後掩護',
    englishTitle: 'Trail Screen',
    tags: const ['全場', '掩護', '拖後'],
  ),
  _play(
    id: 'fast-07',
    category: PlaybookCategory.fastBreak,
    title: '提前擋拆',
    englishTitle: 'Early Drag',
    tags: const ['全場', '擋拆', '提前'],
  ),
  _play(
    id: 'fast-08',
    category: PlaybookCategory.fastBreak,
    title: '多打少分球',
    englishTitle: 'Numbers Kick',
    tags: const ['全場', '快攻', '分球'],
  ),
  _play(
    id: 'in-01',
    category: PlaybookCategory.inbound,
    title: '底線堆疊',
    englishTitle: 'Baseline Stack',
    tags: const ['BLOB', '堆疊', '底線'],
  ),
  _play(
    id: 'in-02',
    category: PlaybookCategory.inbound,
    title: '箱型底線',
    englishTitle: 'Box Baseline',
    tags: const ['BLOB', '箱型', '掩護'],
  ),
  _play(
    id: 'in-03',
    category: PlaybookCategory.inbound,
    title: '邊線牛角',
    englishTitle: 'Sideline Horns',
    tags: const ['SLOB', '牛角', '邊線'],
  ),
  _play(
    id: 'in-04',
    category: PlaybookCategory.inbound,
    title: 'Zipper 發球',
    englishTitle: 'Zipper Inbounds',
    tags: const ['Zipper', '上提', 'SLOB'],
  ),
  _play(
    id: 'in-05',
    category: PlaybookCategory.inbound,
    title: '直線底線',
    englishTitle: 'Line Baseline',
    tags: const ['BLOB', '直線', '切出'],
  ),
  _play(
    id: 'in-06',
    category: PlaybookCategory.inbound,
    title: 'UCLA 底線球',
    englishTitle: 'UCLA Cut BLOB',
    tags: const ['UCLA', '反跑', 'BLOB'],
  ),
  _play(
    id: 'in-07',
    category: PlaybookCategory.inbound,
    title: 'Rip 邊線',
    englishTitle: 'Rip SLOB',
    tags: const ['SLOB', 'Rip', '拉開'],
  ),
  _play(
    id: 'in-08',
    category: PlaybookCategory.inbound,
    title: '堆疊電梯',
    englishTitle: 'Stack Elevator',
    tags: const ['電梯門', '堆疊', '外線'],
  ),
  _play(
    id: 'in-09',
    category: PlaybookCategory.inbound,
    title: '菱形底線',
    englishTitle: 'Diamond BLOB',
    tags: const ['BLOB', '菱形', '錯位'],
  ),
  _play(
    id: 'in-10',
    category: PlaybookCategory.inbound,
    title: 'Flex 邊線',
    englishTitle: 'Flex Sideline',
    tags: const ['Flex', 'SLOB', '下掩'],
  ),
  _play(
    id: 'press-01',
    category: PlaybookCategory.pressBreak,
    title: '1-4 破緊迫',
    englishTitle: '1-4 Press Break',
    tags: const ['緊迫', '安全閥', '推進'],
  ),
  _play(
    id: 'press-02',
    category: PlaybookCategory.pressBreak,
    title: '中路推進',
    englishTitle: 'Middle Attack',
    tags: const ['中路', '破夾擊', '推進'],
  ),
  _play(
    id: 'press-03',
    category: PlaybookCategory.pressBreak,
    title: '邊線安全閥',
    englishTitle: 'Sideline Safety',
    tags: const ['邊線', '接應', '穩健'],
  ),
  _play(
    id: 'press-04',
    category: PlaybookCategory.pressBreak,
    title: '2-1-2 破緊迫',
    englishTitle: '2-1-2 Press Break',
    tags: const ['陣型', '全場', '傳導'],
  ),
  _play(
    id: 'press-05',
    category: PlaybookCategory.pressBreak,
    title: '反向轉移',
    englishTitle: 'Inversion',
    tags: const ['反向', '轉移', '拉開'],
  ),
  _play(
    id: 'press-06',
    category: PlaybookCategory.pressBreak,
    title: '菱形破緊迫',
    englishTitle: 'Diamond Press Break',
    tags: const ['菱形', '中路', '出口'],
  ),
  _play(
    id: 'press-07',
    category: PlaybookCategory.pressBreak,
    title: '攻擊夾擊',
    englishTitle: 'Attack the Trap',
    tags: const ['夾擊', '過頂傳', '快攻'],
  ),
  _play(
    id: 'press-08',
    category: PlaybookCategory.pressBreak,
    title: '反向接應',
    englishTitle: 'Reverse Outlet',
    tags: const ['接應', '反向', '安全'],
  ),
  _play(
    id: 'press-09',
    category: PlaybookCategory.pressBreak,
    title: '四人橫排',
    englishTitle: '4-Across',
    tags: const ['橫排', '發球', '全場'],
  ),
  _play(
    id: 'press-10',
    category: PlaybookCategory.pressBreak,
    title: '全場閃切',
    englishTitle: 'Full Court Flash',
    tags: const ['閃切', '長傳', '破緊迫'],
  ),
  _play(
    id: 'ato-01',
    category: PlaybookCategory.lastFive,
    title: 'Floppy 絕殺',
    englishTitle: 'Game Winner Floppy',
    tags: const ['最後一擊', 'Floppy', '外線'],
  ),
  _play(
    id: 'ato-02',
    category: PlaybookCategory.lastFive,
    title: '清空單打',
    englishTitle: 'Isolation Clear',
    tags: const ['ISO', '清空', '時計'],
  ),
  _play(
    id: 'ato-03',
    category: PlaybookCategory.lastFive,
    title: '底線蜂鳴器',
    englishTitle: 'BLOB Buzzer',
    tags: const ['BLOB', '蜂鳴器', '絕殺'],
  ),
  _play(
    id: 'ato-04',
    category: PlaybookCategory.lastFive,
    title: '邊線錘子',
    englishTitle: 'SLOB Hammer',
    tags: const ['SLOB', 'Hammer', '底角'],
  ),
  _play(
    id: 'ato-05',
    category: PlaybookCategory.lastFive,
    title: '弱邊掩護',
    englishTitle: 'Weak Side Screen',
    tags: const ['弱邊', '掩護', '錯位'],
  ),
  _play(
    id: 'ato-06',
    category: PlaybookCategory.lastFive,
    title: 'Iverson 絕殺',
    englishTitle: 'Iverson Buzzer',
    tags: const ['Iverson', '橫切', '最後一擊'],
  ),
  _play(
    id: 'ato-07',
    category: PlaybookCategory.lastFive,
    title: '牛角 STS',
    englishTitle: 'Horns STS',
    tags: const ['牛角', 'Screen the Screener', '外線'],
  ),
  _play(
    id: 'ato-08',
    category: PlaybookCategory.lastFive,
    title: '底角三分',
    englishTitle: 'Corner Three',
    tags: const ['底角', '三分', 'ATO'],
  ),
  _play(
    id: 'ato-09',
    category: PlaybookCategory.lastFive,
    title: 'Zipper 拉開',
    englishTitle: 'Zipper Fade',
    tags: const ['Zipper', 'Fade', '時計'],
  ),
  _play(
    id: 'ato-10',
    category: PlaybookCategory.lastFive,
    title: '手遞手絕殺',
    englishTitle: 'DHO Winner',
    tags: const ['手遞手', '絕殺', '錯位'],
  ),
  _play(
    id: 'def-01',
    category: PlaybookCategory.defense,
    title: '2-3 區域',
    englishTitle: '2-3 Zone',
    tags: const ['區域', '禁區', '基本'],
  ),
  _play(
    id: 'def-02',
    category: PlaybookCategory.defense,
    title: '3-2 區域',
    englishTitle: '3-2 Zone',
    tags: const ['區域', '外線', '干擾'],
  ),
  _play(
    id: 'def-03',
    category: PlaybookCategory.defense,
    title: '1-3-1 區域',
    englishTitle: '1-3-1 Zone',
    tags: const ['區域', '攔截', '傳導'],
  ),
  _play(
    id: 'def-04',
    category: PlaybookCategory.defense,
    title: '箱加一',
    englishTitle: 'Box and One',
    tags: const ['混合防守', '盯人', '球星'],
  ),
  _play(
    id: 'def-05',
    category: PlaybookCategory.defense,
    title: '三角加二',
    englishTitle: 'Triangle and Two',
    tags: const ['混合防守', '雙核', '區域'],
  ),
  _play(
    id: 'def-06',
    category: PlaybookCategory.defense,
    title: 'Ice 擋拆',
    englishTitle: 'Ice Pick & Roll',
    tags: const ['擋拆防守', 'Ice', '邊線'],
  ),
  _play(
    id: 'def-07',
    category: PlaybookCategory.defense,
    title: 'Blue 對位上提',
    englishTitle: 'Blue Hedge',
    tags: const ['擋拆防守', 'Hedge', '上提'],
  ),
  _play(
    id: 'def-08',
    category: PlaybookCategory.defense,
    title: '全換防',
    englishTitle: 'Switch Everything',
    tags: const ['換防', '換位', '現代'],
  ),
  _play(
    id: 'def-09',
    category: PlaybookCategory.defense,
    title: '沉退防守',
    englishTitle: 'Drop Coverage',
    tags: const ['擋拆防守', '沉退', '護框'],
  ),
  _play(
    id: 'def-10',
    category: PlaybookCategory.defense,
    title: '全場緊迫',
    englishTitle: 'Full Court Press',
    tags: const ['緊迫', '全場', '節奏'],
  ),
];

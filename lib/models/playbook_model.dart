class PlaybookCategory {
  static const halfCourt = '半場戰術';
  static const fastBreak = '全場快攻';
  static const inbound = '底線/邊線界外';
  static const pressBreak = '破緊迫';
  static const lastFive = '最後5秒';
  static const defense = '防守';
  static const mine = '我的戰術';

  static const all = <String>[
    halfCourt,
    fastBreak,
    inbound,
    pressBreak,
    lastFive,
    defense,
    mine,
  ];
}

class BasketballPlay {
  const BasketballPlay({
    required this.id,
    required this.category,
    required this.title,
    required this.englishTitle,
    required this.tags,
    required this.jsonData,
  });

  final String id;
  final String category;
  final String title;
  final String englishTitle;
  final List<String> tags;
  final String jsonData;
}

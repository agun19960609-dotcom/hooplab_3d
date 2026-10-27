import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooplab_3d/data/local_playbook.dart';
import 'package:hooplab_3d/data/playbook_data.dart';
import 'package:hooplab_3d/models/playbook_model.dart';
import 'package:hooplab_3d/views/play_list_view.dart';

class HomeDashboardView extends StatelessWidget {
  const HomeDashboardView({super.key});

  static const _categories = <_CategoryCardData>[
    _CategoryCardData(
      title: PlaybookCategory.halfCourt,
      icon: Icons.sports_basketball_rounded,
      color: Color(0xFFE86100),
    ),
    _CategoryCardData(
      title: PlaybookCategory.fastBreak,
      icon: Icons.speed_rounded,
      color: Color(0xFF7A4DFF),
    ),
    _CategoryCardData(
      title: PlaybookCategory.inbound,
      icon: Icons.swap_horiz_rounded,
      color: Color(0xFF2F80ED),
    ),
    _CategoryCardData(
      title: PlaybookCategory.pressBreak,
      icon: Icons.bolt_rounded,
      color: Color(0xFFE0A100),
    ),
    _CategoryCardData(
      title: PlaybookCategory.lastFive,
      icon: Icons.timer_rounded,
      color: Color(0xFFE23B2F),
    ),
    _CategoryCardData(
      title: PlaybookCategory.defense,
      icon: Icons.shield_rounded,
      color: Color(0xFF2E9B57),
    ),
    _CategoryCardData(
      title: PlaybookCategory.mine,
      icon: Icons.folder_special_rounded,
      color: Color(0xFF3A4454),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0E1116),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hooplab',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '先選類型，再上場。',
                style: GoogleFonts.notoSansTc(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth > 640;
                    return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: wide ? 2.05 : 1.08,
                      children: [
                        for (final category in _categories)
                          _CategoryCard(data: category),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCardData {
  const _CategoryCardData({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.data});

  final _CategoryCardData data;

  @override
  Widget build(BuildContext context) {
    if (data.title == PlaybookCategory.mine) {
      return _MineCategoryCard(data: data);
    }
    final count = PlaybookRepository.playsForCategory(data.title).length;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PlayListView(category: data.title),
            ),
          );
        },
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(data.color, Colors.white, 0.08)!,
                Color.lerp(data.color, Colors.black, 0.28)!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: data.color.withValues(alpha: 0.28),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 22),
                ),
                const Spacer(),
                Text(
                  data.title,
                  style: GoogleFonts.notoSansTc(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count 套',
                  style: GoogleFonts.notoSansTc(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MineCategoryCard extends StatefulWidget {
  const _MineCategoryCard({required this.data});

  final _CategoryCardData data;

  @override
  State<_MineCategoryCard> createState() => _MineCategoryCardState();
}

class _MineCategoryCardState extends State<_MineCategoryCard> {
  @override
  void initState() {
    super.initState();
    LocalPlaybook.instance.ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LocalPlaybook.instance,
      builder: (context, _) {
        final count = LocalPlaybook.instance.plays.length;
        final data = widget.data;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PlayListView(category: data.title),
                ),
              );
            },
            borderRadius: BorderRadius.circular(22),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(data.color, Colors.white, 0.08)!,
                    Color.lerp(data.color, Colors.black, 0.28)!,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.folder_special_rounded, color: Colors.white),
                    const Spacer(),
                    Text(
                      data.title,
                      style: GoogleFonts.notoSansTc(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$count 套',
                      style: GoogleFonts.notoSansTc(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooplab_3d/data/playbook_data.dart';
import 'package:hooplab_3d/models/playbook_model.dart';
import 'package:hooplab_3d/views/playboard_view.dart';

class PlayListView extends StatelessWidget {
  const PlayListView({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final plays = PlaybookRepository.playsForCategory(category);
    return Scaffold(
      backgroundColor: const Color(0xFF0E1116),
      appBar: AppBar(
        backgroundColor: const Color(0xFF12161E),
        foregroundColor: Colors.white,
        title: Text(
          category,
          style: GoogleFonts.notoSansTc(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: plays.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return _PlayCard(play: plays[index]);
        },
      ),
    );
  }
}

class _PlayCard extends StatelessWidget {
  const _PlayCard({required this.play});

  final BasketballPlay play;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF171C26),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PlayboardView(initialPlayData: play.jsonData),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                play.title,
                style: GoogleFonts.notoSansTc(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                play.englishTitle,
                style: const TextStyle(
                  color: Color(0xFFB8C0CC),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final tag in play.tags)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE86100).withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.notoSansTc(
                          color: const Color(0xFFFFB074),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

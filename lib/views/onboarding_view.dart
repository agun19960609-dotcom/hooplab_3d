import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooplab_3d/theme/hooplab_theme.dart';

class OnboardingCover extends StatelessWidget {
  const OnboardingCover({
    super.key,
    required this.onStart,
    required this.onSkip,
  });

  final VoidCallback onStart;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: HooplabColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HOOPLAB',
                style: GoogleFonts.notoSansTc(
                  color: HooplabColors.orange,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '30 秒上手',
                style: GoogleFonts.notoSansTc(
                  color: HooplabColors.text,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '不用長教學。照這三步看完一套。',
                style: GoogleFonts.notoSansTc(
                  color: HooplabColors.textMuted,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 28),
              const _Step(
                index: '1',
                title: '選示範戰術',
                body: '打開西班牙擋拆。',
              ),
              const _Step(
                index: '2',
                title: '看 3D',
                body: '按右上角 3D，會自己播放。',
              ),
              const _Step(
                index: '3',
                title: '分享影片',
                body: '按分享影片，用系統分享到 WhatsApp 或 IG。不用登入。',
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: onStart,
                  style: FilledButton.styleFrom(
                    backgroundColor: HooplabColors.orange,
                    foregroundColor: HooplabColors.text,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    '看西班牙擋拆',
                    style: GoogleFonts.notoSansTc(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: onSkip,
                  child: Text(
                    '先自己逛',
                    style: GoogleFonts.notoSansTc(
                      color: HooplabColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.index,
    required this.title,
    required this.body,
  });

  final String index;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: HooplabColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: HooplabColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HooplabColors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  index,
                  style: GoogleFonts.notoSansTc(
                    color: HooplabColors.text,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSansTc(
                        color: HooplabColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      body,
                      style: GoogleFonts.notoSansTc(
                        color: HooplabColors.textMuted,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooplab_3d/data/launch_prefs.dart';
import 'package:hooplab_3d/data/playbook_data.dart';
import 'package:hooplab_3d/theme/hooplab_theme.dart';
import 'package:hooplab_3d/views/home_dashboard_view.dart';
import 'package:hooplab_3d/views/onboarding_view.dart';
import 'package:hooplab_3d/views/playboard_view.dart';
import 'package:hooplab_3d/views/saved_plays_view.dart';
import 'package:hooplab_3d/views/settings_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  static const _pages = <Widget>[
    HomeDashboardView(),
    const SavedPlaysView(),
    PlayboardView(),
    SettingsView(),
  ];

  Future<void> _dismissOnboarding({required bool openFeatured}) async {
    await LaunchPrefs.markOnboardingSeen();
    if (!mounted) return;
    setState(() {});
    if (!openFeatured) return;
    final play = PlaybookRepository.featured;
    if (play == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlayboardView(
          initialPlayData: play.jsonData,
          playTitle: play.title,
          launchHint: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: HooplabColors.background,
          body: IndexedStack(
            index: _index,
            children: _pages,
          ),
          bottomNavigationBar: DecoratedBox(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: HooplabColors.border)),
            ),
            child: BottomNavigationBar(
              currentIndex: _index,
              onTap: (index) => setState(() => _index = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: HooplabColors.bar,
              selectedItemColor: HooplabColors.orange,
              unselectedItemColor: HooplabColors.textMuted,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle: GoogleFonts.notoSansTc(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              unselectedLabelStyle: GoogleFonts.notoSansTc(fontSize: 12),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: '主頁',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined),
                  activeIcon: Icon(Icons.inventory_2_rounded),
                  label: '戰術庫',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.edit_outlined),
                  activeIcon: Icon(Icons.edit_rounded),
                  label: '畫板',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings_rounded),
                  label: '設定',
                ),
              ],
            ),
          ),
        ),
        if (!LaunchPrefs.seenOnboarding)
          OnboardingCover(
            onStart: () {
              _dismissOnboarding(openFeatured: true);
            },
            onSkip: () {
              _dismissOnboarding(openFeatured: false);
            },
          ),
      ],
    );
  }
}

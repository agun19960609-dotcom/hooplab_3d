import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooplab_3d/data/launch_prefs.dart';
import 'package:hooplab_3d/theme/hooplab_theme.dart';
import 'package:hooplab_3d/views/privacy_policy_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: HooplabColors.background,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            Text(
              'HOOPLAB',
              style: GoogleFonts.notoSansTc(
                color: HooplabColors.text,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '教練戰術板。我的戰術只存在這台裝置，不會上傳。',
              style: GoogleFonts.notoSansTc(
                color: HooplabColors.textMuted,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            _tile(
              title: '支援信箱（暫定）',
              body: LaunchPrefs.supportEmail,
            ),
            const SizedBox(height: 12),
            _tile(
              title: '權限',
              body: '只使用網路載入 3D 球場與字型。沒有登入、相機、麥克風、定位或相簿權限。',
            ),
            const SizedBox(height: 12),
            Material(
              color: HooplabColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: HooplabColors.border),
              ),
              child: ListTile(
                title: Text(
                  '隱私權政策',
                  style: GoogleFonts.notoSansTc(
                    color: HooplabColors.text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: HooplabColors.text),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PrivacyPolicyView(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({required String title, required String body}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: HooplabColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HooplabColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.notoSansTc(
                color: HooplabColors.text,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            SelectableText(
              body,
              style: GoogleFonts.notoSansTc(
                color: HooplabColors.textMuted,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

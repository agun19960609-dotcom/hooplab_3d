import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooplab_3d/data/launch_prefs.dart';
import 'package:hooplab_3d/theme/hooplab_theme.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  late final Future<String> _policy = rootBundle.loadString('assets/privacy_policy.md');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HooplabColors.background,
      appBar: AppBar(
        title: const Text('隱私權政策'),
      ),
      body: FutureBuilder<String>(
        future: _policy,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final policy = snapshot.data;
          if (snapshot.hasError || policy == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  '政策暫時打不開。請寫信到 ${LaunchPrefs.supportEmail}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSansTc(color: HooplabColors.text),
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              for (final line in policy.split('\n')) _line(line),
            ],
          );
        },
      ),
    );
  }

  Widget _line(String raw) {
    final line = raw.trimRight();
    if (line.isEmpty) return const SizedBox(height: 10);
    if (line.startsWith('# ')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Text(
          line.substring(2),
          style: GoogleFonts.notoSansTc(
            color: HooplabColors.text,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }
    if (line.startsWith('## ')) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 12),
        child: Text(
          line.substring(3),
          style: GoogleFonts.notoSansTc(
            color: HooplabColors.text,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        line,
        style: GoogleFonts.notoSansTc(
          color: HooplabColors.textMuted,
          fontSize: 15,
          height: 1.45,
        ),
      ),
    );
  }
}

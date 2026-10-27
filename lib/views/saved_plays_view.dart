import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooplab_3d/data/local_playbook.dart';
import 'package:hooplab_3d/views/playboard_view.dart';

class SavedPlaysView extends StatefulWidget {
  const SavedPlaysView({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<SavedPlaysView> createState() => _SavedPlaysViewState();
}

class _SavedPlaysViewState extends State<SavedPlaysView> {
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
        final plays = LocalPlaybook.instance.plays;
        if (plays.isEmpty) {
          return Center(
            child: Text(
              '還沒有儲存的戰術',
              style: GoogleFonts.notoSansTc(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: plays.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final play = plays[index];
            return Material(
              color: const Color(0xFF171C26),
              borderRadius: BorderRadius.circular(16),
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => PlayboardView(initialPlayData: play.jsonData),
                    ),
                  );
                },
                title: Text(
                  play.title,
                  style: GoogleFonts.notoSansTc(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: Text(
                  '只存在這台裝置',
                  style: GoogleFonts.notoSansTc(color: const Color(0xFFB8C0CC)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: '重新命名',
                      icon: const Icon(Icons.drive_file_rename_outline, color: Colors.white),
                      onPressed: () => _rename(play),
                    ),
                    IconButton(
                      tooltip: '刪除',
                      icon: const Icon(Icons.delete_outline, color: Color(0xFFE57373)),
                      onPressed: () => LocalPlaybook.instance.delete(play.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _rename(SavedPlay play) async {
    final controller = TextEditingController(text: play.title);
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF171C26),
        title: const Text('重新命名', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('儲存'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (title == null) return;
    await LocalPlaybook.instance.rename(play.id, title);
  }
}

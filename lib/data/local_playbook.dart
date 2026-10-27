import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedPlay {
  const SavedPlay({
    required this.id,
    required this.title,
    required this.jsonData,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String jsonData;
  final int updatedAt;

  SavedPlay copyWith({String? title, String? jsonData, int? updatedAt}) {
    return SavedPlay(
      id: id,
      title: title ?? this.title,
      jsonData: jsonData ?? this.jsonData,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'jsonData': jsonData,
        'updatedAt': updatedAt,
      };

  static SavedPlay? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final id = raw['id'];
    final title = raw['title'];
    final jsonData = raw['jsonData'];
    if (id is! String || title is! String || jsonData is! String) return null;
    final updated = raw['updatedAt'];
    return SavedPlay(
      id: id,
      title: title,
      jsonData: jsonData,
      updatedAt: updated is num ? updated.toInt() : 0,
    );
  }
}

/// Custom plays live only on the device. Nothing is uploaded.
class LocalPlaybook extends ChangeNotifier {
  LocalPlaybook._();

  static final instance = LocalPlaybook._();
  static const storageKey = 'hooplab_my_plays_v1';

  List<SavedPlay> plays = const [];
  bool ready = false;

  Future<void> ensureLoaded() async {
    if (ready) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      plays = _decode(prefs.getString(storageKey));
    } catch (err) {
      debugPrint('Local playbook unavailable: $err');
      plays = const [];
    }
    ready = true;
    notifyListeners();
  }

  Future<SavedPlay> save({
    String? id,
    required String title,
    required String jsonData,
  }) async {
    await ensureLoaded();
    final now = DateTime.now().millisecondsSinceEpoch;
    final name = title.trim().isEmpty ? '未命名戰術' : title.trim();
    final next = List<SavedPlay>.from(plays);
    final existing = id == null ? -1 : next.indexWhere((play) => play.id == id);
    final saved = SavedPlay(
      id: existing >= 0 ? next[existing].id : now.toString(),
      title: name,
      jsonData: jsonData,
      updatedAt: now,
    );
    if (existing >= 0) {
      next[existing] = saved;
    } else {
      next.insert(0, saved);
    }
    plays = next;
    await _persist();
    notifyListeners();
    return saved;
  }

  Future<void> rename(String id, String title) async {
    await ensureLoaded();
    final name = title.trim();
    if (name.isEmpty) return;
    final next = <SavedPlay>[];
    for (final play in plays) {
      next.add(
        play.id == id
            ? play.copyWith(
                title: name,
                updatedAt: DateTime.now().millisecondsSinceEpoch,
              )
            : play,
      );
    }
    plays = next;
    await _persist();
    notifyListeners();
  }

  Future<void> delete(String id) async {
    await ensureLoaded();
    plays = plays.where((play) => play.id != id).toList();
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      storageKey,
      jsonEncode(plays.map((play) => play.toJson()).toList()),
    );
  }

  static List<SavedPlay> _decode(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded.map(SavedPlay.fromJson).whereType<SavedPlay>().toList();
    } catch (_) {
      return const [];
    }
  }
}

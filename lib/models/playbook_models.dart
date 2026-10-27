import 'package:freezed_annotation/freezed_annotation.dart';

part 'playbook_models.freezed.dart';
part 'playbook_models.g.dart';

enum ActionType { run, dribble, screen, pass, shoot }

@freezed
abstract class Playbook with _$Playbook {
  const factory Playbook({
    required String playName,
    required List<PlayStep> steps,
  }) = _Playbook;

  factory Playbook.fromJson(Map<String, dynamic> json) => _$PlaybookFromJson(json);
}

@freezed
abstract class PlayStep with _$PlayStep {
  const factory PlayStep({
    required int phaseId,
    required List<PlayerAction> actions,
  }) = _PlayStep;

  factory PlayStep.fromJson(Map<String, dynamic> json) => _$PlayStepFromJson(json);
}

@freezed
abstract class PlayerAction with _$PlayerAction {
  const factory PlayerAction({
    required int playerId,
    required ActionType actionType,
    required List<List<double>> path,
    int? targetPlayerId,
  }) = _PlayerAction;

  factory PlayerAction.fromJson(Map<String, dynamic> json) => _$PlayerActionFromJson(json);
}
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playbook_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Playbook _$PlaybookFromJson(Map<String, dynamic> json) => _Playbook(
  playName: json['playName'] as String,
  steps: (json['steps'] as List<dynamic>)
      .map((e) => PlayStep.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PlaybookToJson(_Playbook instance) => <String, dynamic>{
  'playName': instance.playName,
  'steps': instance.steps.map((e) => e.toJson()).toList(),
};

_PlayStep _$PlayStepFromJson(Map<String, dynamic> json) => _PlayStep(
  phaseId: (json['phaseId'] as num).toInt(),
  actions: (json['actions'] as List<dynamic>)
      .map((e) => PlayerAction.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PlayStepToJson(_PlayStep instance) => <String, dynamic>{
  'phaseId': instance.phaseId,
  'actions': instance.actions.map((e) => e.toJson()).toList(),
};

_PlayerAction _$PlayerActionFromJson(Map<String, dynamic> json) =>
    _PlayerAction(
      playerId: (json['playerId'] as num).toInt(),
      actionType: $enumDecode(_$ActionTypeEnumMap, json['actionType']),
      path: (json['path'] as List<dynamic>)
          .map(
            (e) =>
                (e as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
      targetPlayerId: (json['targetPlayerId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlayerActionToJson(_PlayerAction instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'actionType': _$ActionTypeEnumMap[instance.actionType]!,
      'path': instance.path,
      'targetPlayerId': instance.targetPlayerId,
    };

const _$ActionTypeEnumMap = {
  ActionType.run: 'run',
  ActionType.dribble: 'dribble',
  ActionType.screen: 'screen',
  ActionType.pass: 'pass',
  ActionType.shoot: 'shoot',
};

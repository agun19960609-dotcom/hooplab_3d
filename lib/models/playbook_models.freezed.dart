// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playbook_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Playbook {

 String get playName; List<PlayStep> get steps;
/// Create a copy of Playbook
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybookCopyWith<Playbook> get copyWith => _$PlaybookCopyWithImpl<Playbook>(this as Playbook, _$identity);

  /// Serializes this Playbook to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Playbook&&(identical(other.playName, playName) || other.playName == playName)&&const DeepCollectionEquality().equals(other.steps, steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playName,const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'Playbook(playName: $playName, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $PlaybookCopyWith<$Res>  {
  factory $PlaybookCopyWith(Playbook value, $Res Function(Playbook) _then) = _$PlaybookCopyWithImpl;
@useResult
$Res call({
 String playName, List<PlayStep> steps
});




}
/// @nodoc
class _$PlaybookCopyWithImpl<$Res>
    implements $PlaybookCopyWith<$Res> {
  _$PlaybookCopyWithImpl(this._self, this._then);

  final Playbook _self;
  final $Res Function(Playbook) _then;

/// Create a copy of Playbook
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playName = null,Object? steps = null,}) {
  return _then(_self.copyWith(
playName: null == playName ? _self.playName : playName // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<PlayStep>,
  ));
}

}


/// Adds pattern-matching-related methods to [Playbook].
extension PlaybookPatterns on Playbook {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Playbook value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Playbook() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Playbook value)  $default,){
final _that = this;
switch (_that) {
case _Playbook():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Playbook value)?  $default,){
final _that = this;
switch (_that) {
case _Playbook() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playName,  List<PlayStep> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Playbook() when $default != null:
return $default(_that.playName,_that.steps);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playName,  List<PlayStep> steps)  $default,) {final _that = this;
switch (_that) {
case _Playbook():
return $default(_that.playName,_that.steps);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playName,  List<PlayStep> steps)?  $default,) {final _that = this;
switch (_that) {
case _Playbook() when $default != null:
return $default(_that.playName,_that.steps);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Playbook implements Playbook {
  const _Playbook({required this.playName, required final  List<PlayStep> steps}): _steps = steps;
  factory _Playbook.fromJson(Map<String, dynamic> json) => _$PlaybookFromJson(json);

@override final  String playName;
 final  List<PlayStep> _steps;
@override List<PlayStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of Playbook
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybookCopyWith<_Playbook> get copyWith => __$PlaybookCopyWithImpl<_Playbook>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaybookToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Playbook&&(identical(other.playName, playName) || other.playName == playName)&&const DeepCollectionEquality().equals(other._steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playName,const DeepCollectionEquality().hash(_steps));

@override
String toString() {
  return 'Playbook(playName: $playName, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$PlaybookCopyWith<$Res> implements $PlaybookCopyWith<$Res> {
  factory _$PlaybookCopyWith(_Playbook value, $Res Function(_Playbook) _then) = __$PlaybookCopyWithImpl;
@override @useResult
$Res call({
 String playName, List<PlayStep> steps
});




}
/// @nodoc
class __$PlaybookCopyWithImpl<$Res>
    implements _$PlaybookCopyWith<$Res> {
  __$PlaybookCopyWithImpl(this._self, this._then);

  final _Playbook _self;
  final $Res Function(_Playbook) _then;

/// Create a copy of Playbook
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playName = null,Object? steps = null,}) {
  return _then(_Playbook(
playName: null == playName ? _self.playName : playName // ignore: cast_nullable_to_non_nullable
as String,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<PlayStep>,
  ));
}


}


/// @nodoc
mixin _$PlayStep {

 int get phaseId; List<PlayerAction> get actions;
/// Create a copy of PlayStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayStepCopyWith<PlayStep> get copyWith => _$PlayStepCopyWithImpl<PlayStep>(this as PlayStep, _$identity);

  /// Serializes this PlayStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayStep&&(identical(other.phaseId, phaseId) || other.phaseId == phaseId)&&const DeepCollectionEquality().equals(other.actions, actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phaseId,const DeepCollectionEquality().hash(actions));

@override
String toString() {
  return 'PlayStep(phaseId: $phaseId, actions: $actions)';
}


}

/// @nodoc
abstract mixin class $PlayStepCopyWith<$Res>  {
  factory $PlayStepCopyWith(PlayStep value, $Res Function(PlayStep) _then) = _$PlayStepCopyWithImpl;
@useResult
$Res call({
 int phaseId, List<PlayerAction> actions
});




}
/// @nodoc
class _$PlayStepCopyWithImpl<$Res>
    implements $PlayStepCopyWith<$Res> {
  _$PlayStepCopyWithImpl(this._self, this._then);

  final PlayStep _self;
  final $Res Function(PlayStep) _then;

/// Create a copy of PlayStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phaseId = null,Object? actions = null,}) {
  return _then(_self.copyWith(
phaseId: null == phaseId ? _self.phaseId : phaseId // ignore: cast_nullable_to_non_nullable
as int,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<PlayerAction>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayStep].
extension PlayStepPatterns on PlayStep {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayStep() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayStep value)  $default,){
final _that = this;
switch (_that) {
case _PlayStep():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayStep value)?  $default,){
final _that = this;
switch (_that) {
case _PlayStep() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int phaseId,  List<PlayerAction> actions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayStep() when $default != null:
return $default(_that.phaseId,_that.actions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int phaseId,  List<PlayerAction> actions)  $default,) {final _that = this;
switch (_that) {
case _PlayStep():
return $default(_that.phaseId,_that.actions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int phaseId,  List<PlayerAction> actions)?  $default,) {final _that = this;
switch (_that) {
case _PlayStep() when $default != null:
return $default(_that.phaseId,_that.actions);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _PlayStep implements PlayStep {
  const _PlayStep({required this.phaseId, required final  List<PlayerAction> actions}): _actions = actions;
  factory _PlayStep.fromJson(Map<String, dynamic> json) => _$PlayStepFromJson(json);

@override final  int phaseId;
 final  List<PlayerAction> _actions;
@override List<PlayerAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}


/// Create a copy of PlayStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayStepCopyWith<_PlayStep> get copyWith => __$PlayStepCopyWithImpl<_PlayStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayStep&&(identical(other.phaseId, phaseId) || other.phaseId == phaseId)&&const DeepCollectionEquality().equals(other._actions, _actions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phaseId,const DeepCollectionEquality().hash(_actions));

@override
String toString() {
  return 'PlayStep(phaseId: $phaseId, actions: $actions)';
}


}

/// @nodoc
abstract mixin class _$PlayStepCopyWith<$Res> implements $PlayStepCopyWith<$Res> {
  factory _$PlayStepCopyWith(_PlayStep value, $Res Function(_PlayStep) _then) = __$PlayStepCopyWithImpl;
@override @useResult
$Res call({
 int phaseId, List<PlayerAction> actions
});




}
/// @nodoc
class __$PlayStepCopyWithImpl<$Res>
    implements _$PlayStepCopyWith<$Res> {
  __$PlayStepCopyWithImpl(this._self, this._then);

  final _PlayStep _self;
  final $Res Function(_PlayStep) _then;

/// Create a copy of PlayStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phaseId = null,Object? actions = null,}) {
  return _then(_PlayStep(
phaseId: null == phaseId ? _self.phaseId : phaseId // ignore: cast_nullable_to_non_nullable
as int,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<PlayerAction>,
  ));
}


}


/// @nodoc
mixin _$PlayerAction {

 int get playerId; ActionType get actionType; List<List<double>> get path; int? get targetPlayerId;
/// Create a copy of PlayerAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerActionCopyWith<PlayerAction> get copyWith => _$PlayerActionCopyWithImpl<PlayerAction>(this as PlayerAction, _$identity);

  /// Serializes this PlayerAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerAction&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&const DeepCollectionEquality().equals(other.path, path)&&(identical(other.targetPlayerId, targetPlayerId) || other.targetPlayerId == targetPlayerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,actionType,const DeepCollectionEquality().hash(path),targetPlayerId);

@override
String toString() {
  return 'PlayerAction(playerId: $playerId, actionType: $actionType, path: $path, targetPlayerId: $targetPlayerId)';
}


}

/// @nodoc
abstract mixin class $PlayerActionCopyWith<$Res>  {
  factory $PlayerActionCopyWith(PlayerAction value, $Res Function(PlayerAction) _then) = _$PlayerActionCopyWithImpl;
@useResult
$Res call({
 int playerId, ActionType actionType, List<List<double>> path, int? targetPlayerId
});




}
/// @nodoc
class _$PlayerActionCopyWithImpl<$Res>
    implements $PlayerActionCopyWith<$Res> {
  _$PlayerActionCopyWithImpl(this._self, this._then);

  final PlayerAction _self;
  final $Res Function(PlayerAction) _then;

/// Create a copy of PlayerAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? actionType = null,Object? path = null,Object? targetPlayerId = freezed,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as int,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as ActionType,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as List<List<double>>,targetPlayerId: freezed == targetPlayerId ? _self.targetPlayerId : targetPlayerId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerAction].
extension PlayerActionPatterns on PlayerAction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerAction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerAction value)  $default,){
final _that = this;
switch (_that) {
case _PlayerAction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerAction value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerAction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int playerId,  ActionType actionType,  List<List<double>> path,  int? targetPlayerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerAction() when $default != null:
return $default(_that.playerId,_that.actionType,_that.path,_that.targetPlayerId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int playerId,  ActionType actionType,  List<List<double>> path,  int? targetPlayerId)  $default,) {final _that = this;
switch (_that) {
case _PlayerAction():
return $default(_that.playerId,_that.actionType,_that.path,_that.targetPlayerId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int playerId,  ActionType actionType,  List<List<double>> path,  int? targetPlayerId)?  $default,) {final _that = this;
switch (_that) {
case _PlayerAction() when $default != null:
return $default(_that.playerId,_that.actionType,_that.path,_that.targetPlayerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerAction implements PlayerAction {
  const _PlayerAction({required this.playerId, required this.actionType, required final  List<List<double>> path, this.targetPlayerId}): _path = path;
  factory _PlayerAction.fromJson(Map<String, dynamic> json) => _$PlayerActionFromJson(json);

@override final  int playerId;
@override final  ActionType actionType;
 final  List<List<double>> _path;
@override List<List<double>> get path {
  if (_path is EqualUnmodifiableListView) return _path;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_path);
}

@override final  int? targetPlayerId;

/// Create a copy of PlayerAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerActionCopyWith<_PlayerAction> get copyWith => __$PlayerActionCopyWithImpl<_PlayerAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerAction&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&const DeepCollectionEquality().equals(other._path, _path)&&(identical(other.targetPlayerId, targetPlayerId) || other.targetPlayerId == targetPlayerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,actionType,const DeepCollectionEquality().hash(_path),targetPlayerId);

@override
String toString() {
  return 'PlayerAction(playerId: $playerId, actionType: $actionType, path: $path, targetPlayerId: $targetPlayerId)';
}


}

/// @nodoc
abstract mixin class _$PlayerActionCopyWith<$Res> implements $PlayerActionCopyWith<$Res> {
  factory _$PlayerActionCopyWith(_PlayerAction value, $Res Function(_PlayerAction) _then) = __$PlayerActionCopyWithImpl;
@override @useResult
$Res call({
 int playerId, ActionType actionType, List<List<double>> path, int? targetPlayerId
});




}
/// @nodoc
class __$PlayerActionCopyWithImpl<$Res>
    implements _$PlayerActionCopyWith<$Res> {
  __$PlayerActionCopyWithImpl(this._self, this._then);

  final _PlayerAction _self;
  final $Res Function(_PlayerAction) _then;

/// Create a copy of PlayerAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? actionType = null,Object? path = null,Object? targetPlayerId = freezed,}) {
  return _then(_PlayerAction(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as int,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as ActionType,path: null == path ? _self._path : path // ignore: cast_nullable_to_non_nullable
as List<List<double>>,targetPlayerId: freezed == targetPlayerId ? _self.targetPlayerId : targetPlayerId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on

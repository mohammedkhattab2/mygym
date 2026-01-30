// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rewards_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RewardsState {
// User rewards summary
  UserRewards? get userRewards =>
      throw _privateConstructorUsedError; // Available rewards
  List<RewardItem> get rewardItems => throw _privateConstructorUsedError;
  List<RewardItem> get affordableRewards =>
      throw _privateConstructorUsedError; // Points history
  List<PointsTransaction> get pointsHistory =>
      throw _privateConstructorUsedError;
  List<PointsTransaction> get recentTransactions =>
      throw _privateConstructorUsedError; // Redemptions
  List<Redemption> get redemptions => throw _privateConstructorUsedError;
  List<Redemption> get activeRedemptions =>
      throw _privateConstructorUsedError; // Referrals
  List<Referral> get referrals => throw _privateConstructorUsedError;
  String? get referralCode =>
      throw _privateConstructorUsedError; // Earning rules
  List<PointsEarningRule> get earningRules =>
      throw _privateConstructorUsedError; // Status
  RewardsStatus get overviewStatus => throw _privateConstructorUsedError;
  RewardsStatus get rewardsStatus => throw _privateConstructorUsedError;
  RewardsStatus get historyStatus => throw _privateConstructorUsedError;
  RewardsStatus get referralsStatus => throw _privateConstructorUsedError;
  RewardsStatus get redeemStatus => throw _privateConstructorUsedError; // Error
  String? get errorMessage =>
      throw _privateConstructorUsedError; // Success message for redemption
  String? get successMessage => throw _privateConstructorUsedError;
  Redemption? get lastRedemption => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RewardsStateCopyWith<RewardsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RewardsStateCopyWith<$Res> {
  factory $RewardsStateCopyWith(
          RewardsState value, $Res Function(RewardsState) then) =
      _$RewardsStateCopyWithImpl<$Res, RewardsState>;
  @useResult
  $Res call(
      {UserRewards? userRewards,
      List<RewardItem> rewardItems,
      List<RewardItem> affordableRewards,
      List<PointsTransaction> pointsHistory,
      List<PointsTransaction> recentTransactions,
      List<Redemption> redemptions,
      List<Redemption> activeRedemptions,
      List<Referral> referrals,
      String? referralCode,
      List<PointsEarningRule> earningRules,
      RewardsStatus overviewStatus,
      RewardsStatus rewardsStatus,
      RewardsStatus historyStatus,
      RewardsStatus referralsStatus,
      RewardsStatus redeemStatus,
      String? errorMessage,
      String? successMessage,
      Redemption? lastRedemption});
}

/// @nodoc
class _$RewardsStateCopyWithImpl<$Res, $Val extends RewardsState>
    implements $RewardsStateCopyWith<$Res> {
  _$RewardsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userRewards = freezed,
    Object? rewardItems = null,
    Object? affordableRewards = null,
    Object? pointsHistory = null,
    Object? recentTransactions = null,
    Object? redemptions = null,
    Object? activeRedemptions = null,
    Object? referrals = null,
    Object? referralCode = freezed,
    Object? earningRules = null,
    Object? overviewStatus = null,
    Object? rewardsStatus = null,
    Object? historyStatus = null,
    Object? referralsStatus = null,
    Object? redeemStatus = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
    Object? lastRedemption = freezed,
  }) {
    return _then(_value.copyWith(
      userRewards: freezed == userRewards
          ? _value.userRewards
          : userRewards // ignore: cast_nullable_to_non_nullable
              as UserRewards?,
      rewardItems: null == rewardItems
          ? _value.rewardItems
          : rewardItems // ignore: cast_nullable_to_non_nullable
              as List<RewardItem>,
      affordableRewards: null == affordableRewards
          ? _value.affordableRewards
          : affordableRewards // ignore: cast_nullable_to_non_nullable
              as List<RewardItem>,
      pointsHistory: null == pointsHistory
          ? _value.pointsHistory
          : pointsHistory // ignore: cast_nullable_to_non_nullable
              as List<PointsTransaction>,
      recentTransactions: null == recentTransactions
          ? _value.recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<PointsTransaction>,
      redemptions: null == redemptions
          ? _value.redemptions
          : redemptions // ignore: cast_nullable_to_non_nullable
              as List<Redemption>,
      activeRedemptions: null == activeRedemptions
          ? _value.activeRedemptions
          : activeRedemptions // ignore: cast_nullable_to_non_nullable
              as List<Redemption>,
      referrals: null == referrals
          ? _value.referrals
          : referrals // ignore: cast_nullable_to_non_nullable
              as List<Referral>,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      earningRules: null == earningRules
          ? _value.earningRules
          : earningRules // ignore: cast_nullable_to_non_nullable
              as List<PointsEarningRule>,
      overviewStatus: null == overviewStatus
          ? _value.overviewStatus
          : overviewStatus // ignore: cast_nullable_to_non_nullable
              as RewardsStatus,
      rewardsStatus: null == rewardsStatus
          ? _value.rewardsStatus
          : rewardsStatus // ignore: cast_nullable_to_non_nullable
              as RewardsStatus,
      historyStatus: null == historyStatus
          ? _value.historyStatus
          : historyStatus // ignore: cast_nullable_to_non_nullable
              as RewardsStatus,
      referralsStatus: null == referralsStatus
          ? _value.referralsStatus
          : referralsStatus // ignore: cast_nullable_to_non_nullable
              as RewardsStatus,
      redeemStatus: null == redeemStatus
          ? _value.redeemStatus
          : redeemStatus // ignore: cast_nullable_to_non_nullable
              as RewardsStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastRedemption: freezed == lastRedemption
          ? _value.lastRedemption
          : lastRedemption // ignore: cast_nullable_to_non_nullable
              as Redemption?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RewardsStateImplCopyWith<$Res>
    implements $RewardsStateCopyWith<$Res> {
  factory _$$RewardsStateImplCopyWith(
          _$RewardsStateImpl value, $Res Function(_$RewardsStateImpl) then) =
      __$$RewardsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserRewards? userRewards,
      List<RewardItem> rewardItems,
      List<RewardItem> affordableRewards,
      List<PointsTransaction> pointsHistory,
      List<PointsTransaction> recentTransactions,
      List<Redemption> redemptions,
      List<Redemption> activeRedemptions,
      List<Referral> referrals,
      String? referralCode,
      List<PointsEarningRule> earningRules,
      RewardsStatus overviewStatus,
      RewardsStatus rewardsStatus,
      RewardsStatus historyStatus,
      RewardsStatus referralsStatus,
      RewardsStatus redeemStatus,
      String? errorMessage,
      String? successMessage,
      Redemption? lastRedemption});
}

/// @nodoc
class __$$RewardsStateImplCopyWithImpl<$Res>
    extends _$RewardsStateCopyWithImpl<$Res, _$RewardsStateImpl>
    implements _$$RewardsStateImplCopyWith<$Res> {
  __$$RewardsStateImplCopyWithImpl(
      _$RewardsStateImpl _value, $Res Function(_$RewardsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userRewards = freezed,
    Object? rewardItems = null,
    Object? affordableRewards = null,
    Object? pointsHistory = null,
    Object? recentTransactions = null,
    Object? redemptions = null,
    Object? activeRedemptions = null,
    Object? referrals = null,
    Object? referralCode = freezed,
    Object? earningRules = null,
    Object? overviewStatus = null,
    Object? rewardsStatus = null,
    Object? historyStatus = null,
    Object? referralsStatus = null,
    Object? redeemStatus = null,
    Object? errorMessage = freezed,
    Object? successMessage = freezed,
    Object? lastRedemption = freezed,
  }) {
    return _then(_$RewardsStateImpl(
      userRewards: freezed == userRewards
          ? _value.userRewards
          : userRewards // ignore: cast_nullable_to_non_nullable
              as UserRewards?,
      rewardItems: null == rewardItems
          ? _value._rewardItems
          : rewardItems // ignore: cast_nullable_to_non_nullable
              as List<RewardItem>,
      affordableRewards: null == affordableRewards
          ? _value._affordableRewards
          : affordableRewards // ignore: cast_nullable_to_non_nullable
              as List<RewardItem>,
      pointsHistory: null == pointsHistory
          ? _value._pointsHistory
          : pointsHistory // ignore: cast_nullable_to_non_nullable
              as List<PointsTransaction>,
      recentTransactions: null == recentTransactions
          ? _value._recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<PointsTransaction>,
      redemptions: null == redemptions
          ? _value._redemptions
          : redemptions // ignore: cast_nullable_to_non_nullable
              as List<Redemption>,
      activeRedemptions: null == activeRedemptions
          ? _value._activeRedemptions
          : activeRedemptions // ignore: cast_nullable_to_non_nullable
              as List<Redemption>,
      referrals: null == referrals
          ? _value._referrals
          : referrals // ignore: cast_nullable_to_non_nullable
              as List<Referral>,
      referralCode: freezed == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String?,
      earningRules: null == earningRules
          ? _value._earningRules
          : earningRules // ignore: cast_nullable_to_non_nullable
              as List<PointsEarningRule>,
      overviewStatus: null == overviewStatus
          ? _value.overviewStatus
          : overviewStatus // ignore: cast_nullable_to_non_nullable
              as RewardsStatus,
      rewardsStatus: null == rewardsStatus
          ? _value.rewardsStatus
          : rewardsStatus // ignore: cast_nullable_to_non_nullable
              as RewardsStatus,
      historyStatus: null == historyStatus
          ? _value.historyStatus
          : historyStatus // ignore: cast_nullable_to_non_nullable
              as RewardsStatus,
      referralsStatus: null == referralsStatus
          ? _value.referralsStatus
          : referralsStatus // ignore: cast_nullable_to_non_nullable
              as RewardsStatus,
      redeemStatus: null == redeemStatus
          ? _value.redeemStatus
          : redeemStatus // ignore: cast_nullable_to_non_nullable
              as RewardsStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      successMessage: freezed == successMessage
          ? _value.successMessage
          : successMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastRedemption: freezed == lastRedemption
          ? _value.lastRedemption
          : lastRedemption // ignore: cast_nullable_to_non_nullable
              as Redemption?,
    ));
  }
}

/// @nodoc

class _$RewardsStateImpl extends _RewardsState {
  const _$RewardsStateImpl(
      {this.userRewards,
      final List<RewardItem> rewardItems = const [],
      final List<RewardItem> affordableRewards = const [],
      final List<PointsTransaction> pointsHistory = const [],
      final List<PointsTransaction> recentTransactions = const [],
      final List<Redemption> redemptions = const [],
      final List<Redemption> activeRedemptions = const [],
      final List<Referral> referrals = const [],
      this.referralCode,
      final List<PointsEarningRule> earningRules = const [],
      this.overviewStatus = RewardsStatus.initial,
      this.rewardsStatus = RewardsStatus.initial,
      this.historyStatus = RewardsStatus.initial,
      this.referralsStatus = RewardsStatus.initial,
      this.redeemStatus = RewardsStatus.initial,
      this.errorMessage,
      this.successMessage,
      this.lastRedemption})
      : _rewardItems = rewardItems,
        _affordableRewards = affordableRewards,
        _pointsHistory = pointsHistory,
        _recentTransactions = recentTransactions,
        _redemptions = redemptions,
        _activeRedemptions = activeRedemptions,
        _referrals = referrals,
        _earningRules = earningRules,
        super._();

// User rewards summary
  @override
  final UserRewards? userRewards;
// Available rewards
  final List<RewardItem> _rewardItems;
// Available rewards
  @override
  @JsonKey()
  List<RewardItem> get rewardItems {
    if (_rewardItems is EqualUnmodifiableListView) return _rewardItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rewardItems);
  }

  final List<RewardItem> _affordableRewards;
  @override
  @JsonKey()
  List<RewardItem> get affordableRewards {
    if (_affordableRewards is EqualUnmodifiableListView)
      return _affordableRewards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_affordableRewards);
  }

// Points history
  final List<PointsTransaction> _pointsHistory;
// Points history
  @override
  @JsonKey()
  List<PointsTransaction> get pointsHistory {
    if (_pointsHistory is EqualUnmodifiableListView) return _pointsHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pointsHistory);
  }

  final List<PointsTransaction> _recentTransactions;
  @override
  @JsonKey()
  List<PointsTransaction> get recentTransactions {
    if (_recentTransactions is EqualUnmodifiableListView)
      return _recentTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTransactions);
  }

// Redemptions
  final List<Redemption> _redemptions;
// Redemptions
  @override
  @JsonKey()
  List<Redemption> get redemptions {
    if (_redemptions is EqualUnmodifiableListView) return _redemptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_redemptions);
  }

  final List<Redemption> _activeRedemptions;
  @override
  @JsonKey()
  List<Redemption> get activeRedemptions {
    if (_activeRedemptions is EqualUnmodifiableListView)
      return _activeRedemptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeRedemptions);
  }

// Referrals
  final List<Referral> _referrals;
// Referrals
  @override
  @JsonKey()
  List<Referral> get referrals {
    if (_referrals is EqualUnmodifiableListView) return _referrals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_referrals);
  }

  @override
  final String? referralCode;
// Earning rules
  final List<PointsEarningRule> _earningRules;
// Earning rules
  @override
  @JsonKey()
  List<PointsEarningRule> get earningRules {
    if (_earningRules is EqualUnmodifiableListView) return _earningRules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_earningRules);
  }

// Status
  @override
  @JsonKey()
  final RewardsStatus overviewStatus;
  @override
  @JsonKey()
  final RewardsStatus rewardsStatus;
  @override
  @JsonKey()
  final RewardsStatus historyStatus;
  @override
  @JsonKey()
  final RewardsStatus referralsStatus;
  @override
  @JsonKey()
  final RewardsStatus redeemStatus;
// Error
  @override
  final String? errorMessage;
// Success message for redemption
  @override
  final String? successMessage;
  @override
  final Redemption? lastRedemption;

  @override
  String toString() {
    return 'RewardsState(userRewards: $userRewards, rewardItems: $rewardItems, affordableRewards: $affordableRewards, pointsHistory: $pointsHistory, recentTransactions: $recentTransactions, redemptions: $redemptions, activeRedemptions: $activeRedemptions, referrals: $referrals, referralCode: $referralCode, earningRules: $earningRules, overviewStatus: $overviewStatus, rewardsStatus: $rewardsStatus, historyStatus: $historyStatus, referralsStatus: $referralsStatus, redeemStatus: $redeemStatus, errorMessage: $errorMessage, successMessage: $successMessage, lastRedemption: $lastRedemption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RewardsStateImpl &&
            (identical(other.userRewards, userRewards) ||
                other.userRewards == userRewards) &&
            const DeepCollectionEquality()
                .equals(other._rewardItems, _rewardItems) &&
            const DeepCollectionEquality()
                .equals(other._affordableRewards, _affordableRewards) &&
            const DeepCollectionEquality()
                .equals(other._pointsHistory, _pointsHistory) &&
            const DeepCollectionEquality()
                .equals(other._recentTransactions, _recentTransactions) &&
            const DeepCollectionEquality()
                .equals(other._redemptions, _redemptions) &&
            const DeepCollectionEquality()
                .equals(other._activeRedemptions, _activeRedemptions) &&
            const DeepCollectionEquality()
                .equals(other._referrals, _referrals) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            const DeepCollectionEquality()
                .equals(other._earningRules, _earningRules) &&
            (identical(other.overviewStatus, overviewStatus) ||
                other.overviewStatus == overviewStatus) &&
            (identical(other.rewardsStatus, rewardsStatus) ||
                other.rewardsStatus == rewardsStatus) &&
            (identical(other.historyStatus, historyStatus) ||
                other.historyStatus == historyStatus) &&
            (identical(other.referralsStatus, referralsStatus) ||
                other.referralsStatus == referralsStatus) &&
            (identical(other.redeemStatus, redeemStatus) ||
                other.redeemStatus == redeemStatus) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.successMessage, successMessage) ||
                other.successMessage == successMessage) &&
            (identical(other.lastRedemption, lastRedemption) ||
                other.lastRedemption == lastRedemption));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userRewards,
      const DeepCollectionEquality().hash(_rewardItems),
      const DeepCollectionEquality().hash(_affordableRewards),
      const DeepCollectionEquality().hash(_pointsHistory),
      const DeepCollectionEquality().hash(_recentTransactions),
      const DeepCollectionEquality().hash(_redemptions),
      const DeepCollectionEquality().hash(_activeRedemptions),
      const DeepCollectionEquality().hash(_referrals),
      referralCode,
      const DeepCollectionEquality().hash(_earningRules),
      overviewStatus,
      rewardsStatus,
      historyStatus,
      referralsStatus,
      redeemStatus,
      errorMessage,
      successMessage,
      lastRedemption);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RewardsStateImplCopyWith<_$RewardsStateImpl> get copyWith =>
      __$$RewardsStateImplCopyWithImpl<_$RewardsStateImpl>(this, _$identity);
}

abstract class _RewardsState extends RewardsState {
  const factory _RewardsState(
      {final UserRewards? userRewards,
      final List<RewardItem> rewardItems,
      final List<RewardItem> affordableRewards,
      final List<PointsTransaction> pointsHistory,
      final List<PointsTransaction> recentTransactions,
      final List<Redemption> redemptions,
      final List<Redemption> activeRedemptions,
      final List<Referral> referrals,
      final String? referralCode,
      final List<PointsEarningRule> earningRules,
      final RewardsStatus overviewStatus,
      final RewardsStatus rewardsStatus,
      final RewardsStatus historyStatus,
      final RewardsStatus referralsStatus,
      final RewardsStatus redeemStatus,
      final String? errorMessage,
      final String? successMessage,
      final Redemption? lastRedemption}) = _$RewardsStateImpl;
  const _RewardsState._() : super._();

  @override // User rewards summary
  UserRewards? get userRewards;
  @override // Available rewards
  List<RewardItem> get rewardItems;
  @override
  List<RewardItem> get affordableRewards;
  @override // Points history
  List<PointsTransaction> get pointsHistory;
  @override
  List<PointsTransaction> get recentTransactions;
  @override // Redemptions
  List<Redemption> get redemptions;
  @override
  List<Redemption> get activeRedemptions;
  @override // Referrals
  List<Referral> get referrals;
  @override
  String? get referralCode;
  @override // Earning rules
  List<PointsEarningRule> get earningRules;
  @override // Status
  RewardsStatus get overviewStatus;
  @override
  RewardsStatus get rewardsStatus;
  @override
  RewardsStatus get historyStatus;
  @override
  RewardsStatus get referralsStatus;
  @override
  RewardsStatus get redeemStatus;
  @override // Error
  String? get errorMessage;
  @override // Success message for redemption
  String? get successMessage;
  @override
  Redemption? get lastRedemption;
  @override
  @JsonKey(ignore: true)
  _$$RewardsStateImplCopyWith<_$RewardsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

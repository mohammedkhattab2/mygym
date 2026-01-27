// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscriptions_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SubscriptionsState {
// Data
  List<SubscriptionBundle> get bundles => throw _privateConstructorUsedError;
  UserSubscription? get currentSubscription =>
      throw _privateConstructorUsedError;
  List<Invoice> get invoices =>
      throw _privateConstructorUsedError; // Selected items
  SubscriptionBundle? get selectedBundle => throw _privateConstructorUsedError;
  PaymentProvider? get selectedProvider =>
      throw _privateConstructorUsedError; // Promo code
  String get promoCode => throw _privateConstructorUsedError;
  PromoCodeResult? get promoResult =>
      throw _privateConstructorUsedError; // Checkout
  CheckoutSession? get checkoutSession =>
      throw _privateConstructorUsedError; // Loading states
  SubscriptionsStatus get bundlesStatus => throw _privateConstructorUsedError;
  SubscriptionsStatus get subscriptionStatus =>
      throw _privateConstructorUsedError;
  SubscriptionsStatus get checkoutStatus => throw _privateConstructorUsedError;
  SubscriptionsStatus get invoicesStatus => throw _privateConstructorUsedError;
  SubscriptionsStatus get promoStatus =>
      throw _privateConstructorUsedError; // Error
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SubscriptionsStateCopyWith<SubscriptionsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionsStateCopyWith<$Res> {
  factory $SubscriptionsStateCopyWith(
          SubscriptionsState value, $Res Function(SubscriptionsState) then) =
      _$SubscriptionsStateCopyWithImpl<$Res, SubscriptionsState>;
  @useResult
  $Res call(
      {List<SubscriptionBundle> bundles,
      UserSubscription? currentSubscription,
      List<Invoice> invoices,
      SubscriptionBundle? selectedBundle,
      PaymentProvider? selectedProvider,
      String promoCode,
      PromoCodeResult? promoResult,
      CheckoutSession? checkoutSession,
      SubscriptionsStatus bundlesStatus,
      SubscriptionsStatus subscriptionStatus,
      SubscriptionsStatus checkoutStatus,
      SubscriptionsStatus invoicesStatus,
      SubscriptionsStatus promoStatus,
      String? errorMessage});
}

/// @nodoc
class _$SubscriptionsStateCopyWithImpl<$Res, $Val extends SubscriptionsState>
    implements $SubscriptionsStateCopyWith<$Res> {
  _$SubscriptionsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bundles = null,
    Object? currentSubscription = freezed,
    Object? invoices = null,
    Object? selectedBundle = freezed,
    Object? selectedProvider = freezed,
    Object? promoCode = null,
    Object? promoResult = freezed,
    Object? checkoutSession = freezed,
    Object? bundlesStatus = null,
    Object? subscriptionStatus = null,
    Object? checkoutStatus = null,
    Object? invoicesStatus = null,
    Object? promoStatus = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      bundles: null == bundles
          ? _value.bundles
          : bundles // ignore: cast_nullable_to_non_nullable
              as List<SubscriptionBundle>,
      currentSubscription: freezed == currentSubscription
          ? _value.currentSubscription
          : currentSubscription // ignore: cast_nullable_to_non_nullable
              as UserSubscription?,
      invoices: null == invoices
          ? _value.invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<Invoice>,
      selectedBundle: freezed == selectedBundle
          ? _value.selectedBundle
          : selectedBundle // ignore: cast_nullable_to_non_nullable
              as SubscriptionBundle?,
      selectedProvider: freezed == selectedProvider
          ? _value.selectedProvider
          : selectedProvider // ignore: cast_nullable_to_non_nullable
              as PaymentProvider?,
      promoCode: null == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String,
      promoResult: freezed == promoResult
          ? _value.promoResult
          : promoResult // ignore: cast_nullable_to_non_nullable
              as PromoCodeResult?,
      checkoutSession: freezed == checkoutSession
          ? _value.checkoutSession
          : checkoutSession // ignore: cast_nullable_to_non_nullable
              as CheckoutSession?,
      bundlesStatus: null == bundlesStatus
          ? _value.bundlesStatus
          : bundlesStatus // ignore: cast_nullable_to_non_nullable
              as SubscriptionsStatus,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as SubscriptionsStatus,
      checkoutStatus: null == checkoutStatus
          ? _value.checkoutStatus
          : checkoutStatus // ignore: cast_nullable_to_non_nullable
              as SubscriptionsStatus,
      invoicesStatus: null == invoicesStatus
          ? _value.invoicesStatus
          : invoicesStatus // ignore: cast_nullable_to_non_nullable
              as SubscriptionsStatus,
      promoStatus: null == promoStatus
          ? _value.promoStatus
          : promoStatus // ignore: cast_nullable_to_non_nullable
              as SubscriptionsStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubscriptionsStateImplCopyWith<$Res>
    implements $SubscriptionsStateCopyWith<$Res> {
  factory _$$SubscriptionsStateImplCopyWith(_$SubscriptionsStateImpl value,
          $Res Function(_$SubscriptionsStateImpl) then) =
      __$$SubscriptionsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SubscriptionBundle> bundles,
      UserSubscription? currentSubscription,
      List<Invoice> invoices,
      SubscriptionBundle? selectedBundle,
      PaymentProvider? selectedProvider,
      String promoCode,
      PromoCodeResult? promoResult,
      CheckoutSession? checkoutSession,
      SubscriptionsStatus bundlesStatus,
      SubscriptionsStatus subscriptionStatus,
      SubscriptionsStatus checkoutStatus,
      SubscriptionsStatus invoicesStatus,
      SubscriptionsStatus promoStatus,
      String? errorMessage});
}

/// @nodoc
class __$$SubscriptionsStateImplCopyWithImpl<$Res>
    extends _$SubscriptionsStateCopyWithImpl<$Res, _$SubscriptionsStateImpl>
    implements _$$SubscriptionsStateImplCopyWith<$Res> {
  __$$SubscriptionsStateImplCopyWithImpl(_$SubscriptionsStateImpl _value,
      $Res Function(_$SubscriptionsStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bundles = null,
    Object? currentSubscription = freezed,
    Object? invoices = null,
    Object? selectedBundle = freezed,
    Object? selectedProvider = freezed,
    Object? promoCode = null,
    Object? promoResult = freezed,
    Object? checkoutSession = freezed,
    Object? bundlesStatus = null,
    Object? subscriptionStatus = null,
    Object? checkoutStatus = null,
    Object? invoicesStatus = null,
    Object? promoStatus = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$SubscriptionsStateImpl(
      bundles: null == bundles
          ? _value._bundles
          : bundles // ignore: cast_nullable_to_non_nullable
              as List<SubscriptionBundle>,
      currentSubscription: freezed == currentSubscription
          ? _value.currentSubscription
          : currentSubscription // ignore: cast_nullable_to_non_nullable
              as UserSubscription?,
      invoices: null == invoices
          ? _value._invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<Invoice>,
      selectedBundle: freezed == selectedBundle
          ? _value.selectedBundle
          : selectedBundle // ignore: cast_nullable_to_non_nullable
              as SubscriptionBundle?,
      selectedProvider: freezed == selectedProvider
          ? _value.selectedProvider
          : selectedProvider // ignore: cast_nullable_to_non_nullable
              as PaymentProvider?,
      promoCode: null == promoCode
          ? _value.promoCode
          : promoCode // ignore: cast_nullable_to_non_nullable
              as String,
      promoResult: freezed == promoResult
          ? _value.promoResult
          : promoResult // ignore: cast_nullable_to_non_nullable
              as PromoCodeResult?,
      checkoutSession: freezed == checkoutSession
          ? _value.checkoutSession
          : checkoutSession // ignore: cast_nullable_to_non_nullable
              as CheckoutSession?,
      bundlesStatus: null == bundlesStatus
          ? _value.bundlesStatus
          : bundlesStatus // ignore: cast_nullable_to_non_nullable
              as SubscriptionsStatus,
      subscriptionStatus: null == subscriptionStatus
          ? _value.subscriptionStatus
          : subscriptionStatus // ignore: cast_nullable_to_non_nullable
              as SubscriptionsStatus,
      checkoutStatus: null == checkoutStatus
          ? _value.checkoutStatus
          : checkoutStatus // ignore: cast_nullable_to_non_nullable
              as SubscriptionsStatus,
      invoicesStatus: null == invoicesStatus
          ? _value.invoicesStatus
          : invoicesStatus // ignore: cast_nullable_to_non_nullable
              as SubscriptionsStatus,
      promoStatus: null == promoStatus
          ? _value.promoStatus
          : promoStatus // ignore: cast_nullable_to_non_nullable
              as SubscriptionsStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SubscriptionsStateImpl extends _SubscriptionsState {
  const _$SubscriptionsStateImpl(
      {final List<SubscriptionBundle> bundles = const [],
      this.currentSubscription,
      final List<Invoice> invoices = const [],
      this.selectedBundle,
      this.selectedProvider,
      this.promoCode = '',
      this.promoResult,
      this.checkoutSession,
      this.bundlesStatus = SubscriptionsStatus.initial,
      this.subscriptionStatus = SubscriptionsStatus.initial,
      this.checkoutStatus = SubscriptionsStatus.initial,
      this.invoicesStatus = SubscriptionsStatus.initial,
      this.promoStatus = SubscriptionsStatus.initial,
      this.errorMessage})
      : _bundles = bundles,
        _invoices = invoices,
        super._();

// Data
  final List<SubscriptionBundle> _bundles;
// Data
  @override
  @JsonKey()
  List<SubscriptionBundle> get bundles {
    if (_bundles is EqualUnmodifiableListView) return _bundles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bundles);
  }

  @override
  final UserSubscription? currentSubscription;
  final List<Invoice> _invoices;
  @override
  @JsonKey()
  List<Invoice> get invoices {
    if (_invoices is EqualUnmodifiableListView) return _invoices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoices);
  }

// Selected items
  @override
  final SubscriptionBundle? selectedBundle;
  @override
  final PaymentProvider? selectedProvider;
// Promo code
  @override
  @JsonKey()
  final String promoCode;
  @override
  final PromoCodeResult? promoResult;
// Checkout
  @override
  final CheckoutSession? checkoutSession;
// Loading states
  @override
  @JsonKey()
  final SubscriptionsStatus bundlesStatus;
  @override
  @JsonKey()
  final SubscriptionsStatus subscriptionStatus;
  @override
  @JsonKey()
  final SubscriptionsStatus checkoutStatus;
  @override
  @JsonKey()
  final SubscriptionsStatus invoicesStatus;
  @override
  @JsonKey()
  final SubscriptionsStatus promoStatus;
// Error
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'SubscriptionsState(bundles: $bundles, currentSubscription: $currentSubscription, invoices: $invoices, selectedBundle: $selectedBundle, selectedProvider: $selectedProvider, promoCode: $promoCode, promoResult: $promoResult, checkoutSession: $checkoutSession, bundlesStatus: $bundlesStatus, subscriptionStatus: $subscriptionStatus, checkoutStatus: $checkoutStatus, invoicesStatus: $invoicesStatus, promoStatus: $promoStatus, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionsStateImpl &&
            const DeepCollectionEquality().equals(other._bundles, _bundles) &&
            (identical(other.currentSubscription, currentSubscription) ||
                other.currentSubscription == currentSubscription) &&
            const DeepCollectionEquality().equals(other._invoices, _invoices) &&
            (identical(other.selectedBundle, selectedBundle) ||
                other.selectedBundle == selectedBundle) &&
            (identical(other.selectedProvider, selectedProvider) ||
                other.selectedProvider == selectedProvider) &&
            (identical(other.promoCode, promoCode) ||
                other.promoCode == promoCode) &&
            (identical(other.promoResult, promoResult) ||
                other.promoResult == promoResult) &&
            (identical(other.checkoutSession, checkoutSession) ||
                other.checkoutSession == checkoutSession) &&
            (identical(other.bundlesStatus, bundlesStatus) ||
                other.bundlesStatus == bundlesStatus) &&
            (identical(other.subscriptionStatus, subscriptionStatus) ||
                other.subscriptionStatus == subscriptionStatus) &&
            (identical(other.checkoutStatus, checkoutStatus) ||
                other.checkoutStatus == checkoutStatus) &&
            (identical(other.invoicesStatus, invoicesStatus) ||
                other.invoicesStatus == invoicesStatus) &&
            (identical(other.promoStatus, promoStatus) ||
                other.promoStatus == promoStatus) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_bundles),
      currentSubscription,
      const DeepCollectionEquality().hash(_invoices),
      selectedBundle,
      selectedProvider,
      promoCode,
      promoResult,
      checkoutSession,
      bundlesStatus,
      subscriptionStatus,
      checkoutStatus,
      invoicesStatus,
      promoStatus,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionsStateImplCopyWith<_$SubscriptionsStateImpl> get copyWith =>
      __$$SubscriptionsStateImplCopyWithImpl<_$SubscriptionsStateImpl>(
          this, _$identity);
}

abstract class _SubscriptionsState extends SubscriptionsState {
  const factory _SubscriptionsState(
      {final List<SubscriptionBundle> bundles,
      final UserSubscription? currentSubscription,
      final List<Invoice> invoices,
      final SubscriptionBundle? selectedBundle,
      final PaymentProvider? selectedProvider,
      final String promoCode,
      final PromoCodeResult? promoResult,
      final CheckoutSession? checkoutSession,
      final SubscriptionsStatus bundlesStatus,
      final SubscriptionsStatus subscriptionStatus,
      final SubscriptionsStatus checkoutStatus,
      final SubscriptionsStatus invoicesStatus,
      final SubscriptionsStatus promoStatus,
      final String? errorMessage}) = _$SubscriptionsStateImpl;
  const _SubscriptionsState._() : super._();

  @override // Data
  List<SubscriptionBundle> get bundles;
  @override
  UserSubscription? get currentSubscription;
  @override
  List<Invoice> get invoices;
  @override // Selected items
  SubscriptionBundle? get selectedBundle;
  @override
  PaymentProvider? get selectedProvider;
  @override // Promo code
  String get promoCode;
  @override
  PromoCodeResult? get promoResult;
  @override // Checkout
  CheckoutSession? get checkoutSession;
  @override // Loading states
  SubscriptionsStatus get bundlesStatus;
  @override
  SubscriptionsStatus get subscriptionStatus;
  @override
  SubscriptionsStatus get checkoutStatus;
  @override
  SubscriptionsStatus get invoicesStatus;
  @override
  SubscriptionsStatus get promoStatus;
  @override // Error
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$SubscriptionsStateImplCopyWith<_$SubscriptionsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

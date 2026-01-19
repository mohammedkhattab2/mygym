# MyGym - Architecture Report

## Overview

MyGym is a comprehensive gym management platform built with Flutter, supporting mobile (iOS/Android) and web platforms. The application follows **MVVM + Clean Architecture** principles with a **feature-driven folder structure**.

### Platform Support
- **Mobile**: iOS & Android (Member app, Partner tablet app)
- **Web**: Admin Dashboard, Partner Dashboard

### User Roles
1. **Member**: Regular gym-goers who subscribe and check-in
2. **Guest**: Limited access users exploring the platform
3. **Gym Partner**: Gym owners/staff managing their facility
4. **Admin**: Platform administrators managing all gyms

---

## Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Views     │  │   Widgets   │  │  Blocs/Cubits       │  │
│  │  (Screens)  │  │ (Components)│  │  (State Management) │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Entities   │  │  Use Cases  │  │  Repository         │  │
│  │  (Models)   │  │  (Business) │  │  Interfaces         │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Models    │  │ Repository  │  │   Data Sources      │  │
│  │   (DTOs)    │  │    Impl     │  │  (Remote/Local)     │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       CORE LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Network   │  │     DI      │  │   Utils/Constants   │  │
│  │  (Dio/API)  │  │  (GetIt)    │  │   Theme/Extensions  │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Folder Structure

```
lib/
├── main.dart                          # App entry point
├── main_development.dart              # Development flavor
├── main_staging.dart                  # Staging flavor
├── main_production.dart               # Production flavor
├── app.dart                           # Root App widget
├── bootstrap.dart                     # App initialization
│
├── src/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── api_endpoints.dart
│   │   │   ├── storage_keys.dart
│   │   │   └── asset_paths.dart
│   │   │
│   │   ├── config/
│   │   │   ├── app_config.dart
│   │   │   ├── environment.dart
│   │   │   └── flavor_config.dart
│   │   │
│   │   ├── di/
│   │   │   ├── injection.dart
│   │   │   ├── injection.config.dart     # Generated
│   │   │   └── modules/
│   │   │       ├── network_module.dart
│   │   │       ├── storage_module.dart
│   │   │       └── firebase_module.dart
│   │   │
│   │   ├── error/
│   │   │   ├── exceptions.dart
│   │   │   ├── failures.dart
│   │   │   └── error_handler.dart
│   │   │
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   ├── dio_client.dart
│   │   │   ├── interceptors/
│   │   │   │   ├── auth_interceptor.dart
│   │   │   │   ├── error_interceptor.dart
│   │   │   │   └── logging_interceptor.dart
│   │   │   └── network_info.dart
│   │   │
│   │   ├── router/
│   │   │   ├── app_router.dart
│   │   │   ├── route_names.dart
│   │   │   ├── route_paths.dart
│   │   │   ├── guards/
│   │   │   │   ├── auth_guard.dart
│   │   │   │   ├── role_guard.dart
│   │   │   │   └── subscription_guard.dart
│   │   │   └── routes/
│   │   │       ├── auth_routes.dart
│   │   │       ├── member_routes.dart
│   │   │       ├── partner_routes.dart
│   │   │       └── admin_routes.dart
│   │   │
│   │   ├── storage/
│   │   │   ├── secure_storage.dart
│   │   │   ├── hive_storage.dart
│   │   │   └── cache_manager.dart
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   └── app_dimensions.dart
│   │   │
│   │   ├── utils/
│   │   │   ├── extensions/
│   │   │   │   ├── context_extensions.dart
│   │   │   │   ├── string_extensions.dart
│   │   │   │   ├── date_extensions.dart
│   │   │   │   └── num_extensions.dart
│   │   │   ├── helpers/
│   │   │   │   ├── date_helper.dart
│   │   │   │   ├── validation_helper.dart
│   │   │   │   └── format_helper.dart
│   │   │   └── logger.dart
│   │   │
│   │   └── widgets/
│   │       ├── buttons/
│   │       │   ├── primary_button.dart
│   │       │   ├── secondary_button.dart
│   │       │   └── social_button.dart
│   │       ├── inputs/
│   │       │   ├── custom_text_field.dart
│   │       │   ├── phone_input.dart
│   │       │   └── otp_input.dart
│   │       ├── loading/
│   │       │   ├── loading_overlay.dart
│   │       │   ├── skeleton_loader.dart
│   │       │   └── shimmer_widget.dart
│   │       ├── dialogs/
│   │       │   ├── confirm_dialog.dart
│   │       │   └── error_dialog.dart
│   │       ├── cards/
│   │       │   ├── gym_card.dart
│   │       │   └── subscription_card.dart
│   │       └── layouts/
│   │           ├── responsive_layout.dart
│   │           ├── web_scaffold.dart
│   │           └── navigation_rail_layout.dart
│   │
│   └── features/
│       │
│       ├── auth/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   ├── auth_remote_datasource.dart
│       │   │   │   └── auth_local_datasource.dart
│       │   │   ├── models/
│       │   │   │   ├── user_model.dart
│       │   │   │   ├── user_model.freezed.dart      # Generated
│       │   │   │   ├── user_model.g.dart            # Generated
│       │   │   │   ├── auth_response_model.dart
│       │   │   │   └── token_model.dart
│       │   │   └── repositories/
│       │   │       └── auth_repository_impl.dart
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── user.dart
│       │   │   │   └── auth_token.dart
│       │   │   ├── repositories/
│       │   │   │   └── auth_repository.dart
│       │   │   └── usecases/
│       │   │       ├── login_with_google.dart
│       │   │       ├── login_with_apple.dart
│       │   │       ├── login_with_otp.dart
│       │   │       ├── verify_otp.dart
│       │   │       ├── continue_as_guest.dart
│       │   │       ├── logout.dart
│       │   │       └── get_current_user.dart
│       │   │
│       │   └── presentation/
│       │       ├── bloc/
│       │       │   ├── auth_bloc.dart
│       │       │   ├── auth_event.dart
│       │       │   └── auth_state.dart
│       │       ├── views/
│       │       │   ├── login_view.dart
│       │       │   ├── otp_verification_view.dart
│       │       │   └── splash_view.dart
│       │       └── widgets/
│       │           ├── social_login_buttons.dart
│       │           └── phone_form.dart
│       │
│       ├── onboarding/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   └── onboarding_local_datasource.dart
│       │   │   ├── models/
│       │   │   │   ├── onboarding_slide_model.dart
│       │   │   │   └── user_preferences_model.dart
│       │   │   └── repositories/
│       │   │       └── onboarding_repository_impl.dart
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── onboarding_slide.dart
│       │   │   │   └── user_preferences.dart
│       │   │   ├── repositories/
│       │   │   │   └── onboarding_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_onboarding_slides.dart
│       │   │       ├── complete_onboarding.dart
│       │   │       ├── save_city_selection.dart
│       │   │       └── save_interests.dart
│       │   │
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── onboarding_cubit.dart
│       │       │   └── onboarding_state.dart
│       │       ├── views/
│       │       │   ├── onboarding_view.dart
│       │       │   ├── city_selection_view.dart
│       │       │   └── interests_selection_view.dart
│       │       └── widgets/
│       │           ├── onboarding_slide_widget.dart
│       │           ├── page_indicator.dart
│       │           └── skip_button.dart
│       │
│       ├── gyms/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   ├── gyms_remote_datasource.dart
│       │   │   │   └── gyms_local_datasource.dart
│       │   │   ├── models/
│       │   │   │   ├── gym_model.dart
│       │   │   │   ├── gym_filter_model.dart
│       │   │   │   ├── facility_model.dart
│       │   │   │   └── working_hours_model.dart
│       │   │   └── repositories/
│       │   │       └── gyms_repository_impl.dart
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── gym.dart
│       │   │   │   ├── gym_filter.dart
│       │   │   │   ├── facility.dart
│       │   │   │   └── working_hours.dart
│       │   │   ├── repositories/
│       │   │   │   └── gyms_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_gyms.dart
│       │   │       ├── get_gym_details.dart
│       │   │       ├── filter_gyms.dart
│       │   │       ├── get_nearby_gyms.dart
│       │   │       └── search_gyms.dart
│       │   │
│       │   └── presentation/
│       │       ├── bloc/
│       │       │   ├── gyms_bloc.dart
│       │       │   ├── gyms_event.dart
│       │       │   ├── gyms_state.dart
│       │       │   ├── gym_detail_cubit.dart
│       │       │   └── gym_detail_state.dart
│       │       ├── views/
│       │       │   ├── gyms_map_view.dart
│       │       │   ├── gyms_list_view.dart
│       │       │   ├── gym_detail_view.dart
│       │       │   └── gym_filter_view.dart
│       │       └── widgets/
│       │           ├── gym_map_marker.dart
│       │           ├── gym_list_item.dart
│       │           ├── filter_chip_row.dart
│       │           ├── crowd_indicator.dart
│       │           └── facilities_grid.dart
│       │
│       ├── subscriptions/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   ├── subscriptions_remote_datasource.dart
│       │   │   │   └── subscriptions_local_datasource.dart
│       │   │   ├── models/
│       │   │   │   ├── subscription_model.dart
│       │   │   │   ├── bundle_model.dart
│       │   │   │   ├── invoice_model.dart
│       │   │   │   └── payment_model.dart
│       │   │   └── repositories/
│       │   │       └── subscriptions_repository_impl.dart
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── subscription.dart
│       │   │   │   ├── bundle.dart
│       │   │   │   ├── invoice.dart
│       │   │   │   └── payment.dart
│       │   │   ├── repositories/
│       │   │   │   └── subscriptions_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_bundles.dart
│       │   │       ├── get_user_subscription.dart
│       │   │       ├── purchase_subscription.dart
│       │   │       ├── cancel_subscription.dart
│       │   │       ├── toggle_auto_renew.dart
│       │   │       └── get_invoices.dart
│       │   │
│       │   └── presentation/
│       │       ├── bloc/
│       │       │   ├── subscriptions_bloc.dart
│       │       │   ├── subscriptions_event.dart
│       │       │   └── subscriptions_state.dart
│       │       ├── views/
│       │       │   ├── bundles_view.dart
│       │       │   ├── checkout_view.dart
│       │       │   ├── payment_webview.dart
│       │       │   └── invoices_view.dart
│       │       └── widgets/
│       │           ├── bundle_card.dart
│       │           ├── bundle_comparison_table.dart
│       │           ├── invoice_list_item.dart
│       │           └── auto_renew_toggle.dart
│       │
│       ├── qr_checkin/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   ├── qr_remote_datasource.dart
│       │   │   │   └── qr_local_datasource.dart
│       │   │   ├── models/
│       │   │   │   ├── qr_token_model.dart
│       │   │   │   └── checkin_result_model.dart
│       │   │   └── repositories/
│       │   │       └── qr_repository_impl.dart
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── qr_token.dart
│       │   │   │   └── checkin_result.dart
│       │   │   ├── repositories/
│       │   │   │   └── qr_repository.dart
│       │   │   └── usecases/
│       │   │       ├── generate_qr_token.dart
│       │   │       ├── validate_qr_token.dart
│       │   │       └── process_checkin.dart
│       │   │
│       │   └── presentation/
│       │       ├── bloc/
│       │       │   ├── qr_generator_cubit.dart
│       │       │   ├── qr_generator_state.dart
│       │       │   ├── qr_scanner_bloc.dart
│       │       │   ├── qr_scanner_event.dart
│       │       │   └── qr_scanner_state.dart
│       │       ├── views/
│       │       │   ├── qr_display_view.dart
│       │       │   └── qr_scanner_view.dart
│       │       └── widgets/
│       │           ├── animated_qr_code.dart
│       │           ├── countdown_timer.dart
│       │           └── checkin_result_dialog.dart
│       │
│       ├── classes/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   └── classes_remote_datasource.dart
│       │   │   ├── models/
│       │   │   │   ├── fitness_class_model.dart
│       │   │   │   └── class_booking_model.dart
│       │   │   └── repositories/
│       │   │       └── classes_repository_impl.dart
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── fitness_class.dart
│       │   │   │   └── class_booking.dart
│       │   │   ├── repositories/
│       │   │   │   └── classes_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_classes.dart
│       │   │       ├── get_class_schedule.dart
│       │   │       ├── book_class.dart
│       │   │       └── cancel_booking.dart
│       │   │
│       │   └── presentation/
│       │       ├── bloc/
│       │       │   ├── classes_bloc.dart
│       │       │   ├── classes_event.dart
│       │       │   └── classes_state.dart
│       │       ├── views/
│       │       │   ├── classes_calendar_view.dart
│       │       │   ├── class_detail_view.dart
│       │       │   └── my_bookings_view.dart
│       │       └── widgets/
│       │           ├── class_calendar_widget.dart
│       │           ├── class_list_item.dart
│       │           └── booking_confirmation_sheet.dart
│       │
│       ├── rewards/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   └── rewards_remote_datasource.dart
│       │   │   ├── models/
│       │   │   │   ├── reward_model.dart
│       │   │   │   ├── referral_model.dart
│       │   │   │   └── points_transaction_model.dart
│       │   │   └── repositories/
│       │   │       └── rewards_repository_impl.dart
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── reward.dart
│       │   │   │   ├── referral.dart
│       │   │   │   └── points_transaction.dart
│       │   │   ├── repositories/
│       │   │   │   └── rewards_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_rewards.dart
│       │   │       ├── redeem_reward.dart
│       │   │       ├── get_referral_code.dart
│       │   │       ├── apply_referral_code.dart
│       │   │       └── get_points_history.dart
│       │   │
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── rewards_cubit.dart
│       │       │   └── rewards_state.dart
│       │       ├── views/
│       │       │   ├── rewards_view.dart
│       │       │   ├── referrals_view.dart
│       │       │   └── points_history_view.dart
│       │       └── widgets/
│       │           ├── reward_card.dart
│       │           ├── referral_code_widget.dart
│       │           └── points_balance_card.dart
│       │
│       ├── history/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   └── history_remote_datasource.dart
│       │   │   ├── models/
│       │   │   │   └── visit_model.dart
│       │   │   └── repositories/
│       │   │       └── history_repository_impl.dart
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── visit.dart
│       │   │   ├── repositories/
│       │   │   │   └── history_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_visits.dart
│       │   │       └── get_visit_stats.dart
│       │   │
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── history_cubit.dart
│       │       │   └── history_state.dart
│       │       ├── views/
│       │       │   └── visits_history_view.dart
│       │       └── widgets/
│       │           ├── visit_list_item.dart
│       │           └── visit_stats_card.dart
│       │
│       ├── profile/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   └── profile_remote_datasource.dart
│       │   │   ├── models/
│       │   │   │   └── profile_model.dart
│       │   │   └── repositories/
│       │   │       └── profile_repository_impl.dart
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── profile.dart
│       │   │   ├── repositories/
│       │   │   │   └── profile_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_profile.dart
│       │   │       ├── update_profile.dart
│       │   │       └── update_avatar.dart
│       │   │
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── profile_cubit.dart
│       │       │   └── profile_state.dart
│       │       ├── views/
│       │       │   ├── profile_view.dart
│       │       │   └── edit_profile_view.dart
│       │       └── widgets/
│       │           ├── profile_header.dart
│       │           ├── stats_summary_card.dart
│       │           └── subscription_status_card.dart
│       │
│       ├── settings/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   └── settings_local_datasource.dart
│       │   │   ├── models/
│       │   │   │   └── app_settings_model.dart
│       │   │   └── repositories/
│       │   │       └── settings_repository_impl.dart
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   └── app_settings.dart
│       │   │   ├── repositories/
│       │   │   │   └── settings_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_settings.dart
│       │   │       ├── update_language.dart
│       │   │       ├── update_notifications.dart
│       │   │       └── clear_cache.dart
│       │   │
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── settings_cubit.dart
│       │       │   └── settings_state.dart
│       │       ├── views/
│       │       │   ├── settings_view.dart
│       │       │   ├── language_selection_view.dart
│       │       │   └── notification_settings_view.dart
│       │       └── widgets/
│       │           └── settings_tile.dart
│       │
│       ├── partner/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   │   └── partner_remote_datasource.dart
│       │   │   ├── models/
│       │   │   │   ├── partner_gym_model.dart
│       │   │   │   ├── visit_report_model.dart
│       │   │   │   └── revenue_model.dart
│       │   │   └── repositories/
│       │   │       └── partner_repository_impl.dart
│       │   │
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── partner_gym.dart
│       │   │   │   ├── visit_report.dart
│       │   │   │   └── revenue.dart
│       │   │   ├── repositories/
│       │   │   │   └── partner_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_partner_gym.dart
│       │   │       ├── get_visit_reports.dart
│       │   │       ├── get_revenue_stats.dart
│       │   │       ├── update_working_hours.dart
│       │   │       ├── update_visit_limits.dart
│       │   │       └── block_user.dart
│       │   │
│       │   └── presentation/
│       │       ├── bloc/
│       │       │   ├── partner_bloc.dart
│       │       │   ├── partner_event.dart
│       │       │   └── partner_state.dart
│       │       ├── views/
│       │       │   ├── partner_dashboard_view.dart
│       │       │   ├── partner_scanner_view.dart
│       │       │   ├── partner_reports_view.dart
│       │       │   └── partner_settings_view.dart
│       │       └── widgets/
│       │           ├── visit_chart.dart
│       │           ├── peak_hours_chart.dart
│       │           └── revenue_summary_card.dart
│       │
│       └── admin/
│           ├── data/
│           │   ├── datasources/
│           │   │   └── admin_remote_datasource.dart
│           │   ├── models/
│           │   │   ├── admin_gym_model.dart
│           │   │   ├── admin_stats_model.dart
│           │   │   └── gym_form_model.dart
│           │   └── repositories/
│           │       └── admin_repository_impl.dart
│           │
│           ├── domain/
│           │   ├── entities/
│           │   │   ├── admin_gym.dart
│           │   │   └── admin_stats.dart
│           │   ├── repositories/
│           │   │   └── admin_repository.dart
│           │   └── usecases/
│           │       ├── get_all_gyms.dart
│           │       ├── add_gym.dart
│           │       ├── update_gym.dart
│           │       ├── delete_gym.dart
│           │       ├── change_gym_status.dart
│           │       └── get_dashboard_stats.dart
│           │
│           └── presentation/
│               ├── bloc/
│               │   ├── admin_bloc.dart
│               │   ├── admin_event.dart
│               │   └── admin_state.dart
│               ├── views/
│               │   ├── admin_dashboard_view.dart
│               │   ├── gyms_table_view.dart
│               │   ├── add_gym_view.dart
│               │   └── edit_gym_view.dart
│               └── widgets/
│                   ├── gyms_data_table.dart
│                   ├── stats_overview_cards.dart
│                   ├── gym_form.dart
│                   └── status_badge.dart
│
├── l10n/
│   ├── app_en.arb
│   └── app_ar.arb
│
└── assets/
    ├── images/
    │   ├── logo.png
    │   ├── onboarding/
    │   └── placeholders/
    ├── icons/
    │   └── svg/
    ├── animations/
    │   └── lottie/
    └── fonts/
```

---

## Feature Modules Summary

### A. Auth Feature
- **Views**: SplashView, LoginView, OTPVerificationView
- **Bloc**: AuthBloc (handles login states)
- **Use Cases**: LoginWithGoogle, LoginWithApple, LoginWithOTP, VerifyOTP, ContinueAsGuest, Logout
- **Repository**: AuthRepository (Firebase Auth + API integration)

### B. Onboarding Feature
- **Views**: OnboardingView, CitySelectionView, InterestsSelectionView
- **Cubit**: OnboardingCubit
- **Use Cases**: GetOnboardingSlides, CompleteOnboarding, SaveCitySelection, SaveInterests

### C. Gyms Feature
- **Views**: GymsMapView, GymsListView, GymDetailView, GymFilterView
- **Bloc**: GymsBloc, GymDetailCubit
- **Use Cases**: GetGyms, GetGymDetails, FilterGyms, GetNearbyGyms, SearchGyms
- **Special**: Google Maps integration, Geolocator for location

### D. Subscriptions Feature
- **Views**: BundlesView, CheckoutView, PaymentWebView, InvoicesView
- **Bloc**: SubscriptionsBloc
- **Use Cases**: GetBundles, GetUserSubscription, PurchaseSubscription, CancelSubscription, ToggleAutoRenew, GetInvoices
- **Special**: WebView for payment gateways (Kashier, Instapay, Paymob, PayTabs)

### E. QR Check-in Feature
- **Views**: QRDisplayView (member), QRScannerView (partner)
- **Blocs**: QRGeneratorCubit, QRScannerBloc
- **Use Cases**: GenerateQRToken, ValidateQRToken, ProcessCheckin
- **Special**: JWT-based tokens with 30-60s refresh

### F. Classes Feature
- **Views**: ClassesCalendarView, ClassDetailView, MyBookingsView
- **Bloc**: ClassesBloc
- **Use Cases**: GetClasses, GetClassSchedule, BookClass, CancelBooking
- **Special**: table_calendar integration

### G. Rewards Feature
- **Views**: RewardsView, ReferralsView, PointsHistoryView
- **Cubit**: RewardsCubit
- **Use Cases**: GetRewards, RedeemReward, GetReferralCode, ApplyReferralCode, GetPointsHistory

### H. Partner Feature
- **Views**: PartnerDashboardView, PartnerScannerView, PartnerReportsView, PartnerSettingsView
- **Bloc**: PartnerBloc
- **Use Cases**: GetPartnerGym, GetVisitReports, GetRevenueStats, UpdateWorkingHours, UpdateVisitLimits, BlockUser
- **Special**: Charts using syncfusion_flutter_charts

### I. Admin Feature
- **Views**: AdminDashboardView, GymsTableView, AddGymView, EditGymView
- **Bloc**: AdminBloc
- **Use Cases**: GetAllGyms, AddGym, UpdateGym, DeleteGym, ChangeGymStatus, GetDashboardStats
- **Special**: data_table_2 for tables, NavigationRail for web layout

---

## Routing Architecture

### Route Guards
1. **AuthGuard**: Redirects unauthenticated users to login
2. **RoleGuard**: Restricts routes based on user role (member/partner/admin)
3. **SubscriptionGuard**: Ensures active subscription for certain features

### Route Structure
```dart
/                           # Root (redirects based on auth state)
├── /splash                 # Splash screen
├── /onboarding             # Onboarding flow
│   ├── /slides
│   ├── /city
│   └── /interests
├── /auth
│   ├── /login
│   └── /otp
│
├── /member                 # Member routes (requires auth + member role)
│   ├── /home               # Home with bottom nav
│   ├── /gyms
│   │   ├── /map
│   │   ├── /list
│   │   └── /:gymId
│   ├── /subscriptions
│   │   ├── /bundles
│   │   ├── /checkout/:bundleId
│   │   ├── /payment
│   │   └── /invoices
│   ├── /qr                 # QR display for check-in
│   ├── /classes
│   │   ├── /calendar
│   │   ├── /:classId
│   │   └── /bookings
│   ├── /rewards
│   │   ├── /list
│   │   ├── /referrals
│   │   └── /history
│   ├── /history            # Visit history
│   ├── /profile
│   │   ├── /view
│   │   └── /edit
│   └── /settings
│       ├── /language
│       └── /notifications
│
├── /partner                # Partner routes (requires auth + partner role)
│   ├── /dashboard
│   ├── /scanner            # QR scanner for check-in
│   ├── /reports
│   └── /settings
│
└── /admin                  # Admin routes (requires auth + admin role, web only)
    ├── /dashboard
    ├── /gyms
    │   ├── /list
    │   ├── /add
    │   └── /edit/:gymId
    └── /settings
```

---

## Dependency Injection Setup

Using `get_it` + `injectable` for compile-time safe DI.

### Module Registration
```dart
// injection.dart
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

// Modules
@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio => DioClient.createDio();
  
  @lazySingleton
  ApiClient get apiClient => ApiClient(dio);
}

@module
abstract class StorageModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
  
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}

@module
abstract class FirebaseModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;
  
  @lazySingleton
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;
}
```

---

## QR Security Design

### Token Structure (JWT)
```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "userId": "user_123",
    "gymId": "gym_456",
    "subscriptionId": "sub_789",
    "timestamp": 1705574400,
    "nonce": "abc123xyz",
    "exp": 1705574460
  }
}
```

### Validation Flow
```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Member    │     │   Partner   │     │   Server    │
│   App       │     │   Scanner   │     │             │
└──────┬──────┘     └──────┬──────┘     └──────┬──────┘
       │                   │                   │
       │ Generate QR       │                   │
       │ ─────────────────>│                   │
       │                   │                   │
       │                   │ Scan & Send Token │
       │                   │ ─────────────────>│
       │                   │                   │
       │                   │                   │ Validate:
       │                   │                   │ - JWT signature
       │                   │                   │ - Token not expired
       │                   │                   │ - Nonce not used
       │                   │                   │ - Subscription active
       │                   │                   │ - Visit limit not exceeded
       │                   │                   │ - (Optional) Geofence check
       │                   │                   │
       │                   │   Result          │
       │                   │ <─────────────────│
       │                   │                   │
       │ Push Notification │                   │
       │ <─────────────────│                   │
       │                   │                   │
```

---

## Web Layout Architecture

### NavigationRail for Admin/Partner Dashboard
```dart
class WebScaffold extends StatelessWidget {
  // Responsive breakpoints:
  // - Mobile: < 600px (Bottom Navigation)
  // - Tablet: 600px - 1200px (NavigationRail collapsed)
  // - Desktop: > 1200px (NavigationRail expanded)
}
```

---

## State Management Pattern

Using `flutter_bloc` with:
- **Bloc**: For complex features with multiple events (Auth, Gyms, Subscriptions)
- **Cubit**: For simpler state management (Profile, Settings, QR Generator)

### Example Bloc Structure
```dart
// Events
abstract class AuthEvent {}
class LoginWithGoogleEvent extends AuthEvent {}
class LoginWithAppleEvent extends AuthEvent {}
class LoginWithOTPEvent extends AuthEvent {
  final String phoneNumber;
}
class VerifyOTPEvent extends AuthEvent {
  final String otp;
}

// States
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
}
```

---

## API Client Design (Retrofit)

```dart
@RestApi(baseUrl: ApiEndpoints.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // Auth
  @POST('/auth/google')
  Future<AuthResponse> loginWithGoogle(@Body() GoogleLoginRequest request);

  // Gyms
  @GET('/gyms')
  Future<PaginatedResponse<GymModel>> getGyms(@Queries() GymFilterModel filters);

  @GET('/gyms/{id}')
  Future<GymModel> getGymById(@Path('id') String id);

  // Subscriptions
  @GET('/bundles')
  Future<List<BundleModel>> getBundles();

  @POST('/subscriptions')
  Future<SubscriptionModel> createSubscription(@Body() CreateSubscriptionRequest request);
}
```

---

## Data Flow Example

### Login with Google Flow
```
┌─────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER                              │
│                                                                          │
│  LoginView ──> AuthBloc.add(LoginWithGoogleEvent)                       │
│                     │                                                    │
│                     ▼                                                    │
│              AuthBloc.mapEventToState                                   │
│                     │                                                    │
└─────────────────────│────────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                           DOMAIN LAYER                                   │
│                                                                          │
│              LoginWithGoogleUseCase.execute()                           │
│                     │                                                    │
│                     ▼                                                    │
│              AuthRepository.loginWithGoogle()                           │
│                                                                          │
└─────────────────────│────────────────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                            DATA LAYER                                    │
│                                                                          │
│              AuthRepositoryImpl.loginWithGoogle()                       │
│                     │                                                    │
│       ┌─────────────┴─────────────┐                                     │
│       ▼                           ▼                                     │
│  FirebaseAuth               ApiClient                                   │
│  .signInWithGoogle()        .loginWithGoogle()                          │
│       │                           │                                     │
│       └─────────────┬─────────────┘                                     │
│                     ▼                                                    │
│              Return User Entity                                         │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Environment Configuration

### Flavor Configuration
```dart
enum Environment { development, staging, production }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final String googleMapsApiKey;
  final bool enableAnalytics;
  
  static late AppConfig instance;
  
  static void initialize(Environment env) {
    switch (env) {
      case Environment.development:
        instance = AppConfig._(
          environment: env,
          apiBaseUrl: 'https://dev-api.mygym.com',
          googleMapsApiKey: 'DEV_KEY',
          enableAnalytics: false,
        );
        break;
      case Environment.production:
        instance = AppConfig._(
          environment: env,
          apiBaseUrl: 'https://api.mygym.com',
          googleMapsApiKey: 'PROD_KEY',
          enableAnalytics: true,
        );
        break;
    }
  }
}
```

---

## Code Generation Commands

```bash
# Generate all (freezed, json_serializable, injectable, retrofit)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode
flutter pub run build_runner watch --delete-conflicting-outputs

# Generate localization
flutter gen-l10n
```

---

## Testing Structure

```
test/
├── unit/
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl_test.dart
│   │   │   └── domain/
│   │   │       └── usecases/
│   │   │           └── login_with_google_test.dart
│   │   └── ...
│   └── core/
│       └── network/
│           └── dio_client_test.dart
├── widget/
│   ├── features/
│   │   └── auth/
│   │       └── views/
│   │           └── login_view_test.dart
│   └── core/
│       └── widgets/
│           └── primary_button_test.dart
├── integration/
│   └── app_test.dart
└── mocks/
    ├── mock_repositories.dart
    └── mock_blocs.dart
```

---

## Summary

This architecture provides:

1. **Separation of Concerns**: Clear boundaries between layers
2. **Testability**: Each layer can be tested independently
3. **Scalability**: Feature-driven structure allows parallel development
4. **Maintainability**: Consistent patterns across features
5. **Type Safety**: Freezed models and injectable DI
6. **Platform Support**: Responsive design for mobile, tablet, and web
7. **Security**: JWT-based QR tokens with server-side validation
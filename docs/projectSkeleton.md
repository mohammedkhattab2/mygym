# MyGym - Project Skeleton

This document contains the complete project skeleton output in JSON format.

## Project Skeleton JSON

```json
{
  "projectStructure": {
    "lib": {
      "main.dart": "App entry point",
      "main_development.dart": "Development flavor entry",
      "main_staging.dart": "Staging flavor entry",
      "main_production.dart": "Production flavor entry",
      "app.dart": "Root App widget with MaterialApp/GoRouter",
      "bootstrap.dart": "App initialization (DI, Firebase, Hive)",
      "src": {
        "core": {
          "constants": {
            "app_constants.dart": "Global app constants",
            "api_endpoints.dart": "API endpoint URLs",
            "storage_keys.dart": "Hive/SecureStorage keys",
            "asset_paths.dart": "Asset path constants"
          },
          "config": {
            "app_config.dart": "App configuration singleton",
            "environment.dart": "Environment enum",
            "flavor_config.dart": "Flavor configuration"
          },
          "di": {
            "injection.dart": "GetIt setup with injectable",
            "injection.config.dart": "Generated DI config",
            "modules": {
              "network_module.dart": "Dio, ApiClient registration",
              "storage_module.dart": "Hive, SecureStorage registration",
              "firebase_module.dart": "Firebase services registration"
            }
          },
          "error": {
            "exceptions.dart": "Custom exceptions",
            "failures.dart": "Failure classes for Either",
            "error_handler.dart": "Global error handler"
          },
          "network": {
            "api_client.dart": "Retrofit API client interface",
            "api_client.g.dart": "Generated Retrofit implementation",
            "dio_client.dart": "Dio instance factory",
            "interceptors": {
              "auth_interceptor.dart": "JWT token injection",
              "error_interceptor.dart": "Error response handling",
              "logging_interceptor.dart": "Request/response logging"
            },
            "network_info.dart": "Connectivity checker"
          },
          "router": {
            "app_router.dart": "GoRouter configuration",
            "route_names.dart": "Named route constants",
            "route_paths.dart": "Route path constants",
            "guards": {
              "auth_guard.dart": "Authentication redirect",
              "role_guard.dart": "Role-based access control",
              "subscription_guard.dart": "Subscription validation"
            },
            "routes": {
              "auth_routes.dart": "Auth route definitions",
              "member_routes.dart": "Member route definitions",
              "partner_routes.dart": "Partner route definitions",
              "admin_routes.dart": "Admin route definitions"
            }
          },
          "storage": {
            "secure_storage.dart": "FlutterSecureStorage wrapper",
            "hive_storage.dart": "Hive box manager",
            "cache_manager.dart": "Cache expiry manager"
          },
          "theme": {
            "app_theme.dart": "ThemeData configuration",
            "app_colors.dart": "Color palette",
            "app_text_styles.dart": "Typography styles",
            "app_dimensions.dart": "Spacing, sizing constants"
          },
          "utils": {
            "extensions": {
              "context_extensions.dart": "BuildContext extensions",
              "string_extensions.dart": "String utilities",
              "date_extensions.dart": "DateTime utilities",
              "num_extensions.dart": "Number formatting"
            },
            "helpers": {
              "date_helper.dart": "Date formatting helper",
              "validation_helper.dart": "Input validation",
              "format_helper.dart": "Currency, number formatting"
            },
            "logger.dart": "Logging utility"
          },
          "widgets": {
            "buttons": {
              "primary_button.dart": "Primary CTA button",
              "secondary_button.dart": "Secondary button",
              "social_button.dart": "Social login button"
            },
            "inputs": {
              "custom_text_field.dart": "Styled text field",
              "phone_input.dart": "Phone number input",
              "otp_input.dart": "OTP code input"
            },
            "loading": {
              "loading_overlay.dart": "Full screen loader",
              "skeleton_loader.dart": "Skeleton placeholder",
              "shimmer_widget.dart": "Shimmer effect"
            },
            "dialogs": {
              "confirm_dialog.dart": "Confirmation dialog",
              "error_dialog.dart": "Error display dialog"
            },
            "cards": {
              "gym_card.dart": "Gym preview card",
              "subscription_card.dart": "Subscription info card"
            },
            "layouts": {
              "responsive_layout.dart": "Responsive breakpoint builder",
              "web_scaffold.dart": "Web layout with NavigationRail",
              "navigation_rail_layout.dart": "NavigationRail wrapper"
            }
          }
        },
        "features": {
          "auth": {
            "data": {
              "datasources": {
                "auth_remote_datasource.dart": "Firebase + API auth",
                "auth_local_datasource.dart": "Token storage"
              },
              "models": {
                "user_model.dart": "User DTO",
                "user_model.freezed.dart": "Generated freezed",
                "user_model.g.dart": "Generated json_serializable",
                "auth_response_model.dart": "Auth API response",
                "token_model.dart": "JWT token model"
              },
              "repositories": {
                "auth_repository_impl.dart": "AuthRepository implementation"
              }
            },
            "domain": {
              "entities": {
                "user.dart": "User entity",
                "auth_token.dart": "Token entity"
              },
              "repositories": {
                "auth_repository.dart": "AuthRepository interface"
              },
              "usecases": {
                "login_with_google.dart": "Google sign-in use case",
                "login_with_apple.dart": "Apple sign-in use case",
                "login_with_otp.dart": "OTP request use case",
                "verify_otp.dart": "OTP verification use case",
                "continue_as_guest.dart": "Guest mode use case",
                "logout.dart": "Logout use case",
                "get_current_user.dart": "Current user use case"
              }
            },
            "presentation": {
              "bloc": {
                "auth_bloc.dart": "Auth business logic",
                "auth_event.dart": "Auth events",
                "auth_state.dart": "Auth states"
              },
              "views": {
                "login_view.dart": "Login screen",
                "otp_verification_view.dart": "OTP input screen",
                "splash_view.dart": "Splash screen"
              },
              "widgets": {
                "social_login_buttons.dart": "Google/Apple buttons",
                "phone_form.dart": "Phone number form"
              }
            }
          },
          "onboarding": {
            "data": {
              "datasources": {
                "onboarding_local_datasource.dart": "Onboarding state storage"
              },
              "models": {
                "onboarding_slide_model.dart": "Slide content model",
                "user_preferences_model.dart": "City/interests model"
              },
              "repositories": {
                "onboarding_repository_impl.dart": "OnboardingRepository impl"
              }
            },
            "domain": {
              "entities": {
                "onboarding_slide.dart": "Slide entity",
                "user_preferences.dart": "Preferences entity"
              },
              "repositories": {
                "onboarding_repository.dart": "OnboardingRepository interface"
              },
              "usecases": {
                "get_onboarding_slides.dart": "Get slides use case",
                "complete_onboarding.dart": "Mark complete use case",
                "save_city_selection.dart": "Save city use case",
                "save_interests.dart": "Save interests use case"
              }
            },
            "presentation": {
              "cubit": {
                "onboarding_cubit.dart": "Onboarding state management",
                "onboarding_state.dart": "Onboarding states"
              },
              "views": {
                "onboarding_view.dart": "Slides screen",
                "city_selection_view.dart": "City picker screen",
                "interests_selection_view.dart": "Interests picker screen"
              },
              "widgets": {
                "onboarding_slide_widget.dart": "Single slide widget",
                "page_indicator.dart": "Dots indicator",
                "skip_button.dart": "Skip button"
              }
            }
          },
          "gyms": {
            "data": {
              "datasources": {
                "gyms_remote_datasource.dart": "Gyms API calls",
                "gyms_local_datasource.dart": "Cached gyms"
              },
              "models": {
                "gym_model.dart": "Gym DTO",
                "gym_filter_model.dart": "Filter parameters",
                "facility_model.dart": "Facility DTO",
                "working_hours_model.dart": "Hours DTO"
              },
              "repositories": {
                "gyms_repository_impl.dart": "GymsRepository implementation"
              }
            },
            "domain": {
              "entities": {
                "gym.dart": "Gym entity",
                "gym_filter.dart": "Filter entity",
                "facility.dart": "Facility entity",
                "working_hours.dart": "Hours entity"
              },
              "repositories": {
                "gyms_repository.dart": "GymsRepository interface"
              },
              "usecases": {
                "get_gyms.dart": "List gyms use case",
                "get_gym_details.dart": "Gym detail use case",
                "filter_gyms.dart": "Filter use case",
                "get_nearby_gyms.dart": "Nearby gyms use case",
                "search_gyms.dart": "Search use case"
              }
            },
            "presentation": {
              "bloc": {
                "gyms_bloc.dart": "Gyms list logic",
                "gyms_event.dart": "Gyms events",
                "gyms_state.dart": "Gyms states",
                "gym_detail_cubit.dart": "Detail logic",
                "gym_detail_state.dart": "Detail states"
              },
              "views": {
                "gyms_map_view.dart": "Map screen",
                "gyms_list_view.dart": "List screen",
                "gym_detail_view.dart": "Detail screen",
                "gym_filter_view.dart": "Filter sheet"
              },
              "widgets": {
                "gym_map_marker.dart": "Custom map marker",
                "gym_list_item.dart": "Gym list tile",
                "filter_chip_row.dart": "Filter chips",
                "crowd_indicator.dart": "Crowd level widget",
                "facilities_grid.dart": "Facilities display"
              }
            }
          },
          "subscriptions": {
            "data": {
              "datasources": {
                "subscriptions_remote_datasource.dart": "Subscriptions API",
                "subscriptions_local_datasource.dart": "Cached subscription"
              },
              "models": {
                "subscription_model.dart": "Subscription DTO",
                "bundle_model.dart": "Bundle DTO",
                "invoice_model.dart": "Invoice DTO",
                "payment_model.dart": "Payment DTO"
              },
              "repositories": {
                "subscriptions_repository_impl.dart": "SubscriptionsRepository impl"
              }
            },
            "domain": {
              "entities": {
                "subscription.dart": "Subscription entity",
                "bundle.dart": "Bundle entity",
                "invoice.dart": "Invoice entity",
                "payment.dart": "Payment entity"
              },
              "repositories": {
                "subscriptions_repository.dart": "SubscriptionsRepository interface"
              },
              "usecases": {
                "get_bundles.dart": "List bundles use case",
                "get_user_subscription.dart": "Current subscription use case",
                "purchase_subscription.dart": "Purchase use case",
                "cancel_subscription.dart": "Cancel use case",
                "toggle_auto_renew.dart": "Auto-renew use case",
                "get_invoices.dart": "Invoices list use case"
              }
            },
            "presentation": {
              "bloc": {
                "subscriptions_bloc.dart": "Subscriptions logic",
                "subscriptions_event.dart": "Subscriptions events",
                "subscriptions_state.dart": "Subscriptions states"
              },
              "views": {
                "bundles_view.dart": "Bundles screen",
                "checkout_view.dart": "Checkout screen",
                "payment_webview.dart": "Payment WebView",
                "invoices_view.dart": "Invoices screen"
              },
              "widgets": {
                "bundle_card.dart": "Bundle card widget",
                "bundle_comparison_table.dart": "Comparison table",
                "invoice_list_item.dart": "Invoice item",
                "auto_renew_toggle.dart": "Toggle widget"
              }
            }
          },
          "qr_checkin": {
            "data": {
              "datasources": {
                "qr_remote_datasource.dart": "QR API calls",
                "qr_local_datasource.dart": "Token cache"
              },
              "models": {
                "qr_token_model.dart": "QR token DTO",
                "checkin_result_model.dart": "Check-in result DTO"
              },
              "repositories": {
                "qr_repository_impl.dart": "QRRepository implementation"
              }
            },
            "domain": {
              "entities": {
                "qr_token.dart": "QR token entity",
                "checkin_result.dart": "Check-in result entity"
              },
              "repositories": {
                "qr_repository.dart": "QRRepository interface"
              },
              "usecases": {
                "generate_qr_token.dart": "Generate token use case",
                "validate_qr_token.dart": "Validate token use case",
                "process_checkin.dart": "Process check-in use case"
              }
            },
            "presentation": {
              "bloc": {
                "qr_generator_cubit.dart": "QR generator logic",
                "qr_generator_state.dart": "Generator states",
                "qr_scanner_bloc.dart": "Scanner logic",
                "qr_scanner_event.dart": "Scanner events",
                "qr_scanner_state.dart": "Scanner states"
              },
              "views": {
                "qr_display_view.dart": "QR display screen",
                "qr_scanner_view.dart": "Scanner screen"
              },
              "widgets": {
                "animated_qr_code.dart": "Animated QR widget",
                "countdown_timer.dart": "Token expiry timer",
                "checkin_result_dialog.dart": "Result dialog"
              }
            }
          },
          "classes": {
            "data": {
              "datasources": {
                "classes_remote_datasource.dart": "Classes API"
              },
              "models": {
                "fitness_class_model.dart": "Class DTO",
                "class_booking_model.dart": "Booking DTO"
              },
              "repositories": {
                "classes_repository_impl.dart": "ClassesRepository impl"
              }
            },
            "domain": {
              "entities": {
                "fitness_class.dart": "Class entity",
                "class_booking.dart": "Booking entity"
              },
              "repositories": {
                "classes_repository.dart": "ClassesRepository interface"
              },
              "usecases": {
                "get_classes.dart": "List classes use case",
                "get_class_schedule.dart": "Schedule use case",
                "book_class.dart": "Book class use case",
                "cancel_booking.dart": "Cancel booking use case"
              }
            },
            "presentation": {
              "bloc": {
                "classes_bloc.dart": "Classes logic",
                "classes_event.dart": "Classes events",
                "classes_state.dart": "Classes states"
              },
              "views": {
                "classes_calendar_view.dart": "Calendar screen",
                "class_detail_view.dart": "Class detail screen",
                "my_bookings_view.dart": "My bookings screen"
              },
              "widgets": {
                "class_calendar_widget.dart": "Calendar widget",
                "class_list_item.dart": "Class list item",
                "booking_confirmation_sheet.dart": "Booking sheet"
              }
            }
          },
          "rewards": {
            "data": {
              "datasources": {
                "rewards_remote_datasource.dart": "Rewards API"
              },
              "models": {
                "reward_model.dart": "Reward DTO",
                "referral_model.dart": "Referral DTO",
                "points_transaction_model.dart": "Transaction DTO"
              },
              "repositories": {
                "rewards_repository_impl.dart": "RewardsRepository impl"
              }
            },
            "domain": {
              "entities": {
                "reward.dart": "Reward entity",
                "referral.dart": "Referral entity",
                "points_transaction.dart": "Transaction entity"
              },
              "repositories": {
                "rewards_repository.dart": "RewardsRepository interface"
              },
              "usecases": {
                "get_rewards.dart": "List rewards use case",
                "redeem_reward.dart": "Redeem use case",
                "get_referral_code.dart": "Get code use case",
                "apply_referral_code.dart": "Apply code use case",
                "get_points_history.dart": "History use case"
              }
            },
            "presentation": {
              "cubit": {
                "rewards_cubit.dart": "Rewards logic",
                "rewards_state.dart": "Rewards states"
              },
              "views": {
                "rewards_view.dart": "Rewards screen",
                "referrals_view.dart": "Referrals screen",
                "points_history_view.dart": "History screen"
              },
              "widgets": {
                "reward_card.dart": "Reward card",
                "referral_code_widget.dart": "Code display",
                "points_balance_card.dart": "Balance card"
              }
            }
          },
          "history": {
            "data": {
              "datasources": {
                "history_remote_datasource.dart": "History API"
              },
              "models": {
                "visit_model.dart": "Visit DTO"
              },
              "repositories": {
                "history_repository_impl.dart": "HistoryRepository impl"
              }
            },
            "domain": {
              "entities": {
                "visit.dart": "Visit entity"
              },
              "repositories": {
                "history_repository.dart": "HistoryRepository interface"
              },
              "usecases": {
                "get_visits.dart": "List visits use case",
                "get_visit_stats.dart": "Stats use case"
              }
            },
            "presentation": {
              "cubit": {
                "history_cubit.dart": "History logic",
                "history_state.dart": "History states"
              },
              "views": {
                "visits_history_view.dart": "History screen"
              },
              "widgets": {
                "visit_list_item.dart": "Visit item",
                "visit_stats_card.dart": "Stats card"
              }
            }
          },
          "profile": {
            "data": {
              "datasources": {
                "profile_remote_datasource.dart": "Profile API"
              },
              "models": {
                "profile_model.dart": "Profile DTO"
              },
              "repositories": {
                "profile_repository_impl.dart": "ProfileRepository impl"
              }
            },
            "domain": {
              "entities": {
                "profile.dart": "Profile entity"
              },
              "repositories": {
                "profile_repository.dart": "ProfileRepository interface"
              },
              "usecases": {
                "get_profile.dart": "Get profile use case",
                "update_profile.dart": "Update use case",
                "update_avatar.dart": "Avatar use case"
              }
            },
            "presentation": {
              "cubit": {
                "profile_cubit.dart": "Profile logic",
                "profile_state.dart": "Profile states"
              },
              "views": {
                "profile_view.dart": "Profile screen",
                "edit_profile_view.dart": "Edit screen"
              },
              "widgets": {
                "profile_header.dart": "Header widget",
                "stats_summary_card.dart": "Stats card",
                "subscription_status_card.dart": "Status card"
              }
            }
          },
          "settings": {
            "data": {
              "datasources": {
                "settings_local_datasource.dart": "Settings storage"
              },
              "models": {
                "app_settings_model.dart": "Settings DTO"
              },
              "repositories": {
                "settings_repository_impl.dart": "SettingsRepository impl"
              }
            },
            "domain": {
              "entities": {
                "app_settings.dart": "Settings entity"
              },
              "repositories": {
                "settings_repository.dart": "SettingsRepository interface"
              },
              "usecases": {
                "get_settings.dart": "Get settings use case",
                "update_language.dart": "Language use case",
                "update_notifications.dart": "Notifications use case",
                "clear_cache.dart": "Clear cache use case"
              }
            },
            "presentation": {
              "cubit": {
                "settings_cubit.dart": "Settings logic",
                "settings_state.dart": "Settings states"
              },
              "views": {
                "settings_view.dart": "Settings screen",
                "language_selection_view.dart": "Language screen",
                "notification_settings_view.dart": "Notifications screen"
              },
              "widgets": {
                "settings_tile.dart": "Settings tile"
              }
            }
          },
          "partner": {
            "data": {
              "datasources": {
                "partner_remote_datasource.dart": "Partner API"
              },
              "models": {
                "partner_gym_model.dart": "Partner gym DTO",
                "visit_report_model.dart": "Report DTO",
                "revenue_model.dart": "Revenue DTO"
              },
              "repositories": {
                "partner_repository_impl.dart": "PartnerRepository impl"
              }
            },
            "domain": {
              "entities": {
                "partner_gym.dart": "Partner gym entity",
                "visit_report.dart": "Report entity",
                "revenue.dart": "Revenue entity"
              },
              "repositories": {
                "partner_repository.dart": "PartnerRepository interface"
              },
              "usecases": {
                "get_partner_gym.dart": "Get gym use case",
                "get_visit_reports.dart": "Reports use case",
                "get_revenue_stats.dart": "Revenue use case",
                "update_working_hours.dart": "Hours use case",
                "update_visit_limits.dart": "Limits use case",
                "block_user.dart": "Block user use case"
              }
            },
            "presentation": {
              "bloc": {
                "partner_bloc.dart": "Partner logic",
                "partner_event.dart": "Partner events",
                "partner_state.dart": "Partner states"
              },
              "views": {
                "partner_dashboard_view.dart": "Dashboard screen",
                "partner_scanner_view.dart": "Scanner screen",
                "partner_reports_view.dart": "Reports screen",
                "partner_settings_view.dart": "Settings screen"
              },
              "widgets": {
                "visit_chart.dart": "Visit chart",
                "peak_hours_chart.dart": "Peak hours chart",
                "revenue_summary_card.dart": "Revenue card"
              }
            }
          },
          "admin": {
            "data": {
              "datasources": {
                "admin_remote_datasource.dart": "Admin API"
              },
              "models": {
                "admin_gym_model.dart": "Admin gym DTO",
                "admin_stats_model.dart": "Stats DTO",
                "gym_form_model.dart": "Form DTO"
              },
              "repositories": {
                "admin_repository_impl.dart": "AdminRepository impl"
              }
            },
            "domain": {
              "entities": {
                "admin_gym.dart": "Admin gym entity",
                "admin_stats.dart": "Stats entity"
              },
              "repositories": {
                "admin_repository.dart": "AdminRepository interface"
              },
              "usecases": {
                "get_all_gyms.dart": "List gyms use case",
                "add_gym.dart": "Add gym use case",
                "update_gym.dart": "Update gym use case",
                "delete_gym.dart": "Delete gym use case",
                "change_gym_status.dart": "Status use case",
                "get_dashboard_stats.dart": "Dashboard stats use case"
              }
            },
            "presentation": {
              "bloc": {
                "admin_bloc.dart": "Admin logic",
                "admin_event.dart": "Admin events",
                "admin_state.dart": "Admin states"
              },
              "views": {
                "admin_dashboard_view.dart": "Dashboard screen",
                "gyms_table_view.dart": "Gyms table screen",
                "add_gym_view.dart": "Add gym screen",
                "edit_gym_view.dart": "Edit gym screen"
              },
              "widgets": {
                "gyms_data_table.dart": "Data table",
                "stats_overview_cards.dart": "Stats cards",
                "gym_form.dart": "Gym form",
                "status_badge.dart": "Status badge"
              }
            }
          }
        }
      },
      "l10n": {
        "app_en.arb": "English translations",
        "app_ar.arb": "Arabic translations"
      },
      "assets": {
        "images": {
          "logo.png": "App logo",
          "onboarding": "Onboarding images",
          "placeholders": "Placeholder images"
        },
        "icons": {
          "svg": "SVG icons"
        },
        "animations": {
          "lottie": "Lottie animation files"
        },
        "fonts": "Custom fonts"
      }
    }
  },
  "dependencyConfig": {
    "dependencies": {
      "flutter": { "sdk": "flutter" },
      "flutter_localizations": { "sdk": "flutter" },
      "cupertino_icons": "^1.0.8",
      
      "flutter_bloc": "^8.1.3",
      "bloc": "^8.1.2",
      
      "go_router": "^13.0.0",
      
      "dio": "^5.4.0",
      "retrofit": "^4.0.3",
      "pretty_dio_logger": "^1.3.1",
      
      "hive": "^2.2.3",
      "hive_flutter": "^1.1.0",
      
      "get_it": "^7.6.4",
      "injectable": "^2.3.2",
      
      "freezed_annotation": "^2.4.1",
      "json_annotation": "^4.8.1",
      
      "flutter_secure_storage": "^9.0.0",
      
      "google_maps_flutter": "^2.5.0",
      "geolocator": "^10.1.0",
      "geocoding": "^2.1.1",
      
      "qr_flutter": "^4.1.0",
      "qr_code_scanner": "^1.0.1",
      
      "skeletonizer": "^1.0.0",
      
      "webview_flutter": "^4.4.2",
      
      "cached_network_image": "^3.3.0",
      
      "google_fonts": "^6.1.0",
      "flutter_svg": "^2.0.9",
      
      "flutter_screenutil": "^5.9.0",
      
      "lottie": "^2.7.0",
      
      "easy_localization": "^3.0.3",
      
      "firebase_core": "^2.24.2",
      "firebase_auth": "^4.16.0",
      "firebase_messaging": "^14.7.9",
      "firebase_analytics": "^10.7.4",
      "firebase_crashlytics": "^3.4.9",
      "google_sign_in": "^6.2.1",
      "sign_in_with_apple": "^5.0.0",
      
      "table_calendar": "^3.0.9",
      
      "syncfusion_flutter_charts": "^24.1.41",
      "data_table_2": "^2.5.8",
      
      "dartz": "^0.10.1",
      "equatable": "^2.0.5",
      "connectivity_plus": "^5.0.2",
      "shared_preferences": "^2.2.2",
      "image_picker": "^1.0.7",
      "permission_handler": "^11.1.0",
      "url_launcher": "^6.2.2",
      "intl": "^0.18.1",
      "uuid": "^4.2.2",
      "dart_jsonwebtoken": "^2.12.0"
    },
    "dev_dependencies": {
      "flutter_test": { "sdk": "flutter" },
      "flutter_lints": "^3.0.1",
      
      "build_runner": "^2.4.7",
      "freezed": "^2.4.5",
      "json_serializable": "^6.7.1",
      "injectable_generator": "^2.4.1",
      "retrofit_generator": "^8.0.6",
      "hive_generator": "^2.0.1",
      
      "bloc_test": "^9.1.5",
      "mocktail": "^1.0.1",
      "mockito": "^5.4.4"
    }
  },
  "diSetup": {
    "injection.dart": "import 'package:get_it/get_it.dart';\nimport 'package:injectable/injectable.dart';\nimport 'injection.config.dart';\n\nfinal getIt = GetIt.instance;\n\n@InjectableInit(\n  initializerName: 'init',\n  preferRelativeImports: true,\n  asExtension: true,\n)\nFuture<void> configureDependencies() async => getIt.init();",
    "network_module.dart": "@module\nabstract class NetworkModule {\n  @lazySingleton\n  Dio get dio => DioClient.createDio();\n\n  @lazySingleton\n  ApiClient get apiClient => ApiClient(getIt<Dio>());\n}",
    "storage_module.dart": "@module\nabstract class StorageModule {\n  @preResolve\n  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();\n\n  @lazySingleton\n  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();\n\n  @preResolve\n  Future<Box<dynamic>> get settingsBox => Hive.openBox('settings');\n}",
    "firebase_module.dart": "@module\nabstract class FirebaseModule {\n  @lazySingleton\n  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;\n\n  @lazySingleton\n  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;\n\n  @lazySingleton\n  FirebaseAnalytics get firebaseAnalytics => FirebaseAnalytics.instance;\n\n  @lazySingleton\n  FirebaseCrashlytics get firebaseCrashlytics => FirebaseCrashlytics.instance;\n}"
  },
  "routerSetup": {
    "app_router.dart": "final GoRouter appRouter = GoRouter(\n  initialLocation: RoutePaths.splash,\n  debugLogDiagnostics: kDebugMode,\n  navigatorKey: rootNavigatorKey,\n  redirect: (context, state) => _handleRedirect(context, state),\n  routes: [\n    GoRoute(\n      path: RoutePaths.splash,\n      name: RouteNames.splash,\n      builder: (context, state) => const SplashView(),\n    ),\n    ...authRoutes,\n    ...onboardingRoutes,\n    ShellRoute(\n      navigatorKey: memberShellNavigatorKey,\n      builder: (context, state, child) => MemberShell(child: child),\n      routes: memberRoutes,\n    ),\n    ShellRoute(\n      navigatorKey: partnerShellNavigatorKey,\n      builder: (context, state, child) => PartnerShell(child: child),\n      routes: partnerRoutes,\n    ),\n    ShellRoute(\n      navigatorKey: adminShellNavigatorKey,\n      builder: (context, state, child) => AdminShell(child: child),\n      routes: adminRoutes,\n    ),\n  ],\n);",
    "auth_guard.dart": "String? authGuard(BuildContext context, GoRouterState state) {\n  final authState = context.read<AuthBloc>().state;\n  final isAuthenticated = authState is AuthAuthenticated;\n  final isAuthRoute = state.matchedLocation.startsWith('/auth');\n  final isSplash = state.matchedLocation == RoutePaths.splash;\n  \n  if (!isAuthenticated && !isAuthRoute && !isSplash) {\n    return RoutePaths.login;\n  }\n  if (isAuthenticated && isAuthRoute) {\n    return RoutePaths.memberHome;\n  }\n  return null;\n}",
    "role_guard.dart": "String? roleGuard(BuildContext context, GoRouterState state, List<UserRole> allowedRoles) {\n  final authState = context.read<AuthBloc>().state;\n  if (authState is AuthAuthenticated) {\n    final userRole = authState.user.role;\n    if (!allowedRoles.contains(userRole)) {\n      switch (userRole) {\n        case UserRole.member:\n          return RoutePaths.memberHome;\n        case UserRole.partner:\n          return RoutePaths.partnerDashboard;\n        case UserRole.admin:\n          return RoutePaths.adminDashboard;\n        default:\n          return RoutePaths.login;\n      }\n    }\n  }\n  return null;\n}"
  },
  "features": [
    {
      "name": "auth",
      "presentation": ["SplashView", "LoginView", "OTPVerificationView", "AuthBloc", "AuthEvent", "AuthState"],
      "domain": ["User", "AuthToken", "AuthRepository", "LoginWithGoogle", "LoginWithApple", "LoginWithOTP", "VerifyOTP", "ContinueAsGuest", "Logout", "GetCurrentUser"],
      "data": ["UserModel", "AuthResponseModel", "TokenModel", "AuthRepositoryImpl", "AuthRemoteDataSource", "AuthLocalDataSource"]
    },
    {
      "name": "onboarding",
      "presentation": ["OnboardingView", "CitySelectionView", "InterestsSelectionView", "OnboardingCubit", "OnboardingState"],
      "domain": ["OnboardingSlide", "UserPreferences", "OnboardingRepository", "GetOnboardingSlides", "CompleteOnboarding", "SaveCitySelection", "SaveInterests"],
      "data": ["OnboardingSlideModel", "UserPreferencesModel", "OnboardingRepositoryImpl", "OnboardingLocalDataSource"]
    },
    {
      "name": "gyms",
      "presentation": ["GymsMapView", "GymsListView", "GymDetailView", "GymFilterView", "GymsBloc", "GymsEvent", "GymsState", "GymDetailCubit", "GymDetailState"],
      "domain": ["Gym", "GymFilter", "Facility", "WorkingHours", "GymsRepository", "GetGyms", "GetGymDetails", "FilterGyms", "GetNearbyGyms", "SearchGyms"],
      "data": ["GymModel", "GymFilterModel", "FacilityModel", "WorkingHoursModel", "GymsRepositoryImpl", "GymsRemoteDataSource", "GymsLocalDataSource"]
    },
    {
      "name": "subscriptions",
      "presentation": ["BundlesView", "CheckoutView", "PaymentWebView", "InvoicesView", "SubscriptionsBloc", "SubscriptionsEvent", "SubscriptionsState"],
      "domain": ["Subscription", "Bundle", "Invoice", "Payment", "SubscriptionsRepository", "GetBundles", "GetUserSubscription", "PurchaseSubscription", "CancelSubscription", "ToggleAutoRenew", "GetInvoices"],
      "data": ["SubscriptionModel", "BundleModel", "InvoiceModel", "PaymentModel", "SubscriptionsRepositoryImpl", "SubscriptionsRemoteDataSource", "SubscriptionsLocalDataSource"]
    },
    {
      "name": "qr_checkin",
      "presentation": ["QRDisplayView", "QRScannerView", "QRGeneratorCubit", "QRGeneratorState", "QRScannerBloc", "QRScannerEvent", "QRScannerState"],
      "domain": ["QRToken", "CheckinResult", "QRRepository", "GenerateQRToken", "ValidateQRToken", "ProcessCheckin"],
      "data": ["QRTokenModel", "CheckinResultModel", "QRRepositoryImpl", "QRRemoteDataSource", "QRLocalDataSource"]
    },
    {
      "name": "classes",
      "presentation": ["ClassesCalendarView", "ClassDetailView", "MyBookingsView", "ClassesBloc", "ClassesEvent", "ClassesState"],
      "domain": ["FitnessClass", "ClassBooking", "ClassesRepository", "GetClasses", "GetClassSchedule", "BookClass", "CancelBooking"],
      "data": ["FitnessClassModel", "ClassBookingModel", "ClassesRepositoryImpl", "ClassesRemoteDataSource"]
    },
    {
      "name": "rewards",
      "presentation": ["RewardsView", "ReferralsView", "PointsHistoryView", "RewardsCubit", "RewardsState"],
      "domain": ["Reward", "Referral", "PointsTransaction", "RewardsRepository", "GetRewards", "RedeemReward", "GetReferralCode", "ApplyReferralCode", "GetPointsHistory"],
      "data": ["RewardModel", "ReferralModel", "PointsTransactionModel", "RewardsRepositoryImpl", "RewardsRemoteDataSource"]
    },
    {
      "name": "history",
      "presentation": ["VisitsHistoryView", "HistoryCubit", "HistoryState"],
      "domain": ["Visit", "HistoryRepository", "GetVisits", "GetVisitStats"],
      "data": ["VisitModel", "HistoryRepositoryImpl", "HistoryRemoteDataSource"]
    },
    {
      "name": "profile",
      "presentation": ["ProfileView", "EditProfileView", "ProfileCubit", "ProfileState"],
      "domain": ["Profile", "ProfileRepository", "GetProfile", "UpdateProfile", "UpdateAvatar"],
      "data": ["ProfileModel", "ProfileRepositoryImpl", "ProfileRemoteDataSource"]
    },
    {
      "name": "settings",
      "presentation": ["SettingsView", "LanguageSelectionView", "NotificationSettingsView", "SettingsCubit", "SettingsState"],
      "domain": ["AppSettings", "SettingsRepository", "GetSettings", "UpdateLanguage", "UpdateNotifications", "ClearCache"],
      "data": ["AppSettingsModel", "SettingsRepositoryImpl", "SettingsLocalDataSource"]
    },
    {
      "name": "partner",
      "presentation": ["PartnerDashboardView", "PartnerScannerView", "PartnerReportsView", "PartnerSettingsView", "PartnerBloc", "PartnerEvent", "PartnerState"],
      "domain": ["PartnerGym", "VisitReport", "Revenue", "PartnerRepository", "GetPartnerGym", "GetVisitReports", "GetRevenueStats", "UpdateWorkingHours", "UpdateVisitLimits", "BlockUser"],
      "data": ["PartnerGymModel", "VisitReportModel", "RevenueModel", "PartnerRepositoryImpl", "PartnerRemoteDataSource"]
    },
    {
      "name": "admin",
      "presentation": ["AdminDashboardView", "GymsTableView", "AddGymView", "EditGymView", "AdminBloc", "AdminEvent", "AdminState"],
      "domain": ["AdminGym", "AdminStats", "AdminRepository", "GetAllGyms", "AddGym", "UpdateGym", "DeleteGym", "ChangeGymStatus", "GetDashboardStats"],
      "data": ["AdminGymModel", "AdminStatsModel", "GymFormModel", "AdminRepositoryImpl", "AdminRemoteDataSource"]
    }
  ],
  "architectureReport": "See docs/architectureReport.md for detailed architecture documentation including: layer descriptions, folder structure, feature modules, routing architecture, DI setup, QR security design, web layout architecture, state management patterns, API client design, data flow examples, environment configuration, code generation commands, and testing structure.",
  "progressReport": "See docs/progressReport.md for detailed progress tracking including: feature/module status table, dependencies status, architecture milestones, technical debt tracking, risk assessment, and sprint tasks."
}
```

---

## Key Code Templates

### 1. Base Use Case

```dart
// lib/src/core/usecases/usecase.dart
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {
  const NoParams();
}
```

### 2. Base Entity with Freezed

```dart
// lib/src/features/auth/domain/entities/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    required UserRole role,
    required DateTime createdAt,
  }) = _User;
}

enum UserRole { member, guest, partner, admin }
```

### 3. Model with JSON Serialization

```dart
// lib/src/features/auth/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'photo_url') String? photoUrl,
    required String role,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  User toEntity() => User(
        id: id,
        email: email,
        displayName: displayName,
        photoUrl: photoUrl,
        role: UserRole.values.byName(role),
        createdAt: createdAt,
      );
}
```

### 4. Bloc Pattern

```dart
// lib/src/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/logout.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithGoogle _loginWithGoogle;
  final Logout _logout;

  AuthBloc(this._loginWithGoogle, this._logout) : super(AuthInitial()) {
    on<LoginWithGoogleEvent>(_onLoginWithGoogle);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLoginWithGoogle(
    LoginWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _loginWithGoogle(const NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _logout(const NoParams());
    emit(AuthUnauthenticated());
  }
}
```

### 5. Repository Interface

```dart
// lib/src/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> loginWithGoogle();
  Future<Either<Failure, User>> loginWithApple();
  Future<Either<Failure, void>> loginWithOTP(String phoneNumber);
  Future<Either<Failure, User>> verifyOTP(String otp);
  Future<Either<Failure, User>> continueAsGuest();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
  Stream<User?> get authStateChanges;
}
```

### 6. Repository Implementation

```dart
// lib/src/features/auth/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    if (await _networkInfo.isConnected) {
      try {
        final userModel = await _remoteDataSource.loginWithGoogle();
        await _localDataSource.cacheUser(userModel);
        return Right(userModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  // ... other implementations
}
```

### 7. Retrofit API Client

```dart
// lib/src/core/network/api_client.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../constants/api_endpoints.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/data/models/auth_response_model.dart';
import '../../features/gyms/data/models/gym_model.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // Auth
  @POST(ApiEndpoints.loginGoogle)
  Future<AuthResponseModel> loginWithGoogle(
    @Body() Map<String, dynamic> request,
  );

  @POST(ApiEndpoints.loginApple)
  Future<AuthResponseModel> loginWithApple(
    @Body() Map<String, dynamic> request,
  );

  @POST(ApiEndpoints.sendOTP)
  Future<void> sendOTP(@Body() Map<String, dynamic> request);

  @POST(ApiEndpoints.verifyOTP)
  Future<AuthResponseModel> verifyOTP(@Body() Map<String, dynamic> request);

  // Gyms
  @GET(ApiEndpoints.gyms)
  Future<PaginatedResponse<GymModel>> getGyms(
    @Queries() Map<String, dynamic> filters,
  );

  @GET('${ApiEndpoints.gyms}/{id}')
  Future<GymModel> getGymById(@Path('id') String id);

  // Subscriptions
  @GET(ApiEndpoints.bundles)
  Future<List<BundleModel>> getBundles();

  @POST(ApiEndpoints.subscriptions)
  Future<SubscriptionModel> createSubscription(
    @Body() Map<String, dynamic> request,
  );

  // QR
  @POST(ApiEndpoints.generateQR)
  Future<QRTokenModel> generateQRToken(@Body() Map<String, dynamic> request);

  @POST(ApiEndpoints.validateQR)
  Future<CheckinResultModel> validateQRToken(
    @Body() Map<String, dynamic> request,
  );
}
```

### 8. GoRouter Configuration

```dart
// lib/src/core/router/app_router.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import 'route_names.dart';
import 'route_paths.dart';
import 'routes/auth_routes.dart';
import 'routes/member_routes.dart';
import 'routes/partner_routes.dart';
import 'routes/admin_routes.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> memberShellNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> partnerShellNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> adminShellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: kDebugMode,
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) => _handleRedirect(context, state, authBloc),
    routes: [
      // Splash
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => const SplashView(),
      ),
      
      // Auth routes
      ...authRoutes,
      
      // Onboarding routes
      ...onboardingRoutes,
      
      // Member shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MemberShell(navigationShell: navigationShell);
        },
        branches: memberBranches,
      ),
      
      // Partner shell with navigation rail
      ShellRoute(
        navigatorKey: partnerShellNavigatorKey,
        builder: (context, state, child) => PartnerShell(child: child),
        routes: partnerRoutes,
      ),
      
      // Admin shell with navigation rail
      ShellRoute(
        navigatorKey: adminShellNavigatorKey,
        builder: (context, state, child) => AdminShell(child: child),
        routes: adminRoutes,
      ),
    ],
  );
}

String? _handleRedirect(
  BuildContext context,
  GoRouterState state,
  AuthBloc authBloc,
) {
  final authState = authBloc.state;
  final isAuthenticated = authState is AuthAuthenticated;
  final isAuthRoute = state.matchedLocation.startsWith('/auth');
  final isOnboarding = state.matchedLocation.startsWith('/onboarding');
  final isSplash = state.matchedLocation == RoutePaths.splash;

  // Allow splash to handle initial routing
  if (isSplash) return null;

  // Redirect to login if not authenticated
  if (!isAuthenticated && !isAuthRoute && !isOnboarding) {
    return RoutePaths.login;
  }

  // Redirect from auth routes if already authenticated
  if (isAuthenticated && isAuthRoute) {
    final user = (authState as AuthAuthenticated).user;
    switch (user.role) {
      case UserRole.admin:
        return RoutePaths.adminDashboard;
      case UserRole.partner:
        return RoutePaths.partnerDashboard;
      default:
        return RoutePaths.memberHome;
    }
  }

  return null;
}
```

---

## Setup Instructions

### 1. Initialize Project

```bash
# Clone/create project
flutter create mygym --org com.mygym --platforms ios,android,web

# Navigate to project
cd mygym
```

### 2. Add Dependencies

Replace `pubspec.yaml` with the dependencies from the JSON above.

```bash
# Get dependencies
flutter pub get
```

### 3. Configure Firebase

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

### 4. Setup Code Generation

```bash
# Run build_runner
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch mode for development
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 5. Configure Localization

Add to `pubspec.yaml`:
```yaml
flutter:
  generate: true
```

Create `l10n.yaml`:
```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### 6. Run the App

```bash
# Development
flutter run --flavor development -t lib/main_development.dart

# Production
flutter run --flavor production -t lib/main_production.dart

# Web
flutter run -d chrome
```

---

## Next Steps

1. **Switch to Code mode** to generate the actual implementation files
2. **Setup Firebase project** and configure authentication
3. **Create backend API** following the endpoint structure
4. **Implement features** following the architecture patterns above
// lib/src/features/partner/presentation/cubit/blocked_users_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/partner_entities.dart';

part 'blocked_users_state.freezed.dart';

@freezed
class BlockedUsersState with _$BlockedUsersState {
  const factory BlockedUsersState({
    // Data
    @Default([]) List<BlockedUser> blockedUsers,
    @Default([]) List<BlockedUser> filteredUsers,
    @Default('') String searchQuery,
    
    // Status
    @Default(BlockedUsersStatus.initial) BlockedUsersStatus loadStatus,
    @Default(BlockedUsersStatus.initial) BlockedUsersStatus actionStatus,
    
    // Messages
    String? errorMessage,
    String? successMessage,
    
    // Selected user for unblock confirmation
    BlockedUser? selectedUser,
  }) = _BlockedUsersState;

  const BlockedUsersState._();

  /// Check if currently loading
  bool get isLoading => loadStatus == BlockedUsersStatus.loading;
  
  /// Check if an action (block/unblock) is in progress
  bool get isActionInProgress => actionStatus == BlockedUsersStatus.loading;
  
  /// Check if there are any blocked users
  bool get hasBlockedUsers => blockedUsers.isNotEmpty;
  
  /// Get count of blocked users
  int get blockedCount => blockedUsers.length;
  
  /// Get count of filtered users
  int get filteredCount => filteredUsers.length;
  
  /// Check if search is active
  bool get isSearching => searchQuery.isNotEmpty;
}

enum BlockedUsersStatus {
  initial,
  loading,
  success,
  failure,
}
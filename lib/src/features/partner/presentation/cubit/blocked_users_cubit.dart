// lib/src/features/partner/presentation/cubit/blocked_users_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/partner_entities.dart';
import '../../domain/repositories/partner_repository.dart';
import 'blocked_users_state.dart';

@injectable
class BlockedUsersCubit extends Cubit<BlockedUsersState> {
  final PartnerRepository _repository;

  BlockedUsersCubit(this._repository) : super(const BlockedUsersState());

  // ═══════════════════════════════════════════════════════════════════════════
  // Load Blocked Users
  // ═══════════════════════════════════════════════════════════════════════════

  /// Load all blocked users for the gym
  Future<void> loadBlockedUsers() async {
    emit(state.copyWith(loadStatus: BlockedUsersStatus.loading));

    try {
      final blockedUsers = await _repository.getMyGymBlockedUsers();
      
      emit(state.copyWith(
        loadStatus: BlockedUsersStatus.success,
        blockedUsers: blockedUsers,
        filteredUsers: blockedUsers,
        searchQuery: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        loadStatus: BlockedUsersStatus.failure,
        errorMessage: 'Failed to load blocked users: ${e.toString()}',
      ));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Search & Filter
  // ═══════════════════════════════════════════════════════════════════════════

  /// Search blocked users by name
  void searchUsers(String query) {
    final searchQuery = query.toLowerCase().trim();
    
    if (searchQuery.isEmpty) {
      emit(state.copyWith(
        filteredUsers: state.blockedUsers,
        searchQuery: '',
      ));
      return;
    }

    final filtered = state.blockedUsers.where((user) {
      return user.visitorName.toLowerCase().contains(searchQuery) ||
          (user.reason?.toLowerCase().contains(searchQuery) ?? false);
    }).toList();

    emit(state.copyWith(
      filteredUsers: filtered,
      searchQuery: query,
    ));
  }

  /// Clear search
  void clearSearch() {
    emit(state.copyWith(
      filteredUsers: state.blockedUsers,
      searchQuery: '',
    ));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Block/Unblock Actions
  // ═══════════════════════════════════════════════════════════════════════════

  /// Block a new user
  Future<void> blockUser({
    required String visitorId,
    required String visitorName,
    String? reason,
  }) async {
    emit(state.copyWith(
      actionStatus: BlockedUsersStatus.loading,
      errorMessage: null,
      successMessage: null,
    ));

    try {
      await _repository.blockUserFromMyGym(
        visitorId: visitorId,
        visitorName: visitorName,
        reason: reason,
      );

      // Reload the list
      final blockedUsers = await _repository.getMyGymBlockedUsers();
      
      emit(state.copyWith(
        actionStatus: BlockedUsersStatus.success,
        blockedUsers: blockedUsers,
        filteredUsers: _applySearchFilter(blockedUsers, state.searchQuery),
        successMessage: '$visitorName has been blocked',
      ));
    } catch (e) {
      emit(state.copyWith(
        actionStatus: BlockedUsersStatus.failure,
        errorMessage: 'Failed to block user: ${e.toString()}',
      ));
    }
  }

  /// Unblock a user
  Future<void> unblockUser(BlockedUser user) async {
    emit(state.copyWith(
      actionStatus: BlockedUsersStatus.loading,
      errorMessage: null,
      successMessage: null,
      selectedUser: user,
    ));

    try {
      await _repository.unblockUserFromMyGym(visitorId: user.visitorId);

      // Reload the list
      final blockedUsers = await _repository.getMyGymBlockedUsers();
      
      emit(state.copyWith(
        actionStatus: BlockedUsersStatus.success,
        blockedUsers: blockedUsers,
        filteredUsers: _applySearchFilter(blockedUsers, state.searchQuery),
        selectedUser: null,
        successMessage: '${user.visitorName} has been unblocked',
      ));
    } catch (e) {
      emit(state.copyWith(
        actionStatus: BlockedUsersStatus.failure,
        selectedUser: null,
        errorMessage: 'Failed to unblock user: ${e.toString()}',
      ));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Selection
  // ═══════════════════════════════════════════════════════════════════════════

  /// Select a user (for confirmation dialog)
  void selectUser(BlockedUser user) {
    emit(state.copyWith(selectedUser: user));
  }

  /// Clear selected user
  void clearSelectedUser() {
    emit(state.copyWith(selectedUser: null));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Utility Methods
  // ═══════════════════════════════════════════════════════════════════════════

  /// Clear messages
  void clearMessages() {
    emit(state.copyWith(
      successMessage: null,
      errorMessage: null,
    ));
  }

  /// Reset action status
  void resetActionStatus() {
    emit(state.copyWith(actionStatus: BlockedUsersStatus.initial));
  }

  /// Apply search filter to a list
  List<BlockedUser> _applySearchFilter(List<BlockedUser> users, String query) {
    if (query.isEmpty) return users;
    
    final searchQuery = query.toLowerCase().trim();
    return users.where((user) {
      return user.visitorName.toLowerCase().contains(searchQuery) ||
          (user.reason?.toLowerCase().contains(searchQuery) ?? false);
    }).toList();
  }
}
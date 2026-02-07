import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/admin_users_repository.dart';

part 'admin_users_cubit.freezed.dart';

@injectable
class AdminUsersCubit extends Cubit<AdminUsersState> {
  final AdminUsersRepository _repository;

  AdminUsersCubit(this._repository) : super(const AdminUsersState.initial());

  AdminUserFilter _currentFilter = const AdminUserFilter();
  AdminUserFilter get currentFilter => _currentFilter;

  /// Load initial data (stats + users)
  Future<void> loadInitial() async {
    emit(const AdminUsersState.loading());

    final statsResult = await _repository.getUsersStats();
    final usersResult = await _repository.getUsers(_currentFilter);

    statsResult.fold(
      (failure) => emit(AdminUsersState.error(failure.message)),
      (stats) {
        usersResult.fold(
          (failure) => emit(AdminUsersState.error(failure.message)),
          (paginatedUsers) => emit(AdminUsersState.loaded(
            stats: stats,
            users: paginatedUsers.users,
            totalUsers: paginatedUsers.totalCount,
            currentPage: paginatedUsers.currentPage,
            totalPages: paginatedUsers.totalPages,
            hasMore: paginatedUsers.hasMore,
            filter: _currentFilter,
          )),
        );
      },
    );
  }

  /// Load users with filter
  Future<void> loadUsers({AdminUserFilter? filter}) async {
    if (filter != null) _currentFilter = filter;

    final currentState = state;
    if (currentState is AdminUsersLoaded) {
      emit(currentState.copyWith(isLoadingMore: true));
    }

    final result = await _repository.getUsers(_currentFilter);

    result.fold(
      (failure) {
        if (currentState is AdminUsersLoaded) {
          emit(currentState.copyWith(isLoadingMore: false));
        } else {
          emit(AdminUsersState.error(failure.message));
        }
      },
      (paginatedUsers) {
        if (currentState is AdminUsersLoaded) {
          emit(currentState.copyWith(
            users: paginatedUsers.users,
            totalUsers: paginatedUsers.totalCount,
            currentPage: paginatedUsers.currentPage,
            totalPages: paginatedUsers.totalPages,
            hasMore: paginatedUsers.hasMore,
            filter: _currentFilter,
            isLoadingMore: false,
          ));
        } else {
          loadInitial();
        }
      },
    );
  }

  /// Load next page
  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! AdminUsersLoaded || 
        !currentState.hasMore || 
        currentState.isLoadingMore) {
      return;
    }

    _currentFilter = _currentFilter.copyWith(page: _currentFilter.page + 1);
    emit(currentState.copyWith(isLoadingMore: true));

    final result = await _repository.getUsers(_currentFilter);

    result.fold(
      (failure) => emit(currentState.copyWith(isLoadingMore: false)),
      (paginatedUsers) => emit(currentState.copyWith(
        users: [...currentState.users, ...paginatedUsers.users],
        currentPage: paginatedUsers.currentPage,
        hasMore: paginatedUsers.hasMore,
        isLoadingMore: false,
      )),
    );
  }

  /// Search users
  Future<void> searchUsers(String query) async {
    _currentFilter = _currentFilter.copyWith(
      searchQuery: query.isEmpty ? null : query,
      page: 1,
    );
    await loadUsers();
  }

  /// Filter by role
  Future<void> filterByRole(UserRole? role) async {
    _currentFilter = _currentFilter.copyWith(role: role, page: 1);
    await loadUsers();
  }

  /// Filter by status
  Future<void> filterByStatus(UserStatus? status) async {
    _currentFilter = _currentFilter.copyWith(status: status, page: 1);
    await loadUsers();
  }

  /// Filter by subscription status
  Future<void> filterBySubscription(UserSubscriptionStatus? status) async {
    _currentFilter = _currentFilter.copyWith(subscriptionStatus: status, page: 1);
    await loadUsers();
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    _currentFilter = const AdminUserFilter();
    await loadUsers();
  }

  /// Update user status
  Future<bool> updateUserStatus(String userId, UserStatus status) async {
    final result = await _repository.updateUserStatus(userId, status);
    return result.fold(
      (failure) => false,
      (updatedUser) {
        final currentState = state;
        if (currentState is AdminUsersLoaded) {
          final updatedUsers = currentState.users.map((u) {
            return u.id == userId ? updatedUser : u;
          }).toList();
          emit(currentState.copyWith(users: updatedUsers));
          _refreshStats();
        }
        return true;
      },
    );
  }

  /// Update user role
  Future<bool> updateUserRole(String userId, UserRole role) async {
    final result = await _repository.updateUserRole(userId, role);
    return result.fold(
      (failure) => false,
      (updatedUser) {
        final currentState = state;
        if (currentState is AdminUsersLoaded) {
          final updatedUsers = currentState.users.map((u) {
            return u.id == userId ? updatedUser : u;
          }).toList();
          emit(currentState.copyWith(users: updatedUsers));
          _refreshStats();
        }
        return true;
      },
    );
  }

  /// Delete user
  Future<bool> deleteUser(String userId) async {
    final result = await _repository.deleteUser(userId);
    return result.fold(
      (failure) => false,
      (_) {
        final currentState = state;
        if (currentState is AdminUsersLoaded) {
          final updatedUsers = currentState.users
              .where((u) => u.id != userId)
              .toList();
          emit(currentState.copyWith(
            users: updatedUsers,
            totalUsers: currentState.totalUsers - 1,
          ));
          _refreshStats();
        }
        return true;
      },
    );
  }

  /// Bulk update status
  Future<int> bulkUpdateStatus(List<String> userIds, UserStatus status) async {
    final result = await _repository.bulkUpdateStatus(userIds, status);
    return result.fold(
      (failure) => 0,
      (count) {
        loadInitial();
        return count;
      },
    );
  }

  /// Export users
  Future<String?> exportUsers() async {
    final result = await _repository.exportUsersToCSV(_currentFilter);
    return result.fold(
      (failure) => null,
      (url) => url,
    );
  }

  /// Get user details
  Future<AdminUser?> getUserDetails(String userId) async {
    final result = await _repository.getUserById(userId);
    return result.fold(
      (failure) => null,
      (user) => user,
    );
  }

  /// Refresh stats
  Future<void> _refreshStats() async {
    final result = await _repository.getUsersStats();
    result.fold(
      (_) => null,
      (stats) {
        final currentState = state;
        if (currentState is AdminUsersLoaded) {
          emit(currentState.copyWith(stats: stats));
        }
      },
    );
  }
}

@freezed
class AdminUsersState with _$AdminUsersState {
  const factory AdminUsersState.initial() = AdminUsersInitial;
  
  const factory AdminUsersState.loading() = AdminUsersLoading;
  
  const factory AdminUsersState.loaded({
    required UsersStats stats,
    required List<AdminUser> users,
    required int totalUsers,
    required int currentPage,
    required int totalPages,
    required bool hasMore,
    required AdminUserFilter filter,
    @Default(false) bool isLoadingMore,
    @Default(<String>{}) Set<String> selectedUserIds,
  }) = AdminUsersLoaded;
  
  const factory AdminUsersState.error(String message) = AdminUsersError;
}
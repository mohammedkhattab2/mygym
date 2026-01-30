import 'package:injectable/injectable.dart';
import 'package:mygym/src/features/classes/domain/entities/fitness_class.dart';
import '../../domain/repositories/classes_repository.dart';
import '../datasources/classes_local_data_source.dart';

@LazySingleton(as: ClassesRepository)
class ClassesRepositoryImpl implements ClassesRepository {
  final ClassesLocalDataSource _local;

  // مؤقتًا بنستخدم userId ثابت لحد ما نربطه بالـ Auth
  static const _dummyUserId = 'user_1';

  ClassesRepositoryImpl(this._local);

  @override
  Future<List<ClassBooking>> getMyBookings() {
    return _local.getMyBookings(_dummyUserId);
  }

  @override
  Future<ClassBooking> bookClass({required String scheduleId}) {
    return _local.bookClass(
      userId: _dummyUserId,
      scheduleId: scheduleId,
    );
  }

  @override
  Future<ClassBooking> cancelBooking({
    required String bookingId,
    String? reason,
  }) {
    return _local.cancelBooking(
      bookingId: bookingId,
      reason: reason,
    );
  }
  
  @override
  Future<List<ClassSchedule>> getScedule({required DateTime startDate, required DateTime endDate, ClassFilter? filter}) {
    return _local.getSchedule(
      startDate: startDate,
      endDate: endDate,
      filter: filter,
    );
  }

  @override
  Future<ClassSchedule?> getScheduleById(String scheduleId) {
    return _local.getScheduleById(scheduleId);
  }
}
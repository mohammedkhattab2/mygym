import 'package:mygym/src/features/classes/domain/entities/fitness_class.dart';

abstract class ClassesRepository {
  Future<List<ClassSchedule>> getScedule({
    required DateTime startDate,
    required DateTime endDate,
    ClassFilter? filter,
  });

  Future<List<ClassBooking>> getMyBookings();

  Future<ClassBooking> bookClass({required String scheduleId});

  Future<ClassBooking> cancelBooking({
    required String bookingId,
    String? reason,
  });
}

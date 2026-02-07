import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/habit.dart';
import '../entities/reminder.dart';

abstract class HabitRepository {
  // Hábitos
  Future<Either<Failure, List<Habit>>> getHabits(String userId);
  Future<Either<Failure, Habit>> createHabit(Habit habit);
  Future<Either<Failure, Habit>> updateHabit(Habit habit);
  Future<Either<Failure, void>> deleteHabit(String habitId);
  Future<Either<Failure, Habit>> completeHabit(String habitId, DateTime date);

  // Recordatorios
  Future<Either<Failure, List<Reminder>>> getReminders(String userId);
  Future<Either<Failure, Reminder>> createReminder(Reminder reminder);
  Future<Either<Failure, Reminder>> updateReminder(Reminder reminder);
  Future<Either<Failure, void>> deleteReminder(String reminderId);
  Future<Either<Failure, Reminder>> toggleReminder(String reminderId);
}

import '../../domain/entities/gym_entity.dart';
import '../../domain/entities/fitness_class_entity.dart';

class HomeDummyDataSource {
  static const List<GymEntity> gyms = [
    GymEntity(
      id: '1',
      name: 'Gold\'s Gym',
      emoji: '🏋️',
      location: 'Maadi, Cairo',
      rating: 4.8,
      distance: '1.2 km',
    ),
    GymEntity(
      id: '2',
      name: 'Fitness First',
      emoji: '💪',
      location: 'Zamalek, Cairo',
      rating: 4.6,
      distance: '2.5 km',
    ),
    GymEntity(
      id: '3',
      name: 'Smart Gym',
      emoji: '🏃',
      location: 'Nasr City, Cairo',
      rating: 4.5,
      distance: '3.0 km',
    ),
    GymEntity(
      id: '4',
      name: 'Power House',
      emoji: '⚡',
      location: 'Heliopolis, Cairo',
      rating: 4.7,
      distance: '4.2 km',
    ),
  ];

  static const List<FitnessClassEntity> classes = [
    FitnessClassEntity(
      id: '1',
      name: 'Yoga Flow',
      emoji: '🧘',
      instructor: 'Sarah Ahmed',
      time: '09:00 AM',
      duration: '60 min',
    ),
    FitnessClassEntity(
      id: '2',
      name: 'HIIT Training',
      emoji: '🔥',
      instructor: 'Mohamed Ali',
      time: '11:00 AM',
      duration: '45 min',
    ),
    FitnessClassEntity(
      id: '3',
      name: 'Spinning',
      emoji: '🚴',
      instructor: 'Nour Hassan',
      time: '05:00 PM',
      duration: '50 min',
    ),
  ];
}
import 'package:flutter_test/flutter_test.dart';
import 'package:equipro/src/models/horse.dart';
import 'package:equipro/src/models/user.dart';
import 'package:equipro/src/models/horseBreed.dart';
import 'package:equipro/src/models/horseColor.dart';
import 'package:equipro/src/models/horseFeedType.dart';
import 'package:equipro/src/models/adresses.dart';
import 'package:equipro/src/models/horseActivityType.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Horse Model Tests', () {
    test('Horse constructor should create an instance', () {
      final horse = Horse(
        id: '1',
        name: 'Lightning',
        age: 5,
        stableId: 'stable123',
        notes: 'Very fast',
        users: [Users(id: 'u1', firstName: 'John', lastName: 'Doe', email: 'email@test.com', professional: false)],
        breeds: [HorseBreed(id: 'b1', label: 'Arabian')],
        colors: [HorseColor(id: 'c1', label: 'Black')],
        feedTypes: [FeedType(id: 'f1', label: 'Hay')],
        activityTypes: [ActivityType(id: 'a1', label: 'Jumping')],
        address: [Address(idAddress: 'addr1', address: '123 Street', city: 'Paris', country: 'France', postalCode: '13110')],
      );

      expect(horse.id, '1');
      expect(horse.name, 'Lightning');
      expect(horse.age, 5);
      expect(horse.stableId, 'stable123');
      expect(horse.notes, 'Very fast');
      expect(horse.users!.first.firstName, 'John');
      expect(horse.breeds!.first.label, 'Arabian');
      expect(horse.colors!.first.label, 'Black');
      expect(horse.feedTypes!.first.label, 'Hay');
      expect(horse.activityTypes!.first.label, 'Jumping');
      expect(horse.address!.first.city, 'Paris');
    });

    test('Horse toJson and fromJson should work correctly', () {
      final horse = Horse(
        id: '1',
        name: 'Lightning',
      );

      final json = horse.toJson();
      expect(json['id'], '1');
      expect(json['name'], 'Lightning');
      expect(json['age'], null);

      final horseFromJson = Horse.fromJson({
        'id': '2',
        'name': 'Thunder',
        'age': 7,
      });
      expect(horseFromJson.id, '2');
      expect(horseFromJson.name, 'Thunder');
      expect(horseFromJson.age, 7);
    });

    test('Horse copyWith should copy and override properties', () {
      final horse = Horse(id: '1', name: 'Lightning', age: 5);
      final updatedHorse = horse.copyWith(name: 'Thunder', age: 6);

      expect(updatedHorse.id, '1'); // unchanged
      expect(updatedHorse.name, 'Thunder'); // updated
      expect(updatedHorse.age, 6); // updated
    });
  });
}

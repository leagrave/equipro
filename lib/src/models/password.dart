import 'dart:math';

String generateRandomPassword({int length = 12}) {
  const String chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#%&*!?';
  final Random rand = Random.secure();

  return List.generate(length, (index) => chars[rand.nextInt(chars.length)]).join();
}

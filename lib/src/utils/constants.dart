import 'dart:ui';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  // UPDATED COLOURS BASED ON NEW PALETTE
  // ---- PRIMARY PALETTE
  static const Color primaryDarkBlue = Color(0xFF002439); // Backgrounds, headers
  static const Color primaryBlueDeep = Color(0xFF002d41); // Buttons, active states
  static const Color primaryBluePetrol = Color(0xFF00293d); // Secondary elements
  static const Color primaryBlueMarine = Color(0xFF00253a); // Subtle accents
  static const Color white = Color(0xFFFFFFFF); // Text and contrast


  // ---- GREYS (UNTOUCHED)
  static const Color black = Color(0xFF000000);
  static const Color darkest = Color(0xFF373248);
  static const Color darker = Color(0xFF47516B);
  static const Color dark = Color(0xFF79819A);
  static const Color neutral = Color(0xFFAEB7D3);
  static const Color light = Color(0xFFD9DFE8);
  static const Color lighter = Color(0xFFE2E6EE);
  static const Color lightest = Color(0xFFF7F9FC);
  static const Color lightest2 = Color(0xFFF7F9FC);
  static const Color post = Color(0xFFDEE3D5);
  static const Color grey = Color.fromARGB(255, 158, 158, 158);

  // ---- ACCENT COLORS
  static const Color secondaryYellow = Color.fromARGB(255, 255, 230, 0);
  static const Color secondaryOrange = Color(0xFFFFB000);
  static const Color secondaryOrange2 = Color.fromARGB(255, 255, 136, 0);
  static const Color secondaryRed = Color.fromARGB(255, 234, 36, 36);
  static const Color secondaryGreen = Color(0xFF4CAF50);
  static const Color secondaryBleu = Color.fromARGB(255, 76, 103, 219);

  // ---- TURQUOISE/BLUE COLORS
  static const Color turquoiseLight = Color(0xFF00B8D9); // Main turquoise color
  static const Color turquoiseBright = Color(0xFF00C6CF); // Lighter and vibrant turquoise
  static const Color turquoiseDark = Color(0xFF0097A7); // Darker turquoise
  static const Color turquoise =   Color(0xFF1BD5DB); //turquoise

  static const Color appBarBackgroundColor = Color(0xFF29323F); // Bleu-gris foncé
  static const Color gradientStartColor = Color(0xFF28313E); // Bleu-gris profond
  static const Color gradientEndColor = Color(0xFF1BD5DB); // Bleu clair
  static const Color buttonTextColor = Color(0xFF28313E); // Bleu-gris profond

  static const List<Color> gradientLoginBackground = [
  turquoiseDark,
  appBarBackgroundColor, 
];

  static const List<Color> gradientBackground = [
  gradientStartColor, 
  gradientStartColor,
];


  // FONT FAMILIES
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'FontWeight';

  // MEASURES
  static const double paddingMedium = 30.0;

  // IMAGES
  static const String logo = "assets/images/image-logo.jpg";
  static const String avatar = "assets/images/default_avatar.jpg";
  static const String call = "assets/icones/call.svg";

  // EXAMPLE USAGE
  // Example 1: Button Style
  // Button color: primaryBlueDeep (#002d41)
  // Text color: white (#FFFFFF)

  // Example 2: Background and Header
  // Background: primaryDarkBlue (#002439)
  // Header text: white (#FFFFFF)

  // Example 3: Secondary Accent
  // Icon color: primaryBluePetrol (#00293d)
  // Hover effect: primaryBlueMarine (#00253a)

  // TEXT STRINGS
  static const String cancel = "Annuler";
  static const String publish = "Publier";


//static String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? "http://localhost:3000/api";
//static const String apiBaseUrl = "https://equipro-api.onrender.com/api";
 //String.fromEnvironment('API_BASE_URL');
static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api';
//"http://10.208.74.76:3000/api";


   // ASSET ICONS
  // static const String addIcon = "assets/icons/add.svg";
  // static const String cameraIcon = "assets/icons/camera.svg";
  // static const String closeIcon = "assets/icons/close.svg";
  // static const String exportIcon = "assets/icons/export.svg";
  // static const String gifIcon = "assets/icons/gif.svg";
  // static const String homeIcon = "assets/icons/home.svg";
  // static const String likeIcon = "assets/icons/like.svg";
  // static const String messageIcon = "assets/icons/message.svg";
  // static const String musicNoteIcon = "assets/icons/music-note.svg";
  // static const String nextIcon = "assets/icons/next.svg";
  // static const String parameterIcon = "assets/icons/parameter.svg";
  // static const String phoneIcon = "assets/icons/phone.svg";
  // static const String personIcon = "assets/icons/person.svg";
  // static const String pictureIcon = "assets/icons/picture.svg";
  // static const String playIcon = "assets/icons/play.svg";
  // static const String pointsIcon = "assets/icons/points.svg";
  // static const String previousIcon = "assets/icons/previous.svg";
  // static const String replayIcon = "assets/icons/replay.svg";
  // static const String searchIcon = "assets/icons/search.svg";
  // static const String soundIcon = "assets/icons/sound.svg";
  // static const String starIcon = "assets/icons/star.svg";
  // static const String validationIcon = "assets/icons/validation.svg";
  // static const String videoCameraIcon = "assets/icons/video-camera.svg";
  // static const String typoIcon = "assets/icons/typo.svg";


}


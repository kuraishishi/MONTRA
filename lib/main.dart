import 'package:flutter/material.dart';
import 'package:montra/widgets/transactions.dart'; // Importing the Transactions widget from another file

void main() {
  runApp(const MyApp());
}

// Define color schemes for light and dark themes
var kColorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(
    255, 144, 238, 144));

var kDarkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(
        255, 144, 238, 144));

// Define the main application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Define the dark theme settings
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: kDarkColorScheme, // Set the color scheme for dark theme
        cardTheme: const CardTheme().copyWith(
            color: kDarkColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        ), // Customize the card theme for dark mode
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer, // Set the button background color
            foregroundColor: kDarkColorScheme.onPrimaryContainer, // Set the button text color
          ),
        ), // Customize the elevated button theme for dark mode
      ),
      // Define the light theme settings
      theme: ThemeData(useMaterial3: true).copyWith(
        colorScheme: kColorScheme, // Set the color scheme for light theme
        appBarTheme: const AppBarTheme().copyWith(
            backgroundColor: kColorScheme.onPrimaryContainer,
            foregroundColor: kColorScheme.primaryContainer
        ), // Customize the app bar theme for light mode
        cardTheme: const CardTheme().copyWith(
            color: kColorScheme.secondaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        ), // Customize the card theme for light mode
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer
          ),
        ), // Customize the elevated button theme for light mode
      ),
      debugShowCheckedModeBanner: false, // Disable debug banner
      home: const Transactions(), // Set the home screen to the Transactions widget
    );
  }
}

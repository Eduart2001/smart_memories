import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme textTheme = TextTheme(
  displayLarge: const TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.bold,
  ),
  titleLarge: GoogleFonts.oswald(
    fontSize: 30,
    fontStyle: FontStyle.italic,
  ),
  bodyMedium: GoogleFonts.merriweather(),
  displaySmall: GoogleFonts.pacifico(),
);

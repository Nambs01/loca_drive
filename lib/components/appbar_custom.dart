import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar appBarCustom ({
  required BuildContext context,
}) {
  final colors = Theme.of(context).colorScheme;

  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    title: Text("LocaDrive",
        style: GoogleFonts.rancho(
        color: colors.primary,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
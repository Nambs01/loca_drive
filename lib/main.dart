import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loca_vam/pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'stores/location_store.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationStore()),
      ],
      child: MaterialApp(
        title: 'Location App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue.shade700,
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              secondary: Colors.grey.shade300,
              surface: Colors.white,
              error: Colors.red,
              onPrimary: Colors.white,
              onSecondary: Colors.grey.shade900,
              onSurface: Colors.black,
              onError: Colors.white,
              brightness: Brightness.light,
            ),
          textTheme: GoogleFonts.poppinsTextTheme()
        ),
        home: SplashPage(),
      ),
    );
  }
}
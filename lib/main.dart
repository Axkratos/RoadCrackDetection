// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'pages/main_page.dart';
// import 'pages/scan_page.dart';
// import 'pages/result_page.dart';

// void main() => runApp(const RoadScanApp());

// class RoadScanApp extends StatelessWidget {
//   const RoadScanApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'RoadScan',
//       theme: ThemeData(
//         primaryColor: const Color(0xFF1565C0),
//         appBarTheme: AppBarTheme(
//           backgroundColor: const Color(0xFF1565C0),
//           titleTextStyle: GoogleFonts.poppins(
//             fontSize: 22,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         textTheme: GoogleFonts.poppinsTextTheme(),
//       ),
//       routes: {
//         '/': (context) => const MainPage(),
//         '/scan': (context) => const ScanPage(),
//         '/result': (context) => ResultPage(
//               analysisData: ModalRoute.of(context)!.settings.arguments 
//                   as Map<String, dynamic>,
//             ),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/main_page.dart';
import 'pages/scan_page.dart';
import 'pages/result_page.dart';

void main() => runApp(const RoadScanApp());

class RoadScanApp extends StatelessWidget {
  const RoadScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RoadScan',
      theme: _buildAppTheme(),
      routes: _appRoutes(),
    );
  }

  ThemeData _buildAppTheme() {
    const Color primaryColor = Color(0xFF1565C0);
    const Color secondaryColor = Color(0xFF0D47A1);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: Colors.grey.shade800,
        displayColor: primaryColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _appRoutes() {
    return {
      '/': (context) => const MainPage(),
      '/scan': (context) => const ScanPage(),
      '/result': (context) => ResultPage(
            analysisData: ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>,
          ),
    };
  }
}


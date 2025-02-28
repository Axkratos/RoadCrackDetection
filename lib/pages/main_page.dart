import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isWakingServer = false;
  int _messageIndex = 0;
  late Timer _messageTimer;

  final List<String> _loadingMessages = [
    "Initializing road surface analysis...",
    "Calibrating detection algorithms...",
    "Loading repair recommendations...",
    "Preparing inspection interface..."
  ];

  Future<void> _wakeServer() async {
    setState(() {
      _isWakingServer = true;
      _messageIndex = 0;
    });

    _messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() => _messageIndex = (_messageIndex + 1) % _loadingMessages.length);
    });

    try {
      final response = await http.get(
        Uri.parse('https://axkratos-roadcrackdetection.hf.space'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        Navigator.pushNamed(context, '/scan');
      }
    } on TimeoutException {
      _showError('Connection timeout. Please try again');
    } catch (e) {
      _showError('Server error: ${e.toString()}');
    } finally {
      _messageTimer.cancel();
      setState(() => _isWakingServer = false);
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Connection Issue",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(message, style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: GoogleFonts.poppins()),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anugaman',
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        backgroundColor: const Color(0xFF1565C0),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSection(
                    title: "Road Surface Analysis",
                    description: "AI-powered detection of road cracks and surface defects"
                  ),
                  const SizedBox(height: 40),
                  _buildSection(
                    title: "Instant Diagnosis",
                    description: "Immediate crack type identification with repair solutions"
                  ),
                  const SizedBox(height: 40),
                  _buildStartButton(),
                ],
              ),
            ),
            if (_isWakingServer) _buildProcessingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String description}) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 10),
          Text(description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: _wakeServer,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        'Start Inspection',
        style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0D47A1)),
      ),
    );
  }

  Widget _buildProcessingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.85),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 20),
            Text(_loadingMessages[_messageIndex],
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

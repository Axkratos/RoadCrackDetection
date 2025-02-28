import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  File? _image;
  bool _isProcessing = false;

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() => _image = File(image.path));
    }
  }

Future<void> _analyzeImage() async {
  if (_image == null) return;

  setState(() => _isProcessing = true);

  try {
    print('⏳ Starting image analysis...');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://axkratos-roadcrackdetection.hf.space/predict'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path));
    print('📤 Uploading image: ${_image!.path}');

    final response = await request.send().timeout(const Duration(seconds: 60));
    final responseString = await response.stream.bytesToString();
    print('✅ Response received:');
    print(responseString); // Raw JSON response
    print('-------------------');

    final result = jsonDecode(responseString);
    print('🔍 Decoded result:');
    print('Crack Type: ${result['crack_type']}');
    print('Confidence: ${result['confidence']}');
    print('Remedy Length: ${result['remedy']?.length} characters');
    
    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/result', arguments: result);
    }
  } on TimeoutException {
    print('⏰ Analysis timed out after 60 seconds');
    Navigator.pushNamed(context, '/result', arguments: {
      'confidence': 0.0,
      'crack_type': 'Unknown',
      'remedy': 'Analysis timed out. Please try again.'
    });
  } catch (e) {
    print('❌ Error occurred: $e');
    Navigator.pushNamed(context, '/result', arguments: {
      'confidence': 0.0,
      'crack_type': 'Error',
      'remedy': 'Failed to analyze image: ${e.toString()}'
    });
  } finally {
    setState(() => _isProcessing = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anugaman',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageButton(Icons.camera_alt, 'Capture Road Surface', ImageSource.camera),
                const SizedBox(height: 20),
                _buildImageButton(Icons.photo_library, 'Upload Road Image', ImageSource.gallery),
              ],
            ),
          ),
          if (_image != null) _buildImagePreview(),
          if (_isProcessing) _buildProcessingOverlay(),
        ],
      ),
    );
  }

  Widget _buildImageButton(IconData icon, String label, ImageSource source) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28),
      label: Text(label, style: GoogleFonts.poppins(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        backgroundColor: const Color(0xFF1976D2),
      ),
      onPressed: () => _pickImage(source),
    );
  }

  Widget _buildImagePreview() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 300,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 12)],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Captured Image', style: GoogleFonts.poppins()),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _image = null),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: _analyzeImage,
                  child: Text('Analyze Road Surface',
                      style: GoogleFonts.poppins(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 20),
            Text('Analyzing road surface...',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

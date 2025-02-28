import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultPage extends StatelessWidget {
  final Map<String, dynamic> analysisData;

  const ResultPage({super.key, required this.analysisData});

  @override
  Widget build(BuildContext context) {
    final crackType = analysisData['crack_type'] ?? 'Unknown';
    final confidence = analysisData['confidence'] ?? 0.0;
    final remedy = analysisData['remedy'] ?? 'No analysis results available';

    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Report',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, fontSize: 20)),
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE3F2FD), Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCrackTypeHeader(crackType),
              const SizedBox(height: 25),
              _buildConfidenceMeter(confidence),
              const SizedBox(height: 30),
              _buildRemedySection(remedy),
              const SizedBox(height: 20),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrackTypeHeader(String crackType) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, 
              size: 40, color: Color(0xFF1565C0)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detected Crack Type',
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.grey.shade600)),
                Text(crackType,
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D47A1))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceMeter(double confidence) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Analysis Confidence',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700)),
          const SizedBox(height: 15),
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 800),
                widthFactor: confidence,
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  '${(confidence * 100).toStringAsFixed(1)}%',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemedySection(String remedy) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.handyman_rounded,
                  color: Color(0xFF0D47A1), size: 28),
              const SizedBox(width: 10),
              Text('Repair Solution',
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D47A1))),
            ],
          ),
          const SizedBox(height: 15),
          Text(remedy,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.grey.shade800)),
          const SizedBox(height: 20),
          _buildRemedySteps(),
        ],
      ),
    );
  }

  Widget _buildRemedySteps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Action Steps',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
        const SizedBox(height: 10),
        ...List.generate(5, (index) => _buildStepItem(index + 1)),
      ],
    );
  }

  Widget _buildStepItem(int stepNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Text('$stepNumber',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text('Detailed step description for repair process...',
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.grey.shade800)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.share_rounded),
            label: Text('Share Report',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text('New Scan',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Color(0xFF0D47A1)),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }
}

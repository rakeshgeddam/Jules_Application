import 'package:flutter/material.dart';

// Using the same color palette
const Color primaryColor = Color(0xFF135bec);
const Color darkBackgroundColor = Color(0xFF101622);
const Color lightBackgroundColor = Color(0xFFf6f6f8);
const Color darkCardColor = Color(0xFF1C2431);
const Color lightCardColor = Colors.white;

class IosFocusModeScreen extends StatelessWidget {
  const IosFocusModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? darkBackgroundColor : lightBackgroundColor;
    final cardColor = isDarkMode ? darkCardColor : lightCardColor;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final textVariantColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Focus Permissions', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusPanel(cardColor, textColor, textVariantColor),
                  const SizedBox(height: 32),
                  _buildHeader('Automate Your Focus', textColor),
                  const SizedBox(height: 8),
                  Text(
                    "Allow our app to automatically activate Focus Profiles for your scheduled events, so you can stay on task without distractions.",
                    style: TextStyle(color: textVariantColor, fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  _buildHeader('How to Set Up on iOS', textColor),
                  const SizedBox(height: 16),
                  _buildInstructionStep('1', 'Tap "Open Settings" to go to Focus settings.', textVariantColor),
                  _buildInstructionStep('2', 'Select a Focus Profile (e.g., "Work").', textVariantColor),
                  _buildInstructionStep('3', 'Add a "Schedule" or "Automation" based on this app\'s calendar.', textVariantColor),
                ],
              ),
            ),
          ),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildStatusPanel(Color cardColor, Color textColor, Color textVariantColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status: Action Required', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
              Text('Permission needed to manage Focus Profiles.', style: TextStyle(color: textVariantColor)),
            ],
          ),
          Switch.adaptive(value: false, onChanged: (value) {}, activeColor: primaryColor),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, Color color) {
    return Text(title, style: TextStyle(color: color, fontSize: 24, fontWeight: FontWeight.bold));
  }

  Widget _buildInstructionStep(String number, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number, style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: TextStyle(color: color, fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(bottom: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Theme.of(context).scaffoldBackgroundColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ElevatedButton(
        onPressed: () { /* Deep-link to settings */ },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text('Set Up in Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// Using the same color palette
const Color primaryColor = Color(0xFF135bec);
const Color darkBackgroundColor = Color(0xFF101622);
const Color lightBackgroundColor = Color(0xFFf6f6f8);
const Color darkCardColor = Color(0xFF1A222D); // Slightly different from design for better contrast
const Color lightCardColor = Colors.white;

class FocusModeScreen extends StatefulWidget {
  const FocusModeScreen({super.key});

  @override
  State<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends State<FocusModeScreen> {
  String _selectedProfile = 'No Profile (Default)';

  // Dummy data based on the design
  final Map<String, IconData> notificationProfiles = {
    'No Profile (Default)': Icons.notifications_off,
    'Full Do Not Disturb': Icons.dark_mode,
    'Allow Contacts Only': Icons.group,
  };

  final Map<String, IconData> systemFocusModes = {
    'Personal': Icons.person,
    'Work': Icons.work,
    'Meeting': Icons.group,
    'Sleep': Icons.bedtime,
  };

  final Map<String, Color> iconColors = {
    'No Profile (Default)': Colors.grey,
    'Full Do Not Disturb': Colors.indigo,
    'Allow Contacts Only': Colors.green,
    'Personal': Colors.cyan,
    'Work': Colors.orange,
    'Meeting': Colors.red,
    'Sleep': Colors.purple,
  };

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? darkBackgroundColor : lightBackgroundColor;
    final cardColor = isDarkMode ? darkCardColor : lightCardColor;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final sectionHeaderColor = isDarkMode ? Colors.white54 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Set Focus', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selectedProfile),
            child: const Text('Done', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Notification Profiles', notificationProfiles, sectionHeaderColor, cardColor, textColor),
            const SizedBox(height: 32),
            _buildSection('System Focus Modes', systemFocusModes, sectionHeaderColor, cardColor, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Map<String, IconData> items, Color headerColor, Color cardColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(title.toUpperCase(), style: TextStyle(color: headerColor, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final key = items.keys.elementAt(index);
              final icon = items[key];
              final color = iconColors[key] ?? Colors.grey;
              return _buildListItem(key, icon!, color, textColor);
            },
            separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : Colors.black12, indent: 60),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(String title, IconData icon, Color color, Color textColor) {
    final isSelected = _selectedProfile == title;
    return ListTile(
      onTap: () => setState(() => _selectedProfile = title),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: Icon(
        isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isSelected ? primaryColor : (Theme.of(context).brightness == Brightness.dark ? Colors.white24 : Colors.grey.shade300),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const ProfileCardApp());
}

class ProfileCardApp extends StatelessWidget {
  const ProfileCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Card App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ProfileCardScreen(),
    );
  }
}

class ProfileCardScreen extends StatelessWidget {
  const ProfileCardScreen({super.key});

  void _showProfileMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for viewing my profile!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Card'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          // Main card that contains the professional profile details.
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Profile icon used as a simple avatar.
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.teal,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 56,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Drin Krasniqi',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Flutter Student',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'I am learning Dart and Flutter during the Internal Internship.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 8),
                  // Contact rows keep the information easy to scan.
                  const ContactInfoRow(
                    icon: Icons.email,
                    text: 'drin.krasniqi@example.com',
                  ),
                  const SizedBox(height: 10),
                  const ContactInfoRow(
                    icon: Icons.phone,
                    text: '+383 44 000 000',
                  ),
                  const SizedBox(height: 10),
                  const ContactInfoRow(
                    icon: Icons.location_on,
                    text: 'Kosovo',
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showProfileMessage(context),
                    icon: const Icon(Icons.visibility),
                    label: const Text('View Profile'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContactInfoRow extends StatelessWidget {
  const ContactInfoRow({
    required this.icon,
    required this.text,
    super.key,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.teal, size: 22),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}

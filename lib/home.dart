import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'agenda.dart'; // Assuming this is the correct import path
import 'profile.dart'; // Add this import
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required String username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = 'Tamu'; // Default value

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      try {
        final response = await http.get(Uri.parse(
            'https://praktikum-cpanel-unbin.com/solev/lugowo/profile_koichi.php?id=$userId'));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['success'] == true && data['data'].isNotEmpty) {
            setState(() {
              username = data['data'][0]['username'];
            });
          }
        }
      } catch (e) {
        print('Error fetching username: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color.fromARGB(255, 34, 34, 34)
          : const Color.fromARGB(255, 122, 122, 122), // Add this line
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang, $username!',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 255, 200, 0),
                              ),
                    ),
                    const SizedBox(height: 20),
                    _buildSummaryCard(context),
                    const SizedBox(height: 20),
                    _buildQuickActions(context),
                    const SizedBox(height: 20),
                    _buildRecentActivity(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
                'Ini adalah halaman beranda aplikasi Anda yang telah ditingkatkan.'),
            const SizedBox(height: 10),
            const LinearProgressIndicator(value: 0.7),
            const SizedBox(height: 10),
            const Text('Progress: 70%',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aksi Cepat',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 91, 91, 91)
                  : const Color.fromARGB(255, 40, 40, 40)),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
              context,
              Icons.add_task,
              'Tugas Baru',
              Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 122, 122, 122)
                  : const Color.fromARGB(255, 122, 122, 122),
            ),
            _buildActionButton(
              context,
              Icons.event,
              'Jadwal',
              Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 122, 122, 122)
                  : const Color.fromARGB(255, 122, 122, 122),
            ),
            _buildActionButton(
              context,
              Icons.bar_chart,
              'Laporan',
              Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 122, 122, 122)
                  : const Color.fromARGB(255, 122, 122, 122),
            ),
            _buildActionButton(
              context,
              Icons.person,
              'Profil',
              Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 122, 122, 122)
                  : const Color.fromARGB(255, 122, 122, 122),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, IconData icon, String label, Color color) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            if (label == 'Jadwal') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AgendaScreen()),
              );
            } else if (label == 'Profil') {
              // New condition for Profile button
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            } else {
              // TODO: Implementasikan aksi untuk tombol lain
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: color,
          ),
          child: Icon(icon, color: const Color.fromARGB(255, 255, 217, 0)),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromARGB(255, 209, 209, 209)
                    : const Color.fromARGB(255, 40, 40, 40))),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktivitas Terbaru',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color.fromARGB(255, 249, 237, 144),
                child: Icon(Icons.person,
                    color: Color.fromARGB(255, 210, 185, 25)),
              ),
              title: Text('Aktivitas ${index + 1}'),
              subtitle: Text('Deskripsi singkat aktivitas ${index + 1}'),
              trailing: Text('${index + 1}j yang lalu'),
            );
          },
        ),
      ],
    );
  }
}

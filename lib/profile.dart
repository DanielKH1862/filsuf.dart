import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      final response = await http.get(Uri.parse(
          'https://praktikum-cpanel-unbin.com/solev/lugowo/profile_koichi.php?id=$userId'));

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == true && result['data'].isNotEmpty) {
          setState(() {
            userData = result['data'][0];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load user data')),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error connecting to server')),
        );
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: userData['foto_profile'] != null
                        ? CachedNetworkImageProvider(
                            'https://praktikum-cpanel-unbin.com/solev/lugowo/assets/images/foto_profile/${userData['foto_profile']}',
                          )
                        : const AssetImage('assets/images/danil.jpg')
                            as ImageProvider,
                    onBackgroundImageError: (exception, stackTrace) {
                      print('Error loading profile image: $exception');
                      setState(() {
                        userData['foto_profile'] =
                            null; // This will trigger using the local asset
                      });
                    },
                    child: userData['foto_profile'] == null
                        ? null // Remove this line if you want to keep the icon
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userData['username'] ?? 'Username',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['email'] ?? 'Email',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.person, color: Colors.yellow[700]),
                        title: const Text('User ID'),
                        subtitle: Text(userData['id']?.toString() ?? 'N/A'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      child: ListTile(
                        leading: Icon(Icons.edit, color: Colors.yellow[700]),
                        title: const Text('Edit Profile'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // TODO: Implement edit profile functionality
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      child: ListTile(
                        leading:
                            Icon(Icons.settings, color: Colors.yellow[700]),
                        title: const Text('Settings'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // TODO: Implement settings functionality
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

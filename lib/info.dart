import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List<dynamic> _infoList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInfo();
  }

  Future<void> _fetchInfo() async {
    try {
      final response = await http.get(Uri.parse(
          'https://praktikum-cpanel-unbin.com/solev/lugowo/info.php'));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData['status'] == 'success') {
          setState(() {
            _infoList = decodedData['data'];
            _isLoading = false;
          });
        } else {
          throw Exception(decodedData['message']);
        }
      } else {
        throw Exception('Failed to load info: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching information: $e')),
      );
    }
  }

  Future<void> _createInfo(String title, String content) async {
    try {
      final response = await http.post(
        Uri.parse('https://praktikum-cpanel-unbin.com/solev/lugowo/info.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'judul_info': title,
          'isi_info': content,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Information created successfully')),
          );
          _fetchInfo(); // Refresh the list
        } else {
          throw Exception(decodedData['message']);
        }
      } else {
        throw Exception('Failed to create info: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating information: $e')),
      );
    }
  }

  Future<void> _updateInfo(String id, String title, String content) async {
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid ID, cannot update')),
      );
      return;
    }

    try {
      final response = await http.put(
        Uri.parse('https://praktikum-cpanel-unbin.com/solev/lugowo/info.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'kd_info': id,
          'judul_info': title,
          'isi_info': content,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Information updated successfully')),
          );
          _fetchInfo(); // Refresh the list
        } else {
          throw Exception(decodedData['message']);
        }
      } else {
        throw Exception('Failed to update info: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating information: $e')),
      );
    }
  }

  Future<void> _deleteInfo(String id) async {
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid ID, cannot delete')),
      );
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('https://praktikum-cpanel-unbin.com/solev/lugowo/info.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'kd_info': id}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        if (decodedData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Information deleted successfully')),
          );
          _fetchInfo(); // Refresh the list
        } else {
          throw Exception(decodedData['message']);
        }
      } else {
        throw Exception('Failed to delete info: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting information: $e')),
      );
    }
  }

  void _showEditDialog(Map<String, dynamic> info) {
    final titleController =
        TextEditingController(text: info['judul_info'] ?? '');
    final contentController =
        TextEditingController(text: info['isi_info'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateInfo(
                info['kd_info'] ?? '',
                titleController.text,
                contentController.text,
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Information'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _createInfo(titleController.text, contentController.text);
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Information'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchInfo,
              child: ListView.builder(
                itemCount: _infoList.length,
                itemBuilder: (context, index) {
                  final info = _infoList[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        info['judul_info'] ?? 'No Title',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 243, 208, 33),
                        ),
                      ),
                      subtitle: Text(
                        'Posted on: ${info['tgl_post_info'] ?? 'Unknown Date'}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                info['isi_info'] ?? 'No Content',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showEditDialog(info),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () =>
                                        _deleteInfo(info['kd_info'] ?? ''),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

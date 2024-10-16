import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List<dynamic> _agendaList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAgenda();
  }

  Future<void> _fetchAgenda() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://praktikum-cpanel-unbin.com/solev/lugowo/agenda.php'));

    if (response.statusCode == 200) {
      setState(() {
        _agendaList = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching agenda')),
      );
    }
  }

  Future<void> _addAgenda(Map<String, dynamic> newAgenda) async {
    final response = await http.post(
      Uri.parse('https://praktikum-cpanel-unbin.com/solev/lugowo/agenda.php'),
      body: json.encode(newAgenda),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      _fetchAgenda();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding agenda')),
      );
    }
  }

  Future<void> _updateAgenda(Map<String, dynamic> updatedAgenda) async {
    final response = await http.put(
      Uri.parse('https://praktikum-cpanel-unbin.com/solev/lugowo/agenda.php'),
      body: json.encode(updatedAgenda),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      _fetchAgenda();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating agenda')),
      );
    }
  }

  Future<void> _deleteAgenda(String id) async {
    final response = await http.delete(
      Uri.parse('https://praktikum-cpanel-unbin.com/solev/lugowo/agenda.php'),
      body: json.encode({'kd_agenda': id}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      _fetchAgenda();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting agenda')),
      );
    }
  }

  void _showAddEditDialog({Map<String, dynamic>? agenda}) {
    final isEditing = agenda != null;
    final titleController =
        TextEditingController(text: agenda?['judul_agenda'] ?? '');
    final contentController =
        TextEditingController(text: agenda?['isi_agenda'] ?? '');
    final dateController =
        TextEditingController(text: agenda?['tgl_agenda'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Agenda' : 'Add Agenda'),
        content: SingleChildScrollView(
          child: ListBody(
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
              TextField(
                controller: dateController,
                decoration:
                    const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newAgenda = {
                'judul_agenda': titleController.text,
                'isi_agenda': contentController.text,
                'tgl_agenda': dateController.text,
              };
              if (isEditing) {
                newAgenda['kd_agenda'] = agenda!['kd_agenda'].toString();
                _updateAgenda(newAgenda);
              } else {
                _addAgenda(newAgenda);
              }
              Navigator.pop(context);
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditDialog(),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchAgenda,
              child: ListView.builder(
                itemCount: _agendaList.length,
                itemBuilder: (context, index) {
                  final agenda = _agendaList[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 243, 208, 33),
                        child: Text(
                          DateFormat('dd')
                              .format(DateTime.parse(agenda['tgl_agenda'])),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      title: Text(
                        agenda['judul_agenda'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 243, 208, 33),
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('MMMM yyyy')
                            .format(DateTime.parse(agenda['tgl_agenda'])),
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
                                agenda['isi_agenda'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Posted on: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(agenda['tgl_post_agenda']))}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _showAddEditDialog(agenda: agenda),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteAgenda(
                                        agenda['kd_agenda'].toString()),
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

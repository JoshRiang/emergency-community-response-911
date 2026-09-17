import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/incident.dart';
import '../services/api_client.dart';
import '../services/websocket_service.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final _api = ApiClient();
  late final CoordinationSocket _socket;
  List<Incident> _incidents = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _socket = CoordinationSocket();
    _socket.connect();
    _socket.messages.listen((msg) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('LIVE: ${msg['title'] ?? 'New alert'}')),
      );
      _load(silent: true);
    });
    _load();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _loading = true);
    try {
      final incidents = await _api.fetchIncidents();
      if (mounted) setState(() => _incidents = incidents);
    } catch (_) {
      // Keep existing list on error.
    } finally {
      if (mounted && !silent) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _api.dispose();
    _socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geospatial Alerts'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _incidents.isEmpty
              ? const Center(child: Text('No alerts yet.'))
              : RefreshIndicator(
                  onRefresh: () => _load(silent: true),
                  child: ListView.builder(
                    itemCount: _incidents.length,
                    itemBuilder: (context, i) {
                      final incident = _incidents[i];
                      return ListTile(
                        leading: Icon(
                          Icons.warning,
                          color: incident.severity ==
                                  IncidentSeverity.critical
                              ? Colors.red
                              : Colors.orange,
                        ),
                        title: Text(incident.title),
                        subtitle: Text(
                          '${incident.category} • ${incident.status.name} • ${DateFormat('dd MMM HH:mm').format(incident.createdAt)}',
                        ),
                        trailing:
                            Text(incident.severity.name.toUpperCase()),
                      );
                    },
                  ),
                ),
    );
  }
}

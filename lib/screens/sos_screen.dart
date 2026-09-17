import 'package:flutter/material.dart';

import '../services/api_client.dart';
import '../services/location_service.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final _api = ApiClient();
  final _location = LocationService();
  bool _sending = false;
  String _status = 'Press and hold SOS to send your live location.';

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }

  Future<void> _sendSos() async {
    setState(() {
      _sending = true;
      _status = 'Getting your location...';
    });
    try {
      final pos = await _location.currentPosition();
      if (pos == null) {
        setState(() => _status = 'Location permission denied. Enable GPS.');
        return;
      }
      setState(() => _status = 'Sending SOS...');
      await _api.sendSos(
        latitude: pos.latitude,
        longitude: pos.longitude,
        reporterName: 'App User',
      );
      setState(() => _status = 'SOS SENT. Help is on the way.');
    } catch (e) {
      setState(() => _status = 'Failed to send SOS: $e');
    } finally {
      setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One-Tap SOS'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onLongPress: _sending ? null : _sendSos,
                onTap: _sending ? null : _sendSos,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: _sending ? Colors.grey : Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: _sending
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'SOS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 64,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your GPS coordinates are shared with nearby responders and the command center.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

/// WebSocket coordination channel for live incident alerts.
class CoordinationSocket {
  final String url;
  WebSocketChannel? _channel;
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  CoordinationSocket({this.url = 'ws://10.0.2.2:8000/ws/alerts'});

  Stream<Map<String, dynamic>> get messages => _controller.stream;

  bool get isConnected => _channel != null;

  void connect() {
    disconnect();
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen(
      (event) {
        try {
          final decoded = jsonDecode(event as String);
          if (decoded is Map<String, dynamic>) {
            _controller.add(decoded);
          }
        } catch (_) {
          // Ignore malformed frames.
        }
      },
      onDone: () => _channel = null,
      onError: (_) => _channel = null,
    );
  }

  void send(Map<String, dynamic> message) {
    _channel?.sink.add(jsonEncode(message));
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
  }

  void dispose() {
    disconnect();
    _controller.close();
  }
}

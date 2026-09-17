import 'package:emergency_community_response_911/models/incident.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Incident JSON round-trip', () {
    final now = DateTime.utc(2026, 9, 17, 12, 0, 0);
    final incident = Incident(
      id: '1',
      title: 'Fire',
      description: 'Kitchen fire',
      category: 'fire',
      latitude: -6.2,
      longitude: 106.8,
      severity: IncidentSeverity.high,
      status: IncidentStatus.reported,
      createdAt: now,
      reporterName: 'Tester',
    );
    final restored = Incident.fromJson(incident.toJson());
    expect(restored.title, 'Fire');
    expect(restored.severity, IncidentSeverity.high);
    expect(restored.status, IncidentStatus.reported);
  });
}

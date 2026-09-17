enum IncidentStatus { reported, acknowledged, dispatched, resolved }

enum IncidentSeverity { low, medium, high, critical }

class Incident {
  final String id;
  final String title;
  final String description;
  final String category;
  final double latitude;
  final double longitude;
  final IncidentSeverity severity;
  final IncidentStatus status;
  final DateTime createdAt;
  final String reporterName;

  const Incident({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.severity,
    required this.status,
    required this.createdAt,
    required this.reporterName,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'general',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      severity: IncidentSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => IncidentSeverity.medium,
      ),
      status: IncidentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => IncidentStatus.reported,
      ),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      reporterName: json['reporter_name']?.toString() ?? 'Anonymous',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'severity': severity.name,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'reporter_name': reporterName,
    };
  }

  Incident copyWith({IncidentStatus? status, IncidentSeverity? severity}) {
    return Incident(
      id: id,
      title: title,
      description: description,
      category: category,
      latitude: latitude,
      longitude: longitude,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      createdAt: createdAt,
      reporterName: reporterName,
    );
  }
}

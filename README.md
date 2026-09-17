# 911 Emergency Community Response Platform

![Flutter Build](https://github.com/JoshRiang/emergency-community-response-911/actions/workflows/flutter_build.yml/badge.svg)

Community emergency-response Flutter app: **One-Tap SOS**, incident reporting, geospatial alerts, WebSocket coordination, and a Leaflet/OSM map (`flutter_map`) backed by a FastAPI backend client.

RPL course — DTE UI.

## Team

| Name | NIM | Role |
|------|-----|------|
| Reinathan | 2406397675 | Mobile / SOS flow |
| Alwahib | 2406397630 | Map & geolocation |
| Joshua | 2406361946 | Backend client & alerts |

## Architecture

```
lib/
  main.dart                 # MaterialApp + named routes
  models/incident.dart      # Incident model (JSON <-> Dart)
  services/
    api_client.dart         # FastAPI HTTP client (incidents + SOS)
    location_service.dart   # geolocator permission + stream
    websocket_service.dart  # live coordination channel
  screens/
    home_screen.dart        # dashboard + big SOS entry
    sos_screen.dart         # big red SOS button + GPS send
    report_screen.dart      # incident report form
    map_screen.dart         # flutter_map (OSM) incident pins
    alerts_screen.dart      # live + REST alert feed
android/app/...             # INTERNET + location permissions
```

## Setup

```bash
flutter pub get
flutter analyze
flutter test
flutter run
# Backend expected at http://10.0.2.2:8000 (Android emulator -> host)
```

## Backend contract

- `GET /api/incidents` -> list of incidents
- `POST /api/incidents` -> create incident
- `POST /api/sos` -> one-tap SOS with lat/lng
- `WS /ws/alerts` -> live alert frames `{title, ...}`

## CI

GitHub Actions (`flutter_build.yml`, Flutter 3.x stable): `pub get` -> `analyze` -> `test` -> `build apk --debug`.

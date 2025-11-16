EGTaxi - Flutter frontend + FastAPI backend

Structure:
- lib/: Flutter code
- lib/services/api.dart: API service to call your FastAPI backend
- backend/: place your backend file here (uploaded by user)

How to run Flutter:
1. Install Flutter SDK.
2. Copy this project folder.
3. Run `flutter pub get`.
4. Run `flutter run` (emulator or device).

Backend:
- The backend file you uploaded is included under backend/.
- Run backend with `uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000`
  (adjust import/module name if different)

Note:
- Emulator (Android) uses 10.0.2.2 to reach host machine at 127.0.0.1.
- For physical device, replace base URL in lib/services/api.dart with your machine IP.
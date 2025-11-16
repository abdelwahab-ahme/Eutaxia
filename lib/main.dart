import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/app_state.dart';
import 'screens/splash_screen.dart';
import 'screens/role_screen.dart';
import 'screens/login_screen.dart';
import 'screens/terms_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/client_home.dart';
import 'screens/map_pick_screen.dart';
import 'screens/client_tracking.dart';
import 'screens/driver_home.dart';
import 'screens/driver_trips.dart';
import 'screens/driver_tracking.dart';
import 'screens/payment_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const EGTaxiApp());
}

class EGTaxiApp extends StatelessWidget {
  const EGTaxiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      builder: (context, child) {
        final state = Provider.of<AppState>(context);
        return MaterialApp(
          title: 'EGTaxi',
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
          darkTheme: ThemeData.dark(useMaterial3: true),
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (_) => const SplashScreen(),
            RoleScreen.routeName: (_) => const RoleScreen(),
            LoginScreen.routeName: (_) => const LoginScreen(),
            TermsScreen.routeName: (_) => const TermsScreen(),
            WelcomeScreen.routeName: (_) => const WelcomeScreen(),
            ClientHome.routeName: (_) => const ClientHome(),
            MapPickScreen.routeName: (_) => const MapPickScreen(),
            ClientTracking.routeName: (_) => const ClientTracking(),
            DriverHome.routeName: (_) => const DriverHome(),
            DriverTrips.routeName: (_) => const DriverTrips(),
            DriverTracking.routeName: (_) => const DriverTracking(),
            PaymentScreen.routeName: (_) => const PaymentScreen(),
            ChatScreen.routeName: (_) => const ChatScreen(),
          },
        );
      },
    );
  }
}
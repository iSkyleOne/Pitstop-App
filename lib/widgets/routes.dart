// lib/routes.dart
import 'package:flutter/material.dart';
import 'package:pitstop_app/screens/auth/login_screen.dart';
// import 'screens/client/dashboard.dart';
// import 'screens/client/profile.dart';
// import 'screens/client/my_cars.dart';
// import 'screens/client/appointments.dart';
// import 'screens/admin/dashboard.dart';
// import 'screens/admin/appointments.dart';
// import 'screens/admin/customers.dart';
// import 'screens/admin/services.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();

  static Map<String, WidgetBuilder> get routes {
    return {
      // // Rute pentru client
      // '/client/dashboard': (context) => ClientDashboardScreen(),
      // '/client/profile': (context) => ClientProfileScreen(),
      // '/client/cars': (context) => MyCarScreen(),
      // '/client/appointments': (context) => ClientAppointmentScreen(),

      // // Rute pentru admin/angajați
      // '/admin/dashboard': (context) => AdminDashboardScreen(),
      // '/admin/appointments': (context) => AdminAppointmentScreen(),
      // '/admin/customers': (context) => CustomersScreen(),
      // '/admin/services': (context) => ServicesScreen(),
      '/auth/login': (context) => LoginScreen(), // Ruta pentru login
    };
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];

    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }

    // Ruta de fallback sau pagină de eroare
    return MaterialPageRoute(
      builder: (_) => Scaffold(body: Center(child: Text('Pagină negăsită'))),
    );
  }
}

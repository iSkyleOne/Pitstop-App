// lib/app.dart
import 'package:flutter/material.dart';
import 'package:pitstop_app/widgets/app_drawer.dart';
import 'package:pitstop_app/widgets/routes.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';

class PitstopApp extends StatelessWidget {
  const PitstopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitstop Auto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // Verifică dacă utilizatorul este autentificat
          if (authProvider.isAuthenticated) {
            return MainLayout();
          } else {
            return LoginScreen();
          }
        },
      ),
      routes: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final bool isClient = authProvider.currentUser?.isClient ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pitstop Auto Service'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => authProvider.logout(),
          ),
        ],
      ),
      drawer: AppDrawer(isClient: isClient),
      body: Navigator(
        key: AppRoutes.mainNavigatorKey,
        initialRoute: isClient ? '/client/dashboard' : '/admin/dashboard',
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}

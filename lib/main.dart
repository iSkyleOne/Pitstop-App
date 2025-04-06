import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pitstop_app/app.dart';
import 'package:pitstop_app/providers/auth_provider.dart';
import 'package:pitstop_app/services/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, AuthProvider>(
          create:
              (context) =>
                  AuthProvider(authService: context.read<AuthService>()),
          update:
              (context, authService, previous) =>
                  AuthProvider(authService: authService),
        ),
      ],
      child: PitstopApp(),
    ),
  );
}

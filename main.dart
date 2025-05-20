// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:provider/provider.dart'; // Keep for non-auth providers
import 'package:hive_flutter/hive_flutter.dart';

// BLoC imports
import 'package:flutter_development/bloc/auth/auth_bloc.dart';
import 'package:flutter_development/bloc/auth/auth_event.dart';
import 'package:flutter_development/data/auth_data.dart';

// Other Provider imports
import 'package:flutter_development/data/attendance_provider.dart';
import 'package:flutter_development/theme/central_app_theme_color.dart';
import 'package:flutter_development/providers/app_module_provider.dart';

// Screen/Widget imports
import 'package:flutter_development/widgets/login_auth_wrapper.dart';
import 'package:flutter_development/models/hrms/payslips.dart'; // Ensure this path is correct

const String payslipsBoxName = 'payslipsBox';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Make sure the adapter name and typeId match your model
  if (!Hive.isAdapterRegistered(PayslipAdapter().typeId)) {
    Hive.registerAdapter(PayslipAdapter());
  }
  if (!Hive.isAdapterRegistered(PayslipItemAdapter().typeId)) {
    Hive.registerAdapter(PayslipItemAdapter());
  }

  await Hive.openBox<Payslip>(payslipsBoxName);

  final AuthData authData = AuthData(); // Instantiate AuthData once

  runApp(
    MultiProvider( // Use MultiProvider for BlocProvider and other ChangeNotifierProviders
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authData: authData)
            ..add(CheckLoginStatus()), // Dispatch initial event
        ),
        // Add other existing providers here
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => AppModuleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    return MaterialApp(
      title: 'GainHub',
      theme: ThemeController.lightTheme,
      darkTheme: ThemeController.darkTheme,
      themeMode: themeController.themeMode,
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
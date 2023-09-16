import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:perindo_bisnis_flutter/app/locator.dart';
import 'package:perindo_bisnis_flutter/services/prefs_service.dart';
import 'package:perindo_bisnis_flutter/views/login_view.dart';
import 'package:perindo_bisnis_flutter/views/main_view.dart';
import 'package:perindo_bisnis_flutter/views/pending_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  await setupLocator();
  final prefsService = locator<PrefsService>();

  // Default home view is MainView
  Widget home = const MainView();

  // Check if user doesn't have a token. If true, go to LoginView.
  // If user has a token, check if the user is not approved. If true, go to
  // PendingView
  if (prefsService.getAccessToken() == null) {
    home = const LoginView();
  } else if (prefsService.isUserApproved() == null ||
      !prefsService.isUserApproved()!) {
    home = const PendingView();
  }

  runApp(MyApp(home: home));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.home,
  });

  final Widget home;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perindo Bisnis',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}

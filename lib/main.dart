// import 'package:fblab02/screens/home.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'notification_service.dart';

import 'screens/users/user_info.dart';
import 'screens/users/user_view.dart';
import 'screens/login.dart';
import 'screens/signup.dart';
import 'screens/splash.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

//   // await Firebase.initializeApp();
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         // Can Get all these details from JSon File
//         apiKey: "AIzaSyDzCGm-48HJ8CsGoxCtf4EysZJIov3ZFbg",
//         appId: "1:1025366613894:android:3396e627eb8ecad7a75607",
//         messagingSenderId: "1025366613894",
//         projectId: "integracodeinc",
// // Sender ID from the Firebase
//         // Can Get from JSon File
//         // Your web Firebase config options
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }
//  await NotificationService().registerPushNotificationHandler();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDzCGm-48HJ8CsGoxCtf4EysZJIov3ZFbg",
      appId: "1:1025366613894:android:3396e627eb8ecad7a75607",
      messagingSenderId: "1025366613894",
      projectId: "integracodeinc",
    ),
  );
  // runApp(const MyApp());
  await NotificationService().registerPushNotificationHandler();
  // runApp(MultiProvider(providers: [
  //   ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
  // ], child: RootApp()));

  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Demo',

      routes: {
        '/': (context) => SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => UserView(),
        '/profile': (context) => UserProfileInfo(),
      },

      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 4, 2, 9)),
        useMaterial3: true,
      ),
      // home: HomePage(title: 'Flutter Firebase Lab'),
    );
  }
}

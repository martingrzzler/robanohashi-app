import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robanohashi/firebase_options.dart';
import 'package:robanohashi/pages/kanji/kanji.dart';
import 'package:robanohashi/pages/user.dart';
import 'package:robanohashi/pages/radical/radical.dart';
import 'package:robanohashi/pages/vocabulary/vocabulary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:robanohashi/service/auth.dart';

import 'layout.dart';
import 'pages/home/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    print("LOG error initializing Firebase: $e");
  }
  FirebaseUIAuth.configureProviders(
      [EmailAuthProvider(), GoogleProvider(clientId: '')]);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) => context.read<AuthService>().authStateChanges,
            initialData: null)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[800],
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[500],
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
            ),
          ),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.grey[800],
                displayColor: Colors.grey[800],
              ),
          colorScheme: const ColorScheme.light(
            primary: Colors.grey,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Layout(child: Home()),
          '/login': (context) => SignInScreen(
                actions: [
                  AuthStateChangeAction<SignedIn>((context, state) {
                    if (!state.user!.emailVerified) {
                      Navigator.pushNamed(context, '/verify-email');
                    } else {
                      Navigator.pop(context);
                    }
                  }),
                  AuthStateChangeAction<UserCreated>((context, state) {
                    // AuthStateChangeAction<SignedIn> does not trigger on registered user
                    if (!state.credential.user!.emailVerified) {
                      Navigator.pushNamed(context, '/verify-email');
                    } else {
                      Navigator.pushReplacementNamed(context, '/');
                    }
                  }),
                ],
              ),
          '/verify-email': (context) => EmailVerificationScreen(
                actions: [
                  EmailVerifiedAction(() {
                    Navigator.pushReplacementNamed(context, '/');
                  })
                ],
              ),
          '/user': (context) => const Layout(child: UserView()),
          '/profile': (context) => ProfileScreen(
                actions: [
                  SignedOutAction((context) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  }),
                ],
              )
        },
        onGenerateRoute: (settings) {
          print("LOG onGenerateRoute: ${settings.name}");
          switch (settings.name) {
            case KanjiView.routeName:
              final args = settings.arguments as KanjiViewArgs;
              return MaterialPageRoute(
                builder: (context) => Layout(child: KanjiView(id: args.id)),
              );
            case RadicalView.routeName:
              final args = settings.arguments as RadicalViewArgs;
              return MaterialPageRoute(
                builder: (context) => Layout(child: RadicalView(id: args.id)),
              );
            case VocabularyView.routeName:
              final args = settings.arguments as VocabularyViewArgs;
              return MaterialPageRoute(
                builder: (context) =>
                    Layout(child: VocabularyView(id: args.id)),
              );
            default:
              throw Exception('Unknown route: ${settings.name}');
          }
        },
      ),
    );
  }
}

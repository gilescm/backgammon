import 'package:backgammon/app.dart';
import 'package:backgammon/widgets/webview_screen.dart';
import 'package:go_router/go_router.dart';

enum RouteNames {
  home('/'),
  webview('webview');

  const RouteNames(this.name);

  final String name;

  String get goName => '/$name';
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: RouteNames.home.name,
      builder: (_, __) => const BackgammonApp(),
      routes: <RouteBase>[
        GoRoute(
          path: RouteNames.webview.name,
          builder: (_, __) => const WebviewScreen(),
        ),
      ],
    ),
  ],
);

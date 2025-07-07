import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_clean_architecture/feature/counter/presentation/pages/counter_page.dart';

GoRouter router([String? initialLocation]) => GoRouter(
      debugLogDiagnostics: kDebugMode || kProfileMode,
      initialLocation: initialLocation ?? '/',
      routes: [
        GoRoute(
          path: CounterPage.path,
          name: CounterPage.pathName,
          builder: (context, state) => const CounterPage(),
        ),
      ],
    );

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/viewmodels/theme_viewmodel.dart';
import 'presentation/viewmodels/profile_viewmodel.dart';

void main() {
  runApp(
    const ProviderScope(
      child: PortfolioApp(),
    ),
  );
}

/// Allows scrolling by dragging with a mouse (not just touch/trackpad),
/// which feels natural on the Web/desktop builds of this portfolio.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class PortfolioApp extends ConsumerWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeViewModel = ref.watch(themeProvider);
    final profile = ref.watch(profileViewModelProvider);

    return MaterialApp(
      title: profile.seoTitle,
      debugShowCheckedModeBanner: false,
      themeMode: themeViewModel.mode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      scrollBehavior: AppScrollBehavior(),
      home: const HomePage(),
    );
  }
}

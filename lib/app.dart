import 'package:flutter/material.dart';

import 'chat/widgets/chat_modal.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'counter/view/counter_page.dart';
import 'test/view/test_page.dart';

/// Root application widget
class App extends StatefulWidget {
  const App({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isChatOpen = false;

  void _toggleChat() {
    setState(() => _isChatOpen = !_isChatOpen);
  }

  void _closeChat() {
    setState(() => _isChatOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.navigatorKey,
      title: AppConstants.appTitle,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const CounterPage(),
        '/test': (context) => const TestPage(),
      },
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),
            if (_isChatOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeChat,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            if (_isChatOpen)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Builder(
                  builder: (context) => ChatModal(onClose: _closeChat),
                ),
              ),
            if (!_isChatOpen)
              Positioned(
                right: 16,
                bottom: 16,
                child: FloatingActionButton(
                  onPressed: _toggleChat,
                  backgroundColor: Colors.purple,
                  child: const Icon(Icons.chat, color: Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }
}

import 'package:quick_actions/quick_actions.dart';

class ShortcutItems {
  static final items = <ShortcutItem>[
    actionCaptivePortal,
  ];

  static const actionCaptivePortal = ShortcutItem(
    type: 'action_captiveportal',
    localizedTitle: 'Login Hotspot',
    icon: 'ic_launcher',
  );
}

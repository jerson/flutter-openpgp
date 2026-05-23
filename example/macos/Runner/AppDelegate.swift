import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    // super creates and makes the window key; activate + orderFrontRegardless
    // run in the next run-loop turn so the window exists when we call them.
    // This forces the window on-screen in CI where `open` cannot foreground it,
    // which in turn lets CVDisplayLink fire so pumpWidget/pumpAndSettle settle.
    super.applicationDidFinishLaunching(notification)
    DispatchQueue.main.async {
      NSApp.activate(ignoringOtherApps: true)
      NSApp.windows.first?.orderFrontRegardless()
    }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}

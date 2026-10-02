import UIKit
import Flutter
import workmanager_apple

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)

    // The database stores account credentials in plain text; flag it so
    // iCloud and Finder/iTunes backups skip it. Users move it deliberately
    // via export/import instead.
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "e1547/storage",
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { call, result in
        switch call.method {
        case "excludeFromBackup":
          guard let args = call.arguments as? [String: Any],
                let path = args["path"] as? String else {
            result(FlutterError(code: "bad_args", message: "path required", details: nil))
            return
          }
          do {
            let url = NSURL(fileURLWithPath: path)
            try url.setResourceValue(true, forKey: .isExcludedFromBackupKey)
            result(true)
          } catch {
            result(FlutterError(code: "io_error", message: error.localizedDescription, details: nil))
          }
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    WorkmanagerPlugin.setPluginRegistrantCallback { registry in
        GeneratedPluginRegistrant.register(with: registry)
    }

    WorkmanagerPlugin.registerPeriodicTask(
      withIdentifier: "net.clynamic.e1547.follows",
      frequency: nil,
    )

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

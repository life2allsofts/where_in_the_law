import UIKit
import Flutter
import GoogleMobileAds
import AppTrackingTransparency
import FirebaseCore


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // ✅ Correct initialization of Google Mobile Ads SDK (v11+)
    MobileAds.shared.start(completionHandler: nil)

    // ✅ Request tracking authorization
    requestTrackingAuthorization()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func requestTrackingAuthorization() {
    if #available(iOS 14, *) {
      ATTrackingManager.requestTrackingAuthorization { status in
        switch status {
        case .authorized:
          print("Tracking authorization: Authorized")
        case .denied:
          print("Tracking authorization: Denied")
        case .notDetermined:
          print("Tracking authorization: Not Determined")
        case .restricted:
          print("Tracking authorization: Restricted")
        @unknown default:
          print("Tracking authorization: Unknown")
        }
      }
    }
  }
}
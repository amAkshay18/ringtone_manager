import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var audioPlayer: AVAudioPlayer?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.example.ringtone_manager/ringtone",
                                           binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case "getDefaultRingtone":
                self.getDefaultRingtone(result: result)
            case "playDefaultRingtone":
                self.playDefaultRingtone(result: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func getDefaultRingtone(result: FlutterResult) {
        guard let soundUrl = Bundle.main.url(forResource: "opening", withExtension: "caf") else {
            // iOS doesn't have public API to access system ringtones, so we use a bundled sound
            // In a real app, you would need to bundle a default sound
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Default ringtone not available on iOS",
                                details: nil))
            return
        }
        
        let response: [String: Any] = [
            "title": "Default iOS Ringtone",
            "path": soundUrl.absoluteString
        ]
        
        result(response)
    }
    
    private func playDefaultRingtone(result: FlutterResult) {
        guard let soundUrl = Bundle.main.url(forResource: "opening", withExtension: "caf") else {
            result(FlutterError(code: "UNAVAILABLE",
                                message: "Default ringtone not available on iOS",
                                details: nil))
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            audioPlayer?.play()
            result(nil)
        } catch {
            result(FlutterError(code: "PLAY_ERROR",
                                message: "Failed to play ringtone",
                                details: error.localizedDescription))
        }
    }
}
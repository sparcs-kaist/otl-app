import UIKit
import Flutter
import ChannelIOFront
import WatchConnectivity

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    var session: WCSession?
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ChannelIO.initialize(application)
        GeneratedPluginRegistrant.register(with: self)
        initFlutterChannel()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func initFlutterChannel() {
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(
                name: "org.sparcs.otlplus.watchkitapp",
                binaryMessenger: controller.binaryMessenger)
            
            channel.setMethodCallHandler({ [weak self] (
                call: FlutterMethodCall,
                result: @escaping FlutterResult) -> Void in
                switch call.method {
                case "flutterToWatch":
                    guard let watchSession = self?.session,
                          watchSession.isPaired,
                          let methodData = call.arguments as? [String: Any],
                          let method = methodData["method"],
                          let data = methodData["data"] else {
                        result(false)
                        return
                    }
                    let watchData: [String: Any] = ["method": method, "data": data]
                    watchSession.transferUserInfo(watchData)
                    result(true)
                default:
                    result(FlutterMethodNotImplemented)
                }
            })
        }
    }
}

extension AppDelegate: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }
    
    func sessionDidBecomeInactive(_ session: WCSession) { }
    
    func sessionDidDeactivate(_ session: WCSession) { }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            if let method = userInfo["method"] as? String, let controller = self.window?.rootViewController as? FlutterViewController {
                let channel = FlutterMethodChannel(
                    name: "org.sparcs.otlplus.watchkitapp",
                    binaryMessenger: controller.binaryMessenger)
                channel.invokeMethod(method, arguments: userInfo)
            }
        }
    }
}

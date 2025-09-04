//import SwiftUI
//import FirebaseCore
//
//// Minimal AppDelegate conforming to UIApplicationDelegate
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
//    ) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}
//
//@main
//struct LifeFlowApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject private var authViewModel = AuthViewModel()
//
//    var body: some Scene {
//        WindowGroup {
//            MainTabView()
//                .environmentObject(authViewModel)
//        }
//    }
//}

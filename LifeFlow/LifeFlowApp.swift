import SwiftUI
import Firebase

@main
struct LifeFlowApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authViewModel.user == nil {
                // 🔑 Show login/signup if not logged in
                AuthView()
                    .environmentObject(authViewModel)
            } else {
                // ✅ Show main dashboard if logged in
                MainTabView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

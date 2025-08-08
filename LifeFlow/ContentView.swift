import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        if authViewModel.isLoggedIn {
            MainTabView()
                .environmentObject(authViewModel)
        } else {
            AuthScreen()
                .environmentObject(authViewModel)
        }
    }
}

struct AuthScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogin = false

    var body: some View {
        VStack {
            if showLogin {
                LoginView(isLoggedIn: $authViewModel.isLoggedIn)
            } else {
                SignupView(isLoggedIn: $authViewModel.isLoggedIn)
            }

            Button(action: {
                showLogin.toggle()
            }) {
                Text(showLogin ? "Don't have an account? Sign Up" : "Already have an account? Log In")
                    .font(.footnote)
                    .padding(.top)
            }
        }
    }
}

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.colorScheme) var colorScheme   // 👈 Detect system theme
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true
    
    var body: some View {
        ZStack {
            // 🔴 Adaptive gradient background
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .dark
                                   ? [Color.black, Color.gray.opacity(0.8)]
                                   : [Color.red.opacity(0.9), Color.red.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // 🩸 Logo + Title
                VStack(spacing: 10) {
                    Image(systemName: "drop.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(colorScheme == .dark ? .red : .white)
                    
                    Text(isLogin ? "Welcome Back" : "Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("LifeLine • Donate Blood, Save Lives")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.bottom, 40)
                
                // 🪟 Card container
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    Button(action: {
                        if isLogin {
                            authVM.login(email: email, password: password)
                        } else {
                            authVM.signup(email: email, password: password)
                        }
                    }) {
                        Text(isLogin ? "Login" : "Sign Up")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .red.opacity(0.4), radius: 6, x: 0, y: 4)
                    }
                    
                    Button(action: { isLogin.toggle() }) {
                        Text(isLogin ? "Don’t have an account? Sign Up" : "Already have an account? Login")
                            .font(.footnote)
                            .foregroundColor(.red)
                            .underline()
                    }
                }
                .padding()
                .background(colorScheme == .dark ? Color.black.opacity(0.8) : Color.white)
                .cornerRadius(20)
                .padding(.horizontal, 25)
                .shadow(radius: 10)
                
                Spacer()
            }
        }
    }
}

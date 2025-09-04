import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true
    @State private var isDarkMode = false // 🌙 user toggle
    
    var body: some View {
        ZStack {
            // 🌌 Adaptive gradient background
            LinearGradient(
                gradient: Gradient(colors: isDarkMode
                                   ? [Color.black, Color.gray.opacity(0.8)]
                                   : [Color.red.opacity(0.9), Color.red.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // 🌙 Theme toggle
                HStack {
                    Spacer()
                    Button(action: { isDarkMode.toggle() }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(isDarkMode ? .yellow : .white)
                            .padding(12)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
                
                // 🩸 Logo + Title
                VStack(spacing: 10) {
                    Image(systemName: "drop.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(isDarkMode ? .red : .white)
                    
                    Text(isLogin ? "Welcome Back" : "Create Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(isDarkMode ? .white : .white)
                    
                    Text("LifeLine • Donate Blood, Save Lives")
                        .font(.footnote)
                        .foregroundColor(isDarkMode ? .white.opacity(0.7) : .white.opacity(0.8))
                }
                .padding(.bottom, 40)
                
                // 🪟 Card container
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(isDarkMode ? Color.black.opacity(0.6) : Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .foregroundColor(isDarkMode ? .white : .black)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(isDarkMode ? Color.black.opacity(0.6) : Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .foregroundColor(isDarkMode ? .white : .black)
                    
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
                            .background(isDarkMode ? Color.red.opacity(0.8) : Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .red.opacity(0.4), radius: 6, x: 0, y: 4)
                    }
                    
                    Button(action: { isLogin.toggle() }) {
                        Text(isLogin ? "Don’t have an account? Sign Up" : "Already have an account? Login")
                            .font(.footnote)
                            .foregroundColor(isDarkMode ? .red : .red)
                            .underline()
                    }
                }
                .padding()
                .background(isDarkMode ? Color.black.opacity(0.8) : Color.white)
                .cornerRadius(20)
                .padding(.horizontal, 25)
                .shadow(radius: 10)
                
                Spacer()
            }
        }
        // Force theme per user toggle
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .animation(.easeInOut, value: isDarkMode)
    }
}

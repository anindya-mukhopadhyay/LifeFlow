import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark
    
    var id: String { self.rawValue }
    var displayName: String {
        switch self {
        case .system: return "System Default"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

struct SignupView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Binding var isLoggedIn: Bool
    
    @AppStorage("selectedTheme") private var selectedTheme: AppTheme = .system
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Signup")
                .font(.title)
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Signup") {
                signup()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            if !errorMessage.isEmpty {
                Text(errorMessage).foregroundColor(.red)
            }
            
            // Theme Picker
            Picker("Theme", selection: $selectedTheme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.displayName).tag(theme)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, 20)
        }
        .padding()
        .preferredColorScheme(colorScheme) // 🔥 Apply theme
    }
    
    // 🔥 Convert theme enum to SwiftUI color scheme
    private var colorScheme: ColorScheme? {
        switch selectedTheme {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    func signup() {
        guard let url = URL(string: "http://localhost:3000/signup") else { return }
        
        let body: [String: String] = [
            "name": name,
            "email": email,
            "password": password
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "❌ No response"
                }
                return
            }
            
            if let decoded = try? JSONDecoder().decode(SignupResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "❌ Signup failed"
                }
            }
        }.resume()
    }
}

struct SignupResponse: Decodable {
    let message: String
}

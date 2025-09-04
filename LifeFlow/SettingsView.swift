import SwiftUI
import UIKit

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // Profile storage
    @AppStorage("userName") private var name: String = "Your Name"
    @AppStorage("userEmail") private var email: String = "you@example.com"
    @AppStorage("profileImageData") private var profileImageData: Data? // Profile image
    
    // Preferences storage
    @State private var notificationsEnabled = true
    @AppStorage("selectedTheme") private var selectedTheme = "System"
    @State private var selectedLanguage = "English"

    var languages = ["English", "Hindi", "Bengali", "Spanish"]
    var themes = ["System", "Light", "Dark"]

    var body: some View {
        NavigationView {
            Form {
                // Profile
                Section(header: Text("Profile")) {
                    NavigationLink(destination: EditProfileView()) {
                        HStack(spacing: 16) {
                            if let data = profileImageData,
                               let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.blue)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(name)
                                    .font(.headline)
                                Text(email)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }

                // General
                Section(header: Text("General")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)

                    Picker("Theme", selection: $selectedTheme) {
                        ForEach(themes, id: \.self) { theme in
                            Text(theme)
                        }
                    }

                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language)
                        }
                    }
                }

                // App Info
                Section(header: Text("App Info")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Developer")
                        Spacer()
                        Text("Team Glitch Gods")
                            .foregroundColor(.gray)
                    }
                }

                // Logout
                Section {
                    Button(role: .destructive) {
                        authViewModel.logout()
                    } label: {
                        Text("Log Out")
                    }
                }
            }
            .navigationTitle("Settings")
        }
        // 🔥 Apply Theme
        .preferredColorScheme(resolveTheme())
    }
    
    private func resolveTheme() -> ColorScheme? {
        switch selectedTheme {
        case "Light": return .light
        case "Dark": return .dark
        default: return nil // System
        }
    }
}

struct EditProfileView: View {
    @AppStorage("userName") private var name: String = "Your Name"
    @AppStorage("userEmail") private var email: String = "you@example.com"
    
    var body: some View {
        Form {
            Section(header: Text("Edit Info")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
            }

            Section {
                Button("Save Changes") {
                    // Auto-saved with @AppStorage
                }
            }
        }
        .navigationTitle("Edit Profile")
    }
}

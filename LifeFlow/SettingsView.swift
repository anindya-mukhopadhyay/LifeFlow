import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var notificationsEnabled = true
    @State private var selectedTheme = "System"
    @State private var selectedLanguage = "English"

    var languages = ["English", "Hindi", "Bengali", "Spanish"]
    var themes = ["System", "Light", "Dark"]

    var body: some View {
        NavigationView {
            Form {
                // Profile
                Section(header: Text("Profile")) {
                    NavigationLink(destination: EditProfileView()) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Anindya Mukhopadhyay")
                                    .font(.headline)
                                Text("anindya@example.com")
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
                        Text("Project Builder")
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
    }
}

struct EditProfileView: View {
    @State private var name = "Anindya Mukhopadhyay"
    @State private var email = "anindya@example.com"

    var body: some View {
        Form {
            Section(header: Text("Edit Info")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
            }

            Section {
                Button("Save Changes") {
                    // Save action here
                }
            }
        }
        .navigationTitle("Edit Profile")
    }
}

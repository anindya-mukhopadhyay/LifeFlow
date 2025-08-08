import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Login").font(.title)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Login") {
                login()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            Text(errorMessage).foregroundColor(.red)
        }
        .padding()
    }

    func login() {
        guard let url = URL(string: "http://localhost:3000/login") else { return }

        let body: [String: String] = [
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
                    self.errorMessage = "❌ No response from server"
                }
                return
            }

            if let decoded = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "❌ Invalid credentials"
                }
            }
        }.resume()
    }
}

struct LoginResponse: Decodable {
    let message: String
    let user: User
}

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}

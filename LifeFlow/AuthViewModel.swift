import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var isLoggedIn = false

    let baseURL = "http://localhost:3000/api" // Replace with your server URL

    func login(email: String, password: String) {
        guard let url = URL(string: "\(baseURL)/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(APIResponse.self, from: data)

                DispatchQueue.main.async {
                    if result.success {
                        self.isLoggedIn = true
                    } else {
                        print("Login failed: \(result.message)")
                    }
                }

            } catch {
                print("Error decoding login response: \(error)")
            }
        }.resume()
    }

    func signup(email: String, password: String) {
        guard let url = URL(string: "\(baseURL)/signup") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }

            do {
                let result = try JSONDecoder().decode(APIResponse.self, from: data)

                DispatchQueue.main.async {
                    if result.success {
                        self.isLoggedIn = true
                    } else {
                        print("Signup failed: \(result.message)")
                    }
                }

            } catch {
                print("Error decoding signup response: \(error)")
            }
        }.resume()
    }

    func logout() {
        isLoggedIn = false
    }
}

struct APIResponse: Decodable {
    let success: Bool
    let message: String
}

import SwiftUI

struct ContactUsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Email: support@bloodapp.com")
            Text("Phone: +91-9876543210")
            Text("Address: 123 Red Cross Road, Kolkata, India")
            Spacer()
        }
        .padding()
        .navigationTitle("Contact Us")
    }
}

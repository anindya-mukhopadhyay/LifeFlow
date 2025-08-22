// 🔵 Register for NGO Screen
import SwiftUI
struct RegisterForNGOView: View {
    var body: some View {
        Form {
            Section(header: Text("Your Details")) {
                TextField("Full Name", text: .constant(""))
                TextField("Email", text: .constant(""))
                TextField("Phone Number", text: .constant(""))
            }

            Section(header: Text("NGO Selection")) {
                Picker("Choose NGO", selection: .constant("Red Cross")) {
                    Text("Red Cross").tag("Red Cross")
                    Text("Smile Foundation").tag("Smile Foundation")
                    Text("Blood Connect").tag("Blood Connect")
                    Text("CRY").tag("CRY")
                }
            }

            Button(action: {
                print("Register button tapped")
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationTitle("Register for NGO")
    }
}

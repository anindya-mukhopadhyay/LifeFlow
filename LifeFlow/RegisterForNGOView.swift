// 🔵 Register for NGO Screen
import SwiftUI
struct RegisterForNGOView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var selectedNGO = "Red Cross"

    let ngos = ["Red Cross", "Smile Foundation", "Blood Connect", "CRY"]

    var body: some View {
        Form {
            Section(header: Text("Your Details")) {
                TextField("Full Name", text: $name)
                TextField("Email", text: $email)
                TextField("Phone Number", text: $phone)
            }

            Section(header: Text("Select NGO")) {
                Picker("Choose NGO", selection: $selectedNGO) {
                    ForEach(ngos, id: \.self) { ngo in
                        Text(ngo)
                    }
                }
            }

            Button(action: {
                print("Registered for NGO: \(selectedNGO)")
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

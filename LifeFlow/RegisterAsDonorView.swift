import SwiftUI

struct RegisterAsDonorView: View {
    @State private var fullName: String = ""
    @State private var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    @State private var bloodGroup: String = ""
    @State private var contactNumber: String = ""
    @State private var lastDonationDate: Date = Date()
    @State private var consentGiven: Bool = false
    @State private var address: String = ""
    @State private var emgContact: String = ""
    
    let bloodGroups = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]

    var body: some View {
        Form {
            Section(header: Text("Personal Details")) {
                TextField("Full Name", text: $fullName)

                DatePicker("Date of Birth", selection: $dateOfBirth, in: ...Date(), displayedComponents: .date)

                Picker("Blood Group", selection: $bloodGroup) {
                    ForEach(bloodGroups, id: \.self) { group in
                        Text(group)
                    }
                }

                TextField("Contact Number", text: $contactNumber)
                    .keyboardType(.phonePad)

                Text("Age: \(calculatedAge)")
                    .foregroundColor(calculatedAge < 18 ? .red : .gray)
            }
            Section(header: Text("Address")) {
                TextField("Address", text: $address)
                TextField("Emergency Contact", text: $emgContact)
            }

            Section(header: Text("Donation History")) {
                DatePicker("Last Donation Date", selection: $lastDonationDate, displayedComponents: .date)
            }

            Section {
                Toggle(isOn: $consentGiven) {
                    Text("I consent to be contacted for donation")
                }
            }
//            Section(header: Text("Address")) {
//                TextField("Address", text: $address)
//            }

            Section {
                Button(action: handleSubmit) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(formIsValid ? Color.red : Color.gray.opacity(0.4))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(!formIsValid)
            }

            if calculatedAge < 18 {
                Text("You must be 18 or older to register as a donor.")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .navigationTitle("Register as Donor")
    }

    var calculatedAge: Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        return ageComponents.year ?? 0
    }

    var formIsValid: Bool {
        return !fullName.isEmpty &&
               !bloodGroup.isEmpty &&
               !contactNumber.isEmpty &&
               !address.isEmpty &&
               calculatedAge >= 18 &&
               consentGiven
    }

    func handleSubmit() {
        print("✅ Donor Registered:")
        print("Name: \(fullName)")
        print("DOB: \(dateOfBirth)")
        print("Age: \(calculatedAge)")
        print("Blood Group: \(bloodGroup)")
        print("Contact: \(contactNumber)")
        print("Address: \(address)")
        print("Last Donation: \(lastDonationDate)")
    }
}

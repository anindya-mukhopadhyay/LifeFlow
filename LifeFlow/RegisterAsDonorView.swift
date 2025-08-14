import SwiftUI

struct RegisterAsDonorView: View {
    // 🔹 Profile details (read-only)
    @AppStorage("userName") private var fullName: String = ""
    @AppStorage("userDOB") private var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    @AppStorage("userBloodGroup") private var bloodGroup: String = ""
    @AppStorage("userPhone") private var contactNumber: String = ""
    @AppStorage("userAddress") private var address: String = ""
    @AppStorage("emergencyContactNumber") private var emgContact: String = ""

    // 🔹 Editable donor-specific details
    @State private var lastDonationDate: Date = Date()
    @State private var consentGiven: Bool = false
    @State private var locationPermission: Bool = false
    @State private var healthCriteriaMet: Bool = false // ✅ New toggle for health check

    var body: some View {
        Form {
            // 📌 Personal Details (Read-Only)
            Section(header: Text("Personal Details")) {
                displayRow(label: "Full Name", value: fullName)
                displayRow(label: "Date of Birth", value: dateOfBirth.formatted(date: .abbreviated, time: .omitted))
                displayRow(label: "Blood Group", value: bloodGroup)
                displayRow(label: "Contact Number", value: contactNumber)
                displayRow(label: "Age", value: "\(calculatedAge)")
            }

            // 📌 Address (Read-Only)
            Section(header: Text("Address")) {
                displayRow(label: "Address", value: address)
                displayRow(label: "Emergency Contact", value: emgContact)
            }

            // 📌 Donation History (Editable)
            Section(header: Text("Donation History")) {
                DatePicker("Last Donation Date", selection: $lastDonationDate, displayedComponents: .date)
                if !isEligibleDonation {
                    Text("⚠️ Last donation must be more than 3 months ago.")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }

            // 📌 Permissions
            Section(header: Text("Permissions")) {
                Toggle(isOn: $consentGiven) {
                    Text("I consent to be contacted for donation")
                }
                Toggle(isOn: $locationPermission) {
                    Text("I give permission for live location tracking")
                }
                Toggle(isOn: $healthCriteriaMet) {
                    Text("I confirm I meet the blood donation health criteria")
                }
            }

            // 📌 Submit Button
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

            // 📌 Age restriction warning
            if calculatedAge < 18 {
                Text("You must be 18 or older to register as a donor.")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
        }
        .navigationTitle("Register as Donor")
    }

    // MARK: - Helper Views
    func displayRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value).foregroundColor(.secondary)
        }
    }

    // MARK: - Logic
    var calculatedAge: Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        return ageComponents.year ?? 0
    }

    var isEligibleDonation: Bool {
        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date()
        return lastDonationDate <= threeMonthsAgo
    }

    var formIsValid: Bool {
        calculatedAge >= 18 &&
        consentGiven &&
        locationPermission &&
        healthCriteriaMet && // ✅ Must meet health criteria
        isEligibleDonation
    }

    func handleSubmit() {
        print("✅ Donor Registered:")
        print("Name: \(fullName)")
        print("DOB: \(dateOfBirth)")
        print("Age: \(calculatedAge)")
        print("Blood Group: \(bloodGroup)")
        print("Contact: \(contactNumber)")
        print("Address: \(address)")
        print("Emergency Contact: \(emgContact)")
        print("Last Donation: \(lastDonationDate)")
        print("Consent Given: \(consentGiven)")
        print("Location Permission: \(locationPermission)")
        print("Health Criteria Met: \(healthCriteriaMet)")
    }
}

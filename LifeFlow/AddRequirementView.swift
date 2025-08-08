import SwiftUI

struct AddRequirementView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var requirements: [BloodRequirement]

    @State private var hospitalName = ""
    @State private var bloodGroup = "A+"
    @State private var quantity = 1
    @State private var urgencyLevel = "High"
    @State private var contactNumber = ""

    let bloodGroups = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
    let urgencyLevels = ["High", "Medium", "Low"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Hospital Details")) {
                    TextField("Hospital Name", text: $hospitalName)
                    TextField("Contact Number", text: $contactNumber)
                        .keyboardType(.phonePad)
                }

                Section(header: Text("Requirement Details")) {
                    Picker("Blood Group", selection: $bloodGroup) {
                        ForEach(bloodGroups, id: \.self) { Text($0) }
                    }

                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)

                    Picker("Urgency", selection: $urgencyLevel) {
                        ForEach(urgencyLevels, id: \.self) { Text($0) }
                    }
                }
            }
            .navigationTitle("Add Requirement")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let new = BloodRequirement(
                            hospital: hospitalName,
                            bloodGroup: bloodGroup,
                            unitsNeeded: quantity,
                            urgency: urgencyLevel
                        )
                        requirements.append(new)
                        dismiss()
                    }
                    .disabled(hospitalName.isEmpty || contactNumber.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

import SwiftUI

struct BloodRequirementsView: View {
    @State private var selectedBloodGroup = "All"
    @State private var selectedUrgency = "All"

    let bloodGroups = ["All", "A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
    let urgencies = ["All", "High", "Medium", "Low"]

    let requirements: [BloodRequirement] = [
        BloodRequirement(hospital: "Apollo Hospital", bloodGroup: "A+", unitsNeeded: 2, urgency: "High"),
        BloodRequirement(hospital: "Fortis", bloodGroup: "B-", unitsNeeded: 1, urgency: "Medium"),
        BloodRequirement(hospital: "AMRI", bloodGroup: "O+", unitsNeeded: 3, urgency: "Low"),
        BloodRequirement(hospital: "Ruby", bloodGroup: "AB+", unitsNeeded: 2, urgency: "High")
    ]

    var filteredRequirements: [BloodRequirement] {
        requirements.filter { req in
            (selectedBloodGroup == "All" || req.bloodGroup == selectedBloodGroup) &&
            (selectedUrgency == "All" || req.urgency == selectedUrgency)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Filters
                HStack {
                    Picker("Blood Group", selection: $selectedBloodGroup) {
                        ForEach(bloodGroups, id: \.self) { Text($0) }
                    }
                    .pickerStyle(MenuPickerStyle())

                    Picker("Urgency", selection: $selectedUrgency) {
                        ForEach(urgencies, id: \.self) { Text($0) }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding()

                List(filteredRequirements) { req in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(req.hospital).font(.headline)
                        Text("Blood Group: \(req.bloodGroup)")
                        Text("Units Needed: \(req.unitsNeeded)")
                        Text("Urgency: \(req.urgency)")
                            .foregroundColor(req.urgency == "High" ? .red : (req.urgency == "Medium" ? .orange : .green))
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Blood Requirements")
        }
    }
}

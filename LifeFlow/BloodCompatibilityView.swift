import SwiftUI

struct BloodCompatibilityView: View {
    @State private var selectedBloodGroup: String = "A+"
    
    let bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    
    // Compatibility Data
    let compatibility: [String: (donate: [String], receive: [String])] = [
        "A+": (donate: ["A+", "AB+"], receive: ["A+", "A-", "O+", "O-"]),
        "A-": (donate: ["A+", "A-", "AB+", "AB-"], receive: ["A-", "O-"]),
        "B+": (donate: ["B+", "AB+"], receive: ["B+", "B-", "O+", "O-"]),
        "B-": (donate: ["B+", "B-", "AB+", "AB-"], receive: ["B-", "O-"]),
        "AB+": (donate: ["AB+"], receive: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]), // Universal Receiver
        "AB-": (donate: ["AB+", "AB-"], receive: ["A-", "B-", "AB-", "O-"]),
        "O+": (donate: ["O+", "A+", "B+", "AB+"], receive: ["O+", "O-"]),
        "O-": (donate: ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"], receive: ["O-"]) // Universal Donor
    ]
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Blood Compatibility Checker")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Picker("Select Blood Group", selection: $selectedBloodGroup) {
                ForEach(bloodGroups, id: \.self) { group in
                    Text(group).tag(group)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            if let data = compatibility[selectedBloodGroup] {
                VStack(alignment: .leading, spacing: 15) {
                    Text("You Can Donate To:")
                        .font(.headline)
                    Text(data.donate.joined(separator: ", "))
                        .foregroundColor(.green)
                        .font(.body)
                    
                    Divider()
                    
                    Text("You Can Receive From:")
                        .font(.headline)
                    Text(data.receive.joined(separator: ", "))
                        .foregroundColor(.red)
                        .font(.body)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationTitle("Blood Compatibility")
        .navigationBarTitleDisplayMode(.inline)
    }
}



import SwiftUI

struct DonationRecord: Identifiable {
    var id = UUID()
    let date: String
    let location: String
    let bloodGroup: String
}

struct DonationHistoryView: View {
    @State private var donations: [DonationRecord] = [
        DonationRecord(date: "2025-01-10", location: "Kolkata Medical", bloodGroup: "O+"),
        DonationRecord(date: "2025-03-15", location: "AIIMS Delhi", bloodGroup: "O+"),
        DonationRecord(date: "2025-07-01", location: "Ruby Hospital", bloodGroup: "O+")
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(donations) { record in
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Date: \(record.date)")
                            .fontWeight(.medium)
                        Text("Location: \(record.location)")
                        Text("Blood Group: \(record.bloodGroup)")
                            .foregroundColor(.red)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Donation History")
        }
    }
}
